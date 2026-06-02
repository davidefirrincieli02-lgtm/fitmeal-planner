DROP TABLE IF EXISTS daily_log_meal CASCADE;
DROP TABLE IF EXISTS daily_log CASCADE;
DROP TABLE IF EXISTS meal_item CASCADE;
DROP TABLE IF EXISTS meal CASCADE;
DROP TABLE IF EXISTS food CASCADE;
DROP TABLE IF EXISTS app_user CASCADE;

DROP FUNCTION IF EXISTS refresh_daily_log_totals(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS trg_refresh_daily_log_after_log_meal_change() CASCADE;
DROP FUNCTION IF EXISTS trg_refresh_daily_log_after_meal_item_change() CASCADE;

CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    weight_kg NUMERIC(5,2),
    goal_type VARCHAR(20) NOT NULL CHECK (goal_type IN ('cutting', 'maintenance', 'bulking')),
    calorie_target INTEGER NOT NULL CHECK (calorie_target > 0)
);

CREATE TABLE food (
    food_id SERIAL PRIMARY KEY,
    source_food_id VARCHAR(50),
    name VARCHAR(200) NOT NULL UNIQUE,
    calories NUMERIC(8,2) NOT NULL CHECK (calories >= 0),
    protein NUMERIC(8,2) NOT NULL CHECK (protein >= 0),
    carbs NUMERIC(8,2) NOT NULL CHECK (carbs >= 0),
    fats NUMERIC(8,2) NOT NULL CHECK (fats >= 0),
    source VARCHAR(150) DEFAULT 'Frida Food Data, DTU National Food Institute'
);

CREATE INDEX idx_food_name_lower ON food (LOWER(name));

CREATE TABLE meal (
    meal_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    meal_type VARCHAR(20) NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'other')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE meal_item (
    meal_item_id SERIAL PRIMARY KEY,
    meal_id INTEGER NOT NULL REFERENCES meal(meal_id) ON DELETE CASCADE,
    food_id INTEGER NOT NULL REFERENCES food(food_id),
    quantity_grams NUMERIC(8,2) NOT NULL CHECK (quantity_grams > 0)
);

CREATE TABLE daily_log (
    log_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
    log_date DATE NOT NULL,
    total_calories NUMERIC(10,2) NOT NULL DEFAULT 0,
    total_protein NUMERIC(10,2) NOT NULL DEFAULT 0,
    total_carbs NUMERIC(10,2) NOT NULL DEFAULT 0,
    total_fats NUMERIC(10,2) NOT NULL DEFAULT 0,
    UNIQUE (user_id, log_date)
);

CREATE TABLE daily_log_meal (
    log_meal_id SERIAL PRIMARY KEY,
    log_id INTEGER NOT NULL REFERENCES daily_log(log_id) ON DELETE CASCADE,
    meal_id INTEGER NOT NULL REFERENCES meal(meal_id) ON DELETE CASCADE,
    UNIQUE (log_id, meal_id)
);

CREATE VIEW meal_nutrition AS
SELECT
    m.meal_id,
    m.user_id,
    m.name,
    m.meal_type,
    COALESCE(SUM(f.calories * mi.quantity_grams / 100), 0)::NUMERIC(10,2) AS calories,
    COALESCE(SUM(f.protein  * mi.quantity_grams / 100), 0)::NUMERIC(10,2) AS protein,
    COALESCE(SUM(f.carbs    * mi.quantity_grams / 100), 0)::NUMERIC(10,2) AS carbs,
    COALESCE(SUM(f.fats     * mi.quantity_grams / 100), 0)::NUMERIC(10,2) AS fats
FROM meal m
LEFT JOIN meal_item mi ON m.meal_id = mi.meal_id
LEFT JOIN food f ON mi.food_id = f.food_id
GROUP BY m.meal_id, m.user_id, m.name, m.meal_type;

CREATE VIEW daily_log_summary AS
SELECT
    dl.log_id,
    dl.user_id,
    dl.log_date,
    COALESCE(SUM(mn.calories), 0)::NUMERIC(10,2) AS calories,
    COALESCE(SUM(mn.protein), 0)::NUMERIC(10,2) AS protein,
    COALESCE(SUM(mn.carbs), 0)::NUMERIC(10,2) AS carbs,
    COALESCE(SUM(mn.fats), 0)::NUMERIC(10,2) AS fats
FROM daily_log dl
LEFT JOIN daily_log_meal dlm ON dl.log_id = dlm.log_id
LEFT JOIN meal_nutrition mn ON dlm.meal_id = mn.meal_id
GROUP BY dl.log_id, dl.user_id, dl.log_date;

CREATE OR REPLACE FUNCTION refresh_daily_log_totals(target_log_id INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE daily_log dl
    SET
        total_calories = COALESCE(s.calories, 0),
        total_protein = COALESCE(s.protein, 0),
        total_carbs = COALESCE(s.carbs, 0),
        total_fats = COALESCE(s.fats, 0)
    FROM (
        SELECT
            dl.log_id,
            COALESCE(SUM(mn.calories), 0)::NUMERIC(10,2) AS calories,
            COALESCE(SUM(mn.protein), 0)::NUMERIC(10,2) AS protein,
            COALESCE(SUM(mn.carbs), 0)::NUMERIC(10,2) AS carbs,
            COALESCE(SUM(mn.fats), 0)::NUMERIC(10,2) AS fats
        FROM daily_log dl
        LEFT JOIN daily_log_meal dlm ON dl.log_id = dlm.log_id
        LEFT JOIN meal_nutrition mn ON dlm.meal_id = mn.meal_id
        WHERE dl.log_id = target_log_id
        GROUP BY dl.log_id
    ) s
    WHERE dl.log_id = s.log_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trg_refresh_daily_log_after_log_meal_change()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        PERFORM refresh_daily_log_totals(NEW.log_id);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        PERFORM refresh_daily_log_totals(OLD.log_id);
        PERFORM refresh_daily_log_totals(NEW.log_id);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        PERFORM refresh_daily_log_totals(OLD.log_id);
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER refresh_daily_log_after_log_meal_change
AFTER INSERT OR UPDATE OR DELETE ON daily_log_meal
FOR EACH ROW
EXECUTE FUNCTION trg_refresh_daily_log_after_log_meal_change();

CREATE OR REPLACE FUNCTION trg_refresh_daily_log_after_meal_item_change()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        PERFORM refresh_daily_log_totals(dlm.log_id)
        FROM daily_log_meal dlm
        WHERE dlm.meal_id = NEW.meal_id;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        PERFORM refresh_daily_log_totals(dlm.log_id)
        FROM daily_log_meal dlm
        WHERE dlm.meal_id IN (OLD.meal_id, NEW.meal_id);

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        PERFORM refresh_daily_log_totals(dlm.log_id)
        FROM daily_log_meal dlm
        WHERE dlm.meal_id = OLD.meal_id;

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER refresh_daily_log_after_meal_item_change
AFTER INSERT OR UPDATE OR DELETE ON meal_item
FOR EACH ROW
EXECUTE FUNCTION trg_refresh_daily_log_after_meal_item_change();
