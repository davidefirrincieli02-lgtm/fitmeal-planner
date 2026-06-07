import os
import re
from datetime import date
from decimal import Decimal

import psycopg2
import psycopg2.extras
from dotenv import load_dotenv
from flask import Flask, flash, redirect, render_template, request, url_for

load_dotenv()

app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET_KEY", "dev-secret-key")

DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "dbname=fitmeal user=postgres password=postgres host=localhost port=5432",
)

# This is the regular-expression feature required by the assignment.
# It parses advanced search terms such as: chicken protein>=20 calories<300
MACRO_FILTER_RE = re.compile(
    r"\b(?P<field>calories|protein|carbs|fats)\s*"
    r"(?P<op><=|>=|=|<|>)\s*"
    r"(?P<value>\d+(?:\.\d+)?)\b",
    re.IGNORECASE,
)
SAFE_TEXT_RE = re.compile(r"^[\w\s,.'\-æøåÆØÅ]*$", re.UNICODE)


def get_db():
    return psycopg2.connect(DATABASE_URL, cursor_factory=psycopg2.extras.RealDictCursor)


def fetch_all(sql, params=None):
    with get_db() as conn:
        with conn.cursor() as cur:
            cur.execute(sql, params or [])
            return cur.fetchall()


def fetch_one(sql, params=None):
    with get_db() as conn:
        with conn.cursor() as cur:
            cur.execute(sql, params or [])
            return cur.fetchone()


def execute(sql, params=None):
    with get_db() as conn:
        with conn.cursor() as cur:
            cur.execute(sql, params or [])
            conn.commit()


def parse_food_search(raw_query):
    """Return a safe name term and macro filters parsed with regular expressions."""
    filters = []

    def collect_filter(match):
        filters.append(
            {
                "field": match.group("field").lower(),
                "op": match.group("op"),
                "value": Decimal(match.group("value")),
            }
        )
        return " "

    remaining_text = MACRO_FILTER_RE.sub(collect_filter, raw_query or "").strip()
    remaining_text = re.sub(r"\s+", " ", remaining_text)

    if not SAFE_TEXT_RE.fullmatch(remaining_text):
        raise ValueError("Search text contains unsupported characters.")

    return remaining_text, filters


def search_foods(raw_query):
    name_term, filters = parse_food_search(raw_query)
    sql = ["SELECT * FROM food WHERE 1=1"]
    params = []

    if name_term:
        sql.append("AND LOWER(name) LIKE LOWER(%s)")
        params.append(f"%{name_term}%")

    for filter_ in filters:
        sql.append(f"AND {filter_['field']} {filter_['op']} %s")
        params.append(filter_["value"])

    sql.append("ORDER BY name LIMIT 50")
    return fetch_all(" ".join(sql), params), name_term, filters


@app.route("/")
def index():
    q = request.args.get("q", "")
    try:
        foods, name_term, filters = search_foods(q)
        parse_error = None
    except ValueError as exc:
        foods, name_term, filters = [], "", []
        parse_error = str(exc)

    meals = fetch_all(
        """
        SELECT m.*, mn.calories, mn.protein, mn.carbs, mn.fats
        FROM meal m
        JOIN meal_nutrition mn ON m.meal_id = mn.meal_id
        ORDER BY m.created_at DESC
        """
    )
    logs = fetch_all(
        """
        SELECT dl.*, u.calorie_target
        FROM daily_log dl
        JOIN app_user u ON dl.user_id = u.user_id
        ORDER BY dl.log_date DESC
        LIMIT 10
        """
    )
    return render_template(
        "index.html",
        foods=foods,
        meals=meals,
        logs=logs,
        q=q,
        name_term=name_term,
        filters=filters,
        parse_error=parse_error,
    )


@app.route("/meals/new", methods=["POST"])
def create_meal():
    user_id = int(request.form.get("user_id", 1))
    name = request.form["name"].strip()
    meal_type = request.form["meal_type"]
    if not name:
        flash("Meal name is required.")
        return redirect(url_for("index"))

    execute(
        "INSERT INTO meal (user_id, name, meal_type) VALUES (%s, %s, %s)",
        [user_id, name, meal_type],
    )
    flash("Meal created.")
    return redirect(url_for("index"))


@app.route("/meals/<int:meal_id>")
def meal_detail(meal_id):
    meal = fetch_one(
        """
        SELECT m.*, mn.calories, mn.protein, mn.carbs, mn.fats
        FROM meal m
        JOIN meal_nutrition mn ON m.meal_id = mn.meal_id
        WHERE m.meal_id = %s
        """,
        [meal_id],
    )
    if not meal:
        flash("Meal not found.")
        return redirect(url_for("index"))

    items = fetch_all(
        """
        SELECT mi.meal_item_id, mi.quantity_grams, f.*,
               (f.calories * mi.quantity_grams / 100)::NUMERIC(10,2) AS item_calories,
               (f.protein * mi.quantity_grams / 100)::NUMERIC(10,2) AS item_protein,
               (f.carbs * mi.quantity_grams / 100)::NUMERIC(10,2) AS item_carbs,
               (f.fats * mi.quantity_grams / 100)::NUMERIC(10,2) AS item_fats
        FROM meal_item mi
        JOIN food f ON mi.food_id = f.food_id
        WHERE mi.meal_id = %s
        ORDER BY f.name
        """,
        [meal_id],
    )
    foods = fetch_all("SELECT food_id, name FROM food ORDER BY name")
    return render_template("meal.html", meal=meal, items=items, foods=foods)


