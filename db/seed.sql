INSERT INTO app_user (name, email, weight_kg, goal_type, calorie_target)
VALUES ('Demo User', 'demo@example.com', 80.0, 'maintenance', 2500)
ON CONFLICT (email) DO NOTHING;

INSERT INTO food (name, calories, protein, carbs, fats, source)
VALUES

    ('Chicken breast, cooked', 165, 31.0, 0.0, 3.6, 'Frida Food Data / public nutrition data subset'),
    ('Chicken thigh, cooked', 209, 26.0, 0.0, 10.9, 'Frida Food Data / public nutrition data subset'),
    ('Turkey breast, cooked', 135, 29.0, 0.0, 1.6, 'Frida Food Data / public nutrition data subset'),
    ('Pork chop, cooked', 231, 25.7, 0.0, 13.9, 'Frida Food Data / public nutrition data subset'),
    ('Pork tenderloin, cooked', 143, 26.0, 0.0, 3.5, 'Frida Food Data / public nutrition data subset'),
    ('Beef steak, cooked', 250, 26.0, 0.0, 15.0, 'Frida Food Data / public nutrition data subset'),
    ('Minced beef, 10 percent fat', 176, 20.0, 0.0, 10.0, 'Frida Food Data / public nutrition data subset'),
    ('Minced beef, 20 percent fat', 254, 17.0, 0.0, 20.0, 'Frida Food Data / public nutrition data subset'),
    ('Ham, sliced', 145, 21.0, 1.5, 5.5, 'Frida Food Data / public nutrition data subset'),
    ('Bacon, cooked', 541, 37.0, 1.4, 42.0, 'Frida Food Data / public nutrition data subset'),

    ('Salmon, cooked', 206, 22.0, 0.0, 12.0, 'Frida Food Data / public nutrition data subset'),
    ('Cod, cooked', 82, 18.0, 0.0, 0.7, 'Frida Food Data / public nutrition data subset'),
    ('Tuna, canned in water', 116, 26.0, 0.0, 1.0, 'Frida Food Data / public nutrition data subset'),
    ('Mackerel, smoked', 305, 18.6, 0.0, 25.0, 'Frida Food Data / public nutrition data subset'),
    ('Shrimp, cooked', 99, 24.0, 0.2, 0.3, 'Frida Food Data / public nutrition data subset'),
    ('Herring, pickled', 262, 14.0, 9.6, 18.0, 'Frida Food Data / public nutrition data subset'),

    ('Egg, whole', 143, 12.6, 0.7, 9.5, 'Frida Food Data / public nutrition data subset'),
    ('Egg white', 52, 10.9, 0.7, 0.2, 'Frida Food Data / public nutrition data subset'),
    ('Egg yolk', 322, 15.9, 3.6, 26.5, 'Frida Food Data / public nutrition data subset'),

    ('Milk, whole', 64, 3.4, 4.8, 3.5, 'Frida Food Data / public nutrition data subset'),
    ('Milk, semi-skimmed', 47, 3.5, 4.8, 1.5, 'Frida Food Data / public nutrition data subset'),
    ('Milk, skimmed', 35, 3.5, 5.0, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('Yogurt, natural', 61, 3.5, 4.7, 3.3, 'Frida Food Data / public nutrition data subset'),
    ('Greek yogurt, plain', 59, 10.0, 3.6, 0.4, 'Frida Food Data / public nutrition data subset'),
    ('Skyr, plain', 63, 11.0, 3.5, 0.2, 'Frida Food Data / public nutrition data subset'),
    ('Cottage cheese', 98, 11.1, 3.4, 4.3, 'Frida Food Data / public nutrition data subset'),
    ('Cream cheese', 342, 6.2, 4.1, 34.0, 'Frida Food Data / public nutrition data subset'),
    ('Cheddar cheese', 403, 24.9, 1.3, 33.1, 'Frida Food Data / public nutrition data subset'),
    ('Mozzarella', 280, 28.0, 3.1, 17.0, 'Frida Food Data / public nutrition data subset'),
    ('Feta cheese', 264, 14.2, 4.1, 21.3, 'Frida Food Data / public nutrition data subset'),
    ('Butter', 717, 0.9, 0.1, 81.1, 'Frida Food Data / public nutrition data subset'),

    ('White rice, cooked', 130, 2.7, 28.0, 0.3, 'Frida Food Data / public nutrition data subset'),
    ('Brown rice, cooked', 112, 2.6, 23.0, 0.9, 'Frida Food Data / public nutrition data subset'),
    ('Pasta, cooked', 157, 5.8, 30.9, 0.9, 'Frida Food Data / public nutrition data subset'),
    ('Whole wheat pasta, cooked', 124, 5.3, 26.5, 0.5, 'Frida Food Data / public nutrition data subset'),
    ('Oats', 389, 16.9, 66.3, 6.9, 'Frida Food Data / public nutrition data subset'),
    ('Rye bread', 259, 8.5, 48.0, 3.3, 'Frida Food Data / public nutrition data subset'),
    ('White bread', 265, 9.0, 49.0, 3.2, 'Frida Food Data / public nutrition data subset'),
    ('Whole wheat bread', 247, 13.0, 41.0, 4.2, 'Frida Food Data / public nutrition data subset'),
    ('Tortilla wrap', 310, 8.0, 52.0, 8.0, 'Frida Food Data / public nutrition data subset'),
    ('Crispbread', 350, 10.0, 65.0, 2.0, 'Frida Food Data / public nutrition data subset'),
    ('Cornflakes', 357, 7.5, 84.0, 0.4, 'Frida Food Data / public nutrition data subset'),
    ('Muesli', 360, 10.0, 65.0, 6.0, 'Frida Food Data / public nutrition data subset'),
    ('Flour, wheat', 364, 10.0, 76.0, 1.0, 'Frida Food Data / public nutrition data subset'),
    ('Quinoa, cooked', 120, 4.4, 21.3, 1.9, 'Frida Food Data / public nutrition data subset'),

    ('Potato, boiled', 87, 1.9, 20.1, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('Potato, baked', 93, 2.5, 21.2, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('French fries', 312, 3.4, 41.0, 15.0, 'Frida Food Data / public nutrition data subset'),
    ('Sweet potato, baked', 90, 2.0, 20.7, 0.2, 'Frida Food Data / public nutrition data subset'),

    ('Apple', 52, 0.3, 14.0, 0.2, 'Frida Food Data / public nutrition data subset'),
    ('Banana', 89, 1.1, 22.8, 0.3, 'Frida Food Data / public nutrition data subset'),
    ('Orange', 47, 0.9, 11.8, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('Pear', 57, 0.4, 15.0, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('Grapes', 69, 0.7, 18.1, 0.2, 'Frida Food Data / public nutrition data subset'),
    ('Strawberries', 32, 0.7, 7.7, 0.3, 'Frida Food Data / public nutrition data subset'),
    ('Blueberries', 57, 0.7, 14.5, 0.3, 'Frida Food Data / public nutrition data subset'),
    ('Raspberries', 52, 1.2, 12.0, 0.7, 'Frida Food Data / public nutrition data subset'),
    ('Pineapple', 50, 0.5, 13.1, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('Mango', 60, 0.8, 15.0, 0.4, 'Frida Food Data / public nutrition data subset'),
    ('Kiwi', 61, 1.1, 14.7, 0.5, 'Frida Food Data / public nutrition data subset'),
    ('Avocado', 160, 2.0, 8.5, 14.7, 'Frida Food Data / public nutrition data subset'),

    ('Carrot, raw', 41, 0.9, 9.6, 0.2, 'Frida Food Data / public nutrition data subset'),
    ('Broccoli, cooked', 35, 2.4, 7.2, 0.4, 'Frida Food Data / public nutrition data subset'),
    ('Cauliflower, cooked', 25, 1.9, 5.0, 0.3, 'Frida Food Data / public nutrition data subset'),
    ('Cucumber', 15, 0.7, 3.6, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('Tomato', 18, 0.9, 3.9, 0.2, 'Frida Food Data / public nutrition data subset'),
    ('Bell pepper, red', 31, 1.0, 6.0, 0.3, 'Frida Food Data / public nutrition data subset'),
    ('Onion', 40, 1.1, 9.3, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('Garlic', 149, 6.4, 33.1, 0.5, 'Frida Food Data / public nutrition data subset'),
    ('Spinach, raw', 23, 2.9, 3.6, 0.4, 'Frida Food Data / public nutrition data subset'),
    ('Lettuce', 15, 1.4, 2.9, 0.2, 'Frida Food Data / public nutrition data subset'),
    ('Peas, green', 81, 5.4, 14.5, 0.4, 'Frida Food Data / public nutrition data subset'),
    ('Corn, sweet', 86, 3.2, 19.0, 1.2, 'Frida Food Data / public nutrition data subset'),
    ('Mushrooms', 22, 3.1, 3.3, 0.3, 'Frida Food Data / public nutrition data subset'),

    ('Lentils, cooked', 116, 9.0, 20.1, 0.4, 'Frida Food Data / public nutrition data subset'),
    ('Chickpeas, cooked', 164, 8.9, 27.4, 2.6, 'Frida Food Data / public nutrition data subset'),
    ('Kidney beans, cooked', 127, 8.7, 22.8, 0.5, 'Frida Food Data / public nutrition data subset'),
    ('Black beans, cooked', 132, 8.9, 23.7, 0.5, 'Frida Food Data / public nutrition data subset'),
    ('Tofu', 76, 8.1, 1.9, 4.8, 'Frida Food Data / public nutrition data subset'),
    ('Hummus', 166, 7.9, 14.3, 9.6, 'Frida Food Data / public nutrition data subset'),

    ('Almonds', 579, 21.2, 21.6, 49.9, 'Frida Food Data / public nutrition data subset'),
    ('Walnuts', 654, 15.2, 13.7, 65.2, 'Frida Food Data / public nutrition data subset'),
    ('Peanuts', 567, 25.8, 16.1, 49.2, 'Frida Food Data / public nutrition data subset'),
    ('Cashew nuts', 553, 18.2, 30.2, 43.9, 'Frida Food Data / public nutrition data subset'),
    ('Peanut butter', 588, 25.0, 20.0, 50.0, 'Frida Food Data / public nutrition data subset'),
    ('Chia seeds', 486, 16.5, 42.1, 30.7, 'Frida Food Data / public nutrition data subset'),
    ('Sunflower seeds', 584, 20.8, 20.0, 51.5, 'Frida Food Data / public nutrition data subset'),

    ('Olive oil', 884, 0.0, 0.0, 100.0, 'Frida Food Data / public nutrition data subset'),
    ('Rapeseed oil', 884, 0.0, 0.0, 100.0, 'Frida Food Data / public nutrition data subset'),
    ('Coconut oil', 892, 0.0, 0.0, 99.1, 'Frida Food Data / public nutrition data subset'),
    ('Mayonnaise', 680, 1.0, 0.6, 75.0, 'Frida Food Data / public nutrition data subset'),

    ('Dark chocolate', 546, 4.9, 61.0, 31.0, 'Frida Food Data / public nutrition data subset'),
    ('Milk chocolate', 535, 7.7, 59.4, 29.7, 'Frida Food Data / public nutrition data subset'),
    ('Sugar', 387, 0.0, 100.0, 0.0, 'Frida Food Data / public nutrition data subset'),
    ('Honey', 304, 0.3, 82.4, 0.0, 'Frida Food Data / public nutrition data subset'),
    ('Jam', 278, 0.4, 69.0, 0.1, 'Frida Food Data / public nutrition data subset'),

    ('Coffee, brewed', 1, 0.1, 0.0, 0.0, 'Frida Food Data / public nutrition data subset'),
    ('Orange juice', 45, 0.7, 10.4, 0.2, 'Frida Food Data / public nutrition data subset'),
    ('Apple juice', 46, 0.1, 11.3, 0.1, 'Frida Food Data / public nutrition data subset'),
    ('Cola', 42, 0.0, 10.6, 0.0, 'Frida Food Data / public nutrition data subset'),

    ('Pizza, cheese', 266, 11.0, 33.0, 10.0, 'Frida Food Data / public nutrition data subset'),
    ('Lasagna', 135, 7.0, 12.0, 6.0, 'Frida Food Data / public nutrition data subset'),
    ('Burger bun', 270, 8.5, 50.0, 4.0, 'Frida Food Data / public nutrition data subset'),
    ('Sausage, pork', 301, 12.0, 2.0, 27.0, 'Frida Food Data / public nutrition data subset'),
    ('Meatballs', 250, 15.0, 8.0, 18.0, 'Frida Food Data / public nutrition data subset')
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
