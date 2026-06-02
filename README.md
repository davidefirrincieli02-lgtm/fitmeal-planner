# FitMeal Planner

FitMeal Planner is a small Flask + PostgreSQL web application for fitness and nutrition planning. Users can search foods, create meals, add meal items with quantities, and log meals to a daily nutrition diary.

## Assignment checklist

- Git repository for source code and documentation
- E/R diagram in `docs/ER.md`
- SQL database schema and seed scripts in `db/`
- Web app interacts with PostgreSQL through SQL statements
- Regex feature: the food search parses terms such as `chicken protein>=20 calories<300`
- AI declaration in `AI_DECLARATION.md`
- Bonus: SQL views and trigger in `db/schema.sql`

## Requirements

- Python 3.10+
- PostgreSQL 16+
- `psql` available on the command line

## Setup

Create a PostgreSQL database:

```bash
createdb fitmeal
```

Create a virtual environment and install dependencies:

```bash
python -m venv .venv
# Windows PowerShell:
.venv\Scripts\Activate.ps1
# macOS/Linux:
source .venv/bin/activate

pip install -r requirements.txt
```

Copy the environment template and adjust credentials if needed:

```bash
cp .env.example .env
```

On Windows PowerShell, use:

```powershell
Copy-Item .env.example .env
```

Initialize the database:

```bash
psql -d fitmeal -f db/schema.sql
psql -d fitmeal -f db/seed.sql
```

If your PostgreSQL username/password differs from the defaults, either update `.env` or pass a full connection string in `DATABASE_URL`.

## Run the app

```bash
flask --app app run --debug
```

Then open:

```text
http://127.0.0.1:5000
```

## How to interact with the web app

1. Use the food search box on the front page.
2. Try regex-parsed searches, for example:
   - `chicken protein>=20`
   - `calories<200 fats<5`
   - `rice carbs>20`
3. Create a new meal.
4. Open the meal and add foods with quantities in grams.
5. Open the daily log page, create a log for a date, and add meals to it.
6. The daily totals update through SQL views and a trigger.

## Data source

The food data used in this project comes from Frida Food Data, the Danish Food Composition Database published by the National Food Institute, Technical University of Denmark (DTU).

Frida contains nutrient information for foods available on the Danish market. For this project, we use a small manually selected subset of approximately 50–100 common food items, rather than the full database. This keeps the project scope manageable while still using a real European nutrition data source.

For each food item, the application stores nutrition values per 100g:

Energy in kcal
Protein
Carbohydrates
Fat

The original Frida dataset can be downloaded as a spreadsheet. The selected subset is inserted into the database through db/seed.sql.

Source: Frida Food Data, National Food Institute, Technical University of Denmark.

## Repository access

Before submission, ensure that the instructors and Meta-TA have read access to the repository, or make the repository public.