@app.route("/meals/<int:meal_id>/items", methods=["POST"])
def add_meal_item(meal_id):
    food_id = int(request.form["food_id"])
    quantity_grams = Decimal(request.form["quantity_grams"])
    execute(
        "INSERT INTO meal_item (meal_id, food_id, quantity_grams) VALUES (%s, %s, %s)",
        [meal_id, food_id, quantity_grams],
    )
    flash("Food added to meal.")
    return redirect(url_for("meal_detail", meal_id=meal_id))


@app.route("/items/<int:meal_item_id>/delete", methods=["POST"])
def delete_meal_item(meal_item_id):
    item = fetch_one("SELECT meal_id FROM meal_item WHERE meal_item_id = %s", [meal_item_id])
    if item:
        execute("DELETE FROM meal_item WHERE meal_item_id = %s", [meal_item_id])
        flash("Food removed from meal.")
        return redirect(url_for("meal_detail", meal_id=item["meal_id"]))
    return redirect(url_for("index"))


@app.route("/meals/<int:meal_id>/delete", methods=["POST"])
def delete_meal(meal_id):
    # Remove dependencies first to avoid foreign key constraints errors
    execute("DELETE FROM meal_item WHERE meal_id = %s", [meal_id])
    execute("DELETE FROM daily_log_meal WHERE meal_id = %s", [meal_id])
    
    # Finally, delete the meal itself
    execute("DELETE FROM meal WHERE meal_id = %s", [meal_id])
    
    flash("Meal deleted successfully.")
    return redirect(url_for("index"))


@app.route("/logs", methods=["GET", "POST"])
def logs():
    if request.method == "POST":
        user_id = int(request.form.get("user_id", 1))
        log_date = request.form.get("log_date") or date.today().isoformat()
        execute(
            """
            INSERT INTO daily_log (user_id, log_date)
            VALUES (%s, %s)
            ON CONFLICT (user_id, log_date) DO NOTHING
            """,
            [user_id, log_date],
        )
        flash("Daily log ready.")
        return redirect(url_for("logs", log_date=log_date))

    selected_date = request.args.get("log_date", date.today().isoformat())
    log = fetch_one(
        """
        SELECT dl.*, u.name AS user_name, u.calorie_target
        FROM daily_log dl
        JOIN app_user u ON dl.user_id = u.user_id
        WHERE dl.log_date = %s
        ORDER BY dl.log_id
        LIMIT 1
        """,
        [selected_date],
    )
    logged_meals = []
    if log:
        logged_meals = fetch_all(
            """
            SELECT dlm.log_meal_id, m.name, m.meal_type, mn.*
            FROM daily_log_meal dlm
            JOIN meal m ON dlm.meal_id = m.meal_id
            JOIN meal_nutrition mn ON m.meal_id = mn.meal_id
            WHERE dlm.log_id = %s
            ORDER BY m.name
            """,
            [log["log_id"]],
        )
    meals = fetch_all("SELECT meal_id, name FROM meal ORDER BY name")
    return render_template("logs.html", log=log, logged_meals=logged_meals, meals=meals, selected_date=selected_date)


@app.route("/logs/<int:log_id>/meals", methods=["POST"])
def add_meal_to_log(log_id):
    meal_id = int(request.form["meal_id"])
    execute(
        "INSERT INTO daily_log_meal (log_id, meal_id) VALUES (%s, %s) ON CONFLICT DO NOTHING",
        [log_id, meal_id],
    )
    flash("Meal added to log.")
    return redirect(url_for("logs"))


@app.route("/logged-meals/<int:log_meal_id>/delete", methods=["POST"])
def delete_logged_meal(log_meal_id):
    execute("DELETE FROM daily_log_meal WHERE log_meal_id = %s", [log_meal_id])
    flash("Meal removed from log.")
    return redirect(url_for("logs"))


@app.route("/users/target", methods=["POST"])
def update_calorie_target():
    # Get user_id from the form (defaulting to 1 for local testing)
    user_id = int(request.form.get("user_id", 1)) 
    new_target = int(request.form["calorie_target"])
    
    # Update the target calories in the database
    execute(
        "UPDATE app_user SET calorie_target = %s WHERE user_id = %s",
        [new_target, user_id]
    )
    
    flash("Calorie target updated successfully.")
    
    # Redirect back to the previous page (index or logs)
    return redirect(request.referrer or url_for("index"))


@app.template_filter("round1")
def round1(value):
    if value is None:
        return "0.0"
    return f"{float(value):.1f}"


if __name__ == "__main__":
    app.run(debug=True)