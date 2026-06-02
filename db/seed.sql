INSERT INTO app_user (name, email, weight_kg, goal_type, calorie_target)
VALUES ('Demo User', 'demo@example.com', 80.0, 'maintenance', 2500)
ON CONFLICT (email) DO NOTHING;

INSERT INTO food (name, calories, protein, carbs, fats, source)
VALUES
    ('Chicken breast, cooked', 165, 31.0, 0.0, 3.6, 'sample inspired by public nutrition data'),
    ('Salmon, cooked', 206, 22.0, 0.0, 12.0, 'sample inspired by public nutrition data'),
    ('White rice, cooked', 130, 2.7, 28.0, 0.3, 'sample inspired by public nutrition data'),
    ('Oats', 389, 16.9, 66.3, 6.9, 'sample inspired by public nutrition data'),
    ('Greek yogurt, plain', 59, 10.0, 3.6, 0.4, 'sample inspired by public nutrition data'),
    ('Banana', 89, 1.1, 22.8, 0.3, 'sample inspired by public nutrition data'),
    ('Avocado', 160, 2.0, 8.5, 14.7, 'sample inspired by public nutrition data'),
    ('Egg, whole', 143, 12.6, 0.7, 9.5, 'sample inspired by public nutrition data'),
    ('Broccoli, cooked', 35, 2.4, 7.2, 0.4, 'sample inspired by public nutrition data'),
    ('Olive oil', 884, 0.0, 0.0, 100.0, 'sample inspired by public nutrition data')
ON CONFLICT (name) DO NOTHING;

INSERT INTO meal (user_id, name, meal_type)
SELECT user_id, 'High protein lunch', 'lunch'
FROM app_user
WHERE email = 'demo@example.com';

INSERT INTO meal_item (meal_id, food_id, quantity_grams)
SELECT m.meal_id, f.food_id, 200
FROM meal m
JOIN food f ON f.name = 'Chicken breast, cooked'
JOIN app_user u ON m.user_id = u.user_id
WHERE u.email = 'demo@example.com'
  AND m.name = 'High protein lunch';

INSERT INTO meal_item (meal_id, food_id, quantity_grams)
SELECT m.meal_id, f.food_id, 150
FROM meal m
JOIN food f ON f.name = 'White rice, cooked'
JOIN app_user u ON m.user_id = u.user_id
WHERE u.email = 'demo@example.com'
  AND m.name = 'High protein lunch';

INSERT INTO meal_item (meal_id, food_id, quantity_grams)
SELECT m.meal_id, f.food_id, 100
FROM meal m
JOIN food f ON f.name = 'Broccoli, cooked'
JOIN app_user u ON m.user_id = u.user_id
WHERE u.email = 'demo@example.com'
  AND m.name = 'High protein lunch';

INSERT INTO daily_log (user_id, log_date)
SELECT user_id, CURRENT_DATE
FROM app_user
WHERE email = 'demo@example.com'
ON CONFLICT (user_id, log_date) DO NOTHING;

INSERT INTO daily_log_meal (log_id, meal_id)
SELECT dl.log_id, m.meal_id
FROM daily_log dl
JOIN app_user u ON dl.user_id = u.user_id
JOIN meal m ON m.user_id = u.user_id
WHERE u.email = 'demo@example.com'
  AND dl.log_date = CURRENT_DATE
  AND m.name = 'High protein lunch'
ON CONFLICT (log_id, meal_id) DO NOTHING;
