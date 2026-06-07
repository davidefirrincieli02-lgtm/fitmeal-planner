# FitMeal Planner

FitMeal Planner is a small Flask + PostgreSQL web application for fitness and nutrition planning. Users can search foods, create meals, add meal items with quantities, and log meals to a daily nutrition diary.

## Assignment checklist

* Git repository for source code and documentation
* E/R diagram in docs/ER.md
* SQL database schema and seed scripts in db/
* Web app interacts with PostgreSQL through SQL statements
* Regex feature: the food search parses terms such as chicken protein>=20 calories<300
* AI declaration in AI_DECLARATION.md
* Bonus: SQL views and triggers in db/schema.sql

## Requirements

* Python 3.10+
* PostgreSQL 16+
* A local PostgreSQL database named fitmeal_planner

## Setup

### 1. Create the PostgreSQL database

Create a PostgreSQL database named:

text
fitmeal_planner


Using pgAdmin:

1. Open pgAdmin.
2. Connect to your PostgreSQL server.
3. Right-click *Databases*.
4. Choose *Create → Database...*
5. Set the database name to:

text
fitmeal_planner


6. Set the owner to your PostgreSQL user, usually:

text
postgres


7. Click *Save*.

## 2. Create a virtual environment and install dependencies

From the repository folder, run:

bash
python -m venv .venv


Activate the virtual environment.



On Windows Command Prompt:

cmd
.venv\Scripts\activate.bat


On macOS/Linux:

bash
source .venv/bin/activate


Then install dependencies:

bash
pip install -r requirements.txt


## 3. Initialize the database

The database is initialized with two SQL files:

text
db/schema.sql
db/seed.sql


`schema.sql` creates the tables, views, functions, and triggers.

`seed.sql` inserts demo data, including a demo user, example meals, and a selected food dataset.

Using pgAdmin:

1. Open pgAdmin.
2. Select the database `fitmeal_planner`.
3. Open **Tools → Query Tool**.
4. Open or paste the contents of:

text
db/schema.sql


5. Execute the script.
6. Then open or paste the contents of:

text
db/seed.sql


7. Execute the script.

The order matters:

text
1. Run db/schema.sql
2. Run db/seed.sql


Do not run `schema.sql` again after `seed.sql`, because `schema.sql` drops and recreates the tables.

To check that the food data was inserted, run this query in pgAdmin:

sql
SELECT COUNT(*) FROM food;


You can also preview the food table with:

sql
SELECT * FROM food LIMIT 10;


## 4. Set the database connection

The app connects to PostgreSQL through the `DATABASE_URL` environment variable.

Use the PostgreSQL password for your local `postgres` user.

### Windows PowerShell

powershell
$env:DATABASE_URL="postgresql://postgres:YOUR_PASSWORD@localhost:5432/fitmeal_planner"


### Windows Command Prompt

cmd
set DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/fitmeal_planner


### macOS/Linux

bash
export DATABASE_URL="postgresql://postgres:YOUR_PASSWORD@localhost:5432/fitmeal_planner"


Replace `YOUR_PASSWORD` with your actual PostgreSQL password.

Example:

cmd
set DATABASE_URL=postgresql://postgres:myPassword123@localhost:5432/fitmeal_planner


## 5. Run the app

From the repository folder, with the virtual environment activated and `DATABASE_URL` set, run:

bash
python app.py


Then open:

text
http://127.0.0.1:5000


## How to interact with the web app

1. Use the food search box on the front page.

2. Try regex-parsed searches, for example:

   * `chicken protein>=20`
   * `calories<200 fats<5`
   * `rice carbs>20`

3. Create a new meal.

4. Open the meal and add foods with quantities in grams.

5. Open the daily log page, create a log for a date, and add meals to it.

6. The daily totals update through SQL views and triggers.

## SQL features demonstrated

The web app interacts with the PostgreSQL database through SQL statements.

Examples:

* `SELECT`: food search
* `INSERT`: create meals, add meal items, create daily logs
* `DELETE`: remove meal items or logged meals
* Regex parsing: search terms such as `protein>=20 calories<300`
* SQL views: `meal_nutrition` and `daily_log_summary`
* SQL triggers: automatic refresh of daily nutrition totals

## Data source

The food data used in this project is based on Frida Food Data, the Danish Food Composition Database published by the National Food Institute, Technical University of Denmark (DTU).

Frida contains nutrient information for foods available on the Danish market. For this project, we use a manually selected subset of common food items rather than the full database. This keeps the project scope manageable while still using a real European nutrition data source.

For each food item, the application stores nutrition values per 100g:

* Energy in kcal
* Protein
* Carbohydrates
* Fat

The selected subset is inserted into the PostgreSQL database through:

text
db/seed.sql


Source: Frida Food Data, National Food Institute, Technical University of Denmark.

## Repository access

Before submission, ensure that the instructors and Meta-TA have read access to the repository, or make the repository public.

## AI declaration

An AI declaration is included in:

text
AI_DECLARATION.md
```

The declaration describes how AI tools were used during planning, coding, debugging, and documentation.
