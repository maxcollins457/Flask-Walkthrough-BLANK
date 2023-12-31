drop table if exists employee;
drop table if exists table_number cascade;
drop table if exists "order" cascade;
drop table if exists booking;
drop table if exists payment;
drop table if exists payroll;
drop table if exists menu_item cascade;
drop table if exists order_item cascade;
drop table if exists supplier cascade;
drop table if exists ingredient cascade;
drop table if exists recipe cascade;
drop table if exists allergen cascade;
drop table if exists ingredient_allergen cascade;
drop table if exists "location" cascade;
drop table if exists current_stock cascade;


-- Create the table_number table
CREATE TABLE IF NOT EXISTS "table_number" (
  table_id SERIAL PRIMARY KEY,
  capacity INT
);

-- Create the order table
CREATE TABLE IF NOT EXISTS "order" (
  order_id SERIAL PRIMARY KEY,
  time_ordered TIMESTAMP,
  time_delivered TIMESTAMP,
  table_id INT,
  paid BOOL DEFAULT FALSE,
  FOREIGN KEY (table_id) REFERENCES "table_number" (table_id)
);

-- Create the booking table
CREATE TABLE IF NOT EXISTS "booking" (
  booking_id SERIAL PRIMARY KEY,
  booking_name TEXT,
  group_size INT,
  contact_phone VARCHAR(20),
  contact_email TEXT,
  start_time TIMESTAMP,
  duration INTERVAL DEFAULT ('1.5 hours'), --Cannot do end_time as cannot reference start time for default
  table_id INT,
  comments VARCHAR(100),
  FOREIGN KEY (table_id) REFERENCES "table_number" (table_id)
);


-- Create the menu_item table
CREATE TABLE IF NOT EXISTS "menu_item" (
  menu_item_id SERIAL PRIMARY KEY,
  menu_item_name TEXT,
  price MONEY,
  category TEXT,
  date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_removed TIMESTAMP DEFAULT NULL
);

-- Create the order_item table
CREATE TABLE IF NOT EXISTS "order_item" (
  order_id INT,
  menu_item_id INT,
  quantity INT,
  comments VARCHAR(100),
  PRIMARY KEY (order_id, menu_item_id),
  FOREIGN KEY (order_id) REFERENCES "order" (order_id),
  FOREIGN KEY (menu_item_id) REFERENCES "menu_item" (menu_item_id)
);

--Create supplier table
CREATE TABLE IF NOT EXISTS "supplier" (
  supplier_id SERIAL PRIMARY KEY,
  supplier_name TEXT,
  supplier_address TEXT,
  supplier_phone TEXT,
  supplier_email TEXT
);

-- Create ingredient table
CREATE TABLE IF NOT EXISTS "ingredient" (
  ingredient_id SERIAL PRIMARY KEY,
  ingredient_name TEXT,
  supplier_quantity TEXT,
  low_threshold INT,
  unit TEXT,
  low_threshold_grams INT,
  supplier_id INT,
  FOREIGN KEY (supplier_id) REFERENCES "supplier" (supplier_id)
);

--Create recipe table
CREATE TABLE IF NOT EXISTS "recipe" (
  recipe_id SERIAL PRIMARY KEY,
  menu_item_id INT,
  ingredient_id INT,
  quantity NUMERIC,
  FOREIGN KEY (menu_item_id) REFERENCES "menu_item" (menu_item_id),
  FOREIGN KEY (ingredient_id) REFERENCES "ingredient" (ingredient_id)
);

-- Create allergen table
CREATE TABLE IF NOT EXISTS "allergen" (
  allergen_id SERIAL PRIMARY KEY,
  allergen_name TEXT
);

-- Create ingredient_allergen table
CREATE TABLE IF NOT EXISTS "ingredient_allergen" (
  ingredient_allergen_id SERIAL PRIMARY KEY,
  ingredient_id INT,
  allergen_id INT,
  FOREIGN KEY (ingredient_id) REFERENCES "ingredient" (ingredient_id),
  FOREIGN KEY (allergen_id) REFERENCES "allergen" (allergen_id)
);

--Create (storage) location table 
CREATE TABLE IF NOT EXISTS "location" (
  location_id SERIAL PRIMARY KEY,
  location_name TEXT
); 

-- Create current_stock table
CREATE TABLE IF NOT EXISTS "current_stock" (
  current_stock_id SERIAL PRIMARY KEY,
  ingredient_id INT,
  location_id INT,
  delivery_date DATE,
  total_cost MONEY,
  expiry_date DATE,
  quantity NUMERIC,
  FOREIGN KEY (ingredient_id) REFERENCES "ingredient" (ingredient_id),
  FOREIGN KEY (location_id) REFERENCES "location" (location_id)
);

-- INSERTING DATA

-- DELETE FROM "table_number";
-- Insert data into the table_number table
INSERT INTO "table_number" ("capacity")
VALUES
  (4),
  (4),
  (2),
  (2),
  (4),
  (5),
  (6),
  (6),
  (6),
  (6),
  (2),
  (2),
  (2),
  (6),
  (6),
  (6),
  (6),
  (6);

-- DELETE FROM "menu_item";
-- Insert data into the menu_item table
INSERT INTO "menu_item" ("menu_item_name", "price", "category")
VALUES
  ('Chicken gyros', 9.00, 'main'),
  ('Pork gyros', 9.00, 'main'),
  ('Lamb gyros', 9.50, 'main'),
  ('Halloumi gyros', 9.50, 'main'),
  ('Falafel gyros', 9.50, 'main'),
  ('Chicken souvlaki', 12.00, 'main'),
  ('Pork souvlaki', 12.00, 'main'),
  ('Lamb souvlaki', 12.50, 'main'),
  ('Chicken Fresko', 12.00, 'main'),
  ('Lamb Fresko', 12.50, 'main'),
  ('The Greek', 10.50, 'salad'),
  ('The Medi', 9.00, 'salad'),
  ('Green cola', 2.00, 'drink'),
  ('Green orangeade', 2.00, 'drink'),
  ('Green lemonade', 2.00, 'drink'),
  ('Green sour cherry', 2.00, 'drink'),
  ('Bottled water', 1.50, 'drink'),
  ('Hummus', 1.00, 'add-on'),
  ('Tzatziki', 1.00, 'add-on'),
  ('Tzatziki free', 0.00, 'add-on'),
  ('Tahini sauce', 1.00, 'add-on'),
  ('Tahini sauce free', 0.00, 'add-on'),
  ('Mint yoghurt sauce', 1.00, 'add-on'),
  ('Mint yoghurt free', 0.00, 'add-on'),
  ('Falafel', 1.50, 'add-on'),
  ('Halloumi', 1.50, 'add-on'),
  ('Crumbled feta', 1.50, 'add-on'),
  ('Pita', 2.00, 'add-on'),
  ('Pita meze', 0.00, 'add-on'),
  ('Oregano chips', 2.00, 'add-on'),
  ('Extra skewer chicken', 3.00, 'add-on'),
  ('Extra skewer lamb', 3.00, 'add-on'),
  ('Extra skewer pork', 3.00, 'add-on'),
  ('Keftedes', 5.00, 'hot meze'),
  ('Prawns Saganaki', 5.50, 'hot meze'),
  ('Calamari', 6.00, 'hot meze'),
  ('Grilled halloumi', 4.50, 'hot meze'),
  ('Garlic mushrooms', 4.00, 'hot meze'),
  ('Mixed olives', 4.00, 'cold meze'),
  ('Melitzanosalata', 4.50, 'cold meze'),
  ('Hummus meze', 4.50, 'cold meze'),
  ('Feta meze', 4.00, 'cold meze'),
  ('Tzatziki dip', 1.50, 'dip'),
  ('Tirokafteri', 1.50, 'dip'),
  ('Taramasalata', 1.50, 'dip'),
  ('Tahini dip', 1.50, 'dip'),
  ('Pina colada', 7.50, 'classic cocktail'),
  ('Mojito', 7.50, 'classic cocktail'),
  ('Margarita', 7.50, 'classic cocktail'),
  ('Strawberry margarita', 7.50, 'classic cocktail'),
  ('Strawberry daiquiri', 7.50, 'classic cocktail'),
  ('Aperol spritz', 7.50, 'classic cocktail'),
  ('Hugo', 7.50, 'classic cocktail'),
  ('Caipirinha', 7.50, 'classic cocktail'),
  ('Coconut caipirinha', 7.50, 'classic cocktail'),
  ('Margarita kick', 9.00, 'fresko cocktail'),
  ('Mastiha mojito', 9.00, 'fresko cocktail'),
  ('Red sangria', 9.00, 'fresko cocktail'),
  ('Ouzo special', 9.00, 'fresko cocktail'),
  ('Nojito', 6.00, 'mocktail'),
  ('Strawberry nojito', 6.00, 'mocktail'),
  ('Juicy julip', 6.00, 'mocktail'),
  ('Orange spritz', 6.00, 'mocktail'),
  ('Joy of sesh', 4.50, 'beer'),
  ('Macho mucho', 4.50, 'beer'),
  ('Bristol lager', 4.50, 'beer'),
  ('Mango cider', 4.50, 'cider'),
  ('Peary cider', 4.50, 'cider'),
  ('Elder cider', 4.50, 'cider'),
  ('Notos red', 5.50, 'wine'),
  ('Blender rose', 5.50, 'wine'),
  ('Retsina white', 5.50, 'wine');

-- DELETE FROM "allergen";
-- Insert data into the allergen table
INSERT INTO "allergen" ("allergen_name")
VALUES
  ('Celery'),
  ('Gluten'),
  ('Crustaceans'),
  ('Eggs'),
  ('Fish'),
  ('Lupin'),
  ('Milk'),
  ('Molluscs'),
  ('Mustard'),
  ('Peanuts'),
  ('Sesame'),
  ('Soybeans'),
  ('Nuts');

-- DELETE FROM "supplier";
-- Insert data into the supplier table
INSERT INTO "supplier" ("supplier_name", "supplier_address", "supplier_phone", "supplier_email")
VALUES
  ('Meat supplier', '1 Meat Street, Bristol', '07745123456', 'meatsupplier@gmail.com'),
  ('Fruit and veg supplier', '5 Vitamin Road, Bristol', '07745456789', 'fruitveg@gmail.com'),
  ('Condiments supplier', '7 Saucy Avenue, Bristol', '07456343233', 'condiments@gmail.com'),
  ('Baking supplier', '18 Flour Grove, Bristol', '07696696696', 'bakery@gmail.com'),
  ('Meze supplier', '45 Meze Mezzanine, Bristol', '09876543212', 'meze@gmail.com'),
  ('Drink supplier', '33 Booze Lane, Bristol', '07452657461', 'drinks@gmail.com');

-- DELETE FROM "ingredient";
-- Insert data into the ingredient table
INSERT INTO "ingredient" ("ingredient_name", "supplier_quantity", "low_threshold", "unit", "low_threshold_grams", "supplier_id")
VALUES
  ('Chicken breast', '5', 30, 'kg', 3000, 1),
  ('Olive oil', '5', 10, 'l', 10000, 3),
  ('Lemon juice', '12 x 500', 6000, 'ml', 6000, 3),
  ('Garlic', '40', 120, 'units', 6000, 2),
  ('Dried oregano', '130', 910, 'g', 910, 3),
  ('Paprika', '500', 2000, 'g', 2000, 3),
  ('Ground cumin', '450', 1800, 'g', 1800, 3),
  ('Salt', '750', 2250, 'g', 2250, 3),
  ('Black pepper', '1', 3, 'kg', 3000, 3),
  ('Lettuce', '20 x 2', 80, 'units', 24000, 2),
  ('Tomato', '5', 20, 'kg', 20000, 2),
  ('Cucumber', '12', 60, 'units', 24000, 2),
  ('Red onion', '10', 30, 'kg', 30000, 2),
  ('Kalamata olives', '1', 5, 'kg', 5000, 2),
  ('Fresh parsley', '1', 5, 'kg', 5000, 3),
  ('Lamb leg', '2', 30, 'kg', 30000, 1),
  ('Pork shoulder', '4', 30, 'kg', 30000, 1),
  ('Dried chickpeas', '3', 12, 'kg', 12000, 3),
  ('White onion', '25', 25, 'kg', 25000, 2),
  ('Ground coriander', '450', 2250, 'g', 2250, 3),
  ('Baking soda', '1.1', 2.2, 'kg', 2200, 4),
  ('Vegetable oil', '20', 60, 'l', 60000, 3),
  ('Halloumi', '6 x 750', 9000, 'g', 9000, 5),
  ('Dried thyme', '210', 1050, 'g', 1050, 3),
  ('Mixed leaves', '1', 5, 'kg', 5000, 2),
  ('Bell pepper', '5', 5, 'kg', 5000, 2),
  ('Feta cheese', '900', 4500, 'g', 4500, 5),
  ('Farro grains', '1', 2, 'kg', 2000, 2),
  ('Canned chickpeas', '800', 4000, 'g', 4000, 3),
  ('Carrot', '2', 4, 'kg', 4000, 2),
  ('Sugar', '5', 5, 'kg', 5000, 4),
  ('Tahini paste', '6 x 450', 2700, 'g', 2700, 5),
  ('Greek yoghurt', '5', 20, 'kg', 20000, 4),
  ('Fresh dill', '100', 1000, 'g', 1000, 2),
  ('Fresh mint', '100', 1000, 'g', 1000, 2),
  ('Honey', '700', 2100, 'g', 2100, 4),
  ('Plain flour', '16', 10, 'kg', 10000, 4),
  ('Plain flour (GF)', '5 x 1', 10, 'kg', 10000, 4),
  ('Yeast', '500', 2000, 'g', 2000, 4),
  ('Potato', '20', 20, 'kg', 20000, 2),
  ('Red pepper flakes', '1', 2, 'kg', 2000, 3),
  ('Tarama', '200', 2000, 'g', 2000, 5),
  ('White bread', '800', 4000, 'g', 4000, 4),
  ('White bread (GF)', '800', 4000, 'g', 4000, 4),
  ('Ground lamb', '2', 30, 'kg', 30000, 1),
  ('Breadcrumbs', '3.5', 5, 'kg', 5000, 4),
  ('Breadcrumbs (GF)', '1.5', 4.5, 'kg', 4500, 4),
  ('King prawns', '1', 10, 'kg', 10000, 1),
  ('Red chilli pepper', '250', 2000, 'g', 2000, 3),
  ('Squid rings', '1', 10, 'kg', 10000, 1),
  ('Cornstarch', '3.5', 3.5, 'kg', 3500, 4),
  ('Mayonnaise', '2', 6, 'kg', 6000, 3),
  ('Mayonnaise (V)', '2', 6, 'kg', 6000, 3),
  ('Pickles', '2.25', 2.25, 'kg', 2250, 2),
  ('Dijon mustard', '2.25', 2.25, 'l', 2250, 3),
  ('Mushrooms', '3', 5, 'kg', 5000, 2),
  ('Butter', '1', 5, 'kg', 5000, 4),
  ('Margerine', '1', 5, 'kg', 5000, 4),
  ('Heavy cream', '2.2', 4.4, 'l', 4400, 4),
  ('Heavy cream (V)', '2.2', 4.4, 'l', 4400, 4),
  ('Smoked aubergine', '2', 2, 'kg', 2000, 5),
  ('Coconut rum', '700', 7000, 'ml', 7000, 6),
  ('Pineapple juice', '12 x 1', 60, 'l', 60000, 6),
  ('Coconut syrup', '700', 7000, 'ml', 7000, 6),
  ('Coconut milk', '12 x 400', 7200, 'ml', 7200, 6),
  ('White rum', '700', 7000, 'ml', 7000, 6),
  ('Lime juice', '12 x 250', 6000, 'ml', 6000, 3),
  ('Soda water', '24 x 200', 9600, 'ml', 9600, 6),
  ('Silver tequila', '500', 5000, 'ml', 5000, 6),
  ('Cointreau', '500', 5000, 'ml', 5000, 6),
  ('Agave syrup', '1', 5, 'l', 5000, 6),
  ('Strawberries', '400', 2000, 'g', 2000, 2),
  ('Aperol', '700', 7000, 'ml', 7000, 6),
  ('Prosecco', '750', 7500, 'ml', 7500, 6),
  ('Elderflower cordial', '6 x 500', 6000, 'ml', 6000, 6),
  ('Cachaca', '700', 7000, 'ml', 7000, 6),
  ('Ouzo', '1', 10, 'l', 10000, 6),
  ('Greek mastiha liquer', '700', 7000, 'ml', 7000, 6),
  ('Mavrodaphne wine', '750', 7500, 'ml', 7500, 6),
  ('Orange juice', '2.2', 11, 'l', 11000, 2),
  ('Cranberry juice', '12 x 250', 6000, 'ml', 6000, 2),
  ('Lemonade', '24 x 200', 9600, 'ml', 9600, 6),
  ('Pineapple', '1', 10, 'units', 9000, 2),
  ('Joy of Sesh', '30', 30, 'l', 30000, 6),
  ('Macho Mucho', '30', 30, 'l', 30000, 6),
  ('Bristol Lager', '30', 30, 'l', 30000, 6),
  ('Mango Cider', '20', 20, 'l', 20000, 6),
  ('Peary Cider', '20', 20, 'l', 20000, 6),
  ('Elder Cider', '20', 20, 'l', 20000, 6),
  ('Notos Red', '750', 7500, 'ml', 7500, 6),
  ('Blender Rose', '750', 7500, 'ml', 7500, 6),
  ('Melios White', '750', 7500, 'ml', 7500, 6),
  ('Green cola', '24 x 330', 7920, 'ml', 7920, 6),
  ('Green orangeade', '24 x 330', 7920, 'ml', 7920, 6),
  ('Green lemonade', '24 x 330', 7920, 'ml', 7920, 6),
  ('Green sour cherry', '24 x 330', 7920, 'ml', 7920, 6),
  ('Bottled water', '24 x 500', 12000, 'ml', 12000, 6);

-- DELETE FROM "recipe";
-- Insert data into the recipe table
INSERT INTO "recipe" ("menu_item_id", "ingredient_id", "quantity")
VALUES
  (1, 1, 125),
  (1, 2, 10),
  (1, 3, 7),
  (1, 4, 5),
  (1, 5, 2),
  (1, 6, 2),
  (1, 7, 2),
  (1, 8, 4),
  (1, 9, 2),
  (1, 37, 125),
  (1, 39, 2),
  (1, 31, 2),
  (1, 10, 50),
  (1, 11, 40),
  (1, 12, 50), 
  (1, 13, 25), 
  (1, 14, 50),
  (1, 15, 8),
  (2, 17, 125),
  (2, 2, 10),
  (2, 3, 7),
  (2, 4, 5),
  (2, 5, 2),
  (2, 6, 2),
  (2, 7, 2),
  (2, 8, 4),
  (2, 9, 2),
  (2, 37, 125),
  (2, 39, 2),
  (2, 31, 2),
  (2, 10, 50),
  (2, 11, 40),
  (2, 12, 50), 
  (2, 13, 25), 
  (2, 14, 50),
  (2, 15, 8),
  (3, 16, 150),
  (3, 2, 10),
  (3, 3, 7),
  (3, 4, 5),
  (3, 5, 2),
  (3, 7, 2),
  (3, 6, 2),
  (3, 8, 4),
  (3, 9, 2),
  (3, 37, 125),
  (3, 39, 2),
  (3, 31, 2),
  (3, 10, 50),
  (3, 11, 40),
  (3, 12, 50), 
  (3, 13, 25), 
  (3, 14, 50),
  (3, 15, 8),
  (4, 23, 150),
  (4, 2, 10),
  (4, 3, 7),
  (4, 4, 5),
  (4, 5, 2),
  (4, 24, 2),
  (4, 6, 2),
  (4, 8, 4),
  (4, 9, 2),
  (4, 37, 125),
  (4, 39, 2),
  (4, 31, 2),
  (4, 10, 50),
  (4, 11, 40),
  (4, 12, 50), 
  (4, 13, 25), 
  (4, 14, 50),
  (4, 15, 8),
  (5, 18, 100),
  (5, 19, 50),
  (5, 4, 10),
  (5, 15, 16),
  (5, 7, 2),
  (5, 20, 2),
  (5, 21, 2),
  (5, 8, 4),
  (5, 9, 2),
  (5, 37, 125),
  (5, 39, 2),
  (5, 31, 2),
  (5, 10, 50),
  (5, 11, 40),
  (5, 12, 50), 
  (5, 13, 25), 
  (5, 14, 50),
  (6, 1, 150),
  (6, 2, 10),
  (6, 3, 7),
  (6, 4, 5),
  (6, 5, 2),
  (6, 24, 2),
  (6, 6, 2),
  (6, 8, 4),
  (6, 9, 2),
  (6, 37, 125),
  (6, 39, 2),
  (6, 31, 2),
  (6, 10, 50),
  (6, 11, 40),
  (6, 12, 50), 
  (6, 13, 25), 
  (6, 14, 50),
  (6, 15, 8),
  (8, 16, 150),
  (8, 2, 10),
  (8, 3, 7),
  (8, 4, 5),
  (8, 5, 2),
  (8, 24, 2),
  (8, 6, 2),
  (8, 8, 4),
  (8, 9, 2),
  (8, 37, 125),
  (8, 39, 2),
  (8, 31, 2),
  (8, 10, 50),
  (8, 11, 40),
  (8, 12, 50), 
  (8, 13, 25), 
  (8, 14, 50),
  (8, 15, 8),
  (7, 17, 150),
  (7, 2, 10),
  (7, 3, 7),
  (7, 4, 5),
  (7, 5, 2),
  (7, 24, 2),
  (7, 6, 2),
  (7, 8, 4),
  (7, 9, 2),
  (7, 37, 125),
  (7, 39, 2),
  (7, 31, 2),
  (7, 10, 50),
  (7, 11, 40),
  (7, 12, 50), 
  (7, 13, 25), 
  (7, 14, 50),
  (7, 15, 8),
  (25, 18, 100),
  (25, 19, 50),
  (25, 4, 10),
  (25, 15, 8),
  (25, 7, 2),
  (25, 20, 2),
  (25, 21, 2),
  (25, 8, 4),
  (25, 9, 2),
  (26, 23, 150),
  (26, 2, 10),
  (26, 3, 7),
  (26, 4, 5),
  (26, 5, 2),
  (26, 24, 2),
  (26, 6, 2),
  (26, 8, 4),
  (26, 9, 2),
  (27, 27, 50),
  (9, 1, 150),
  (9, 25, 50),
  (9, 11, 80),
  (9, 12, 50),
  (9, 26, 50),
  (9, 13, 25),
  (9, 14, 50),
  (9, 27, 50),
  (9, 2, 10),
  (9, 3, 7),
  (9, 4, 5),
  (9, 5, 2),
  (9, 24, 2),
  (9, 6, 2),
  (9, 8, 2),
  (9, 9, 2),
  (10, 16, 150),
  (10, 2, 10),
  (10, 3, 7),
  (10, 4, 5),
  (10, 5, 2),
  (10, 24, 2),
  (10, 6, 2),
  (10, 8, 2),
  (10, 9, 2),
  (10, 25, 50),
  (10, 11, 80),
  (10, 12, 50),
  (10, 26, 50),
  (10, 13, 25),
  (10, 14, 50),
  (10, 27, 50),
  (11, 28, 50),
  (11, 10, 50),
  (11, 11, 80),
  (11, 12, 50),
  (11, 13, 25),
  (11, 14, 50),
  (11, 29, 50),
  (11, 23, 100),
  (12, 18, 200),
  (12, 19, 100),
  (12, 4, 20),
  (12, 15, 16),
  (12, 7, 4),
  (12, 20, 4),
  (12, 21, 4),
  (12, 8, 8),
  (12, 9, 4),
  (12, 25, 50),
  (12, 11, 80),
  (12, 12, 50),
  (12, 26, 50),
  (12, 30, 25),
  (12, 13, 25),
  (12, 14, 50),
  (12, 29, 50),
  (18, 29, 100),
  (18, 32, 15),
  (18, 3, 15),
  (18, 4, 5),
  (18, 8, 2),
  (18, 2, 15),
  (19, 33, 50),
  (19, 12, 50),
  (19, 4, 5),
  (19, 3, 15),
  (19, 34, 2),
  (19, 8, 2),
  (19, 9, 2),
  (20, 33, 50),
  (20, 12, 50),
  (20, 4, 5),
  (20, 3, 15),
  (20, 34, 2),
  (20, 8, 2),
  (20, 9, 2),
  (21, 32, 15),
  (21, 3, 15),
  (21, 4, 5),
  (21, 8, 2),
  (22, 32, 15),
  (22, 3, 15),
  (22, 4, 5),
  (22, 8, 2),
  (23, 33, 100),
  (23, 35, 8),
  (23, 3, 15),
  (23, 36, 5),
  (23, 8, 2),
  (23, 9, 2),
  (24, 33, 100),
  (24, 35, 8),
  (24, 3, 15),
  (24, 36, 5),
  (24, 8, 2),
  (24, 9, 2),
  (28, 37, 125),
  (28, 39, 3),
  (28, 8, 3),
  (28, 31, 3),
  (28, 2, 10),
  (29, 37, 125),
  (29, 39, 3),
  (29, 8, 3),
  (29, 31, 3),
  (29, 2, 10),
  (30, 40, 150),
  (30, 2, 15),
  (30, 5, 2),
  (30, 8, 2),
  (30, 9, 2),
  (31, 1, 150),
  (31, 2, 10),
  (31, 3, 7),
  (31, 4, 5),
  (31, 5, 2),
  (31, 24, 2),
  (31, 6, 2),
  (31, 8, 4),
  (31, 9, 2),
  (32, 16, 150),
  (32, 2, 10),
  (32, 3, 7),
  (32, 4, 5),
  (32, 5, 2),
  (32, 24, 2),
  (32, 6, 2),
  (32, 8, 4),
  (32, 9, 2),
  (33, 17, 150),
  (33, 2, 10),
  (33, 3, 7),
  (33, 4, 5),
  (33, 5, 2),
  (33, 24, 2),
  (33, 6, 2),
  (33, 8, 4),
  (33, 9, 2),
  (44, 27, 100),
  (44, 33, 60),
  (44, 26, 120),
  (44, 2, 15),
  (44, 41, 2),
  (44, 3, 15),
  (44, 8, 2),
  (44, 9, 2),
  (45, 42, 50),
  (45, 43, 40),
  (45, 3, 15),
  (45, 4, 5),
  (45, 2, 30),
  (45, 15, 8),
  (34, 45, 150),
  (34, 4, 5),
  (34, 35, 8),
  (34, 5, 2),
  (34, 7, 2),
  (34, 8, 2),
  (34, 9, 2),
  (34, 46, 7),
  (34, 25, 30),
  (35, 48, 150),
  (35, 26, 60),
  (35, 4, 5),
  (35, 49, 12),
  (35, 11, 80),
  (35, 27, 50),
  (35, 2, 15),
  (35, 15, 8),
  (35, 8, 2),
  (35, 9, 2),
  (36, 50, 150),
  (36, 37, 30),
  (36, 51, 20),
  (36, 6, 2),
  (36, 8, 4),
  (36, 9, 4),
  (36, 52, 30),
  (36, 54, 15),
  (36, 3, 15),
  (36, 55, 3),
  (36, 34, 2),
  (36, 25, 30),
  (37, 23, 150),
  (37, 2, 15),
  (37, 3, 15),
  (37, 4, 5),
  (37, 5, 2),
  (37, 9, 2),
  (37, 25, 30),
  (38, 56, 150),
  (38, 57, 15),
  (38, 4, 5),
  (38, 15, 5),
  (38, 59, 30),
  (38, 8, 2),
  (38, 9, 2),
  (39, 14, 100),
  (39, 2, 15),
  (39, 5, 2),
  (40, 61, 150),
  (40, 27, 50),
  (40, 4, 5),
  (40, 26, 120),
  (40, 2, 30),
  (40, 8, 2),
  (40, 9, 2),
  (41, 29, 100),
  (41, 32, 15),
  (41, 3, 15),
  (41, 4, 5),
  (41, 8, 2),
  (41, 2, 15),
  (42, 27, 100),
  (42, 2, 15),
  (42, 5, 2),
  (43, 33, 50),
  (43, 12, 50),
  (43, 4, 5),
  (43, 3, 15),
  (43, 34, 2),
  (43, 8, 2),
  (43, 9, 2),
  (46, 32, 15),
  (46, 3, 15),
  (46, 4, 5),
  (46, 8, 2),
  (47, 62, 45),
  (47, 63, 90),
  (47, 64, 15),
  (47, 65, 45),
  (48, 66, 45),
  (48, 67, 30),
  (48, 35, 5),
  (48, 31, 8),
  (48, 68, 45),
  (49, 69, 45),
  (49, 67, 15),
  (49, 70, 15),
  (49, 71, 15),
  (50, 69, 45),
  (50, 72, 50),
  (50, 67, 15),
  (50, 70, 15),
  (50, 71, 15),
  (51, 66, 45),
  (51, 72, 50),
  (51, 67, 15),
  (51, 71, 15),
  (52, 73, 45),
  (52, 74, 90),
  (52, 80, 15),
  (52, 68, 45),
  (53, 75, 45),
  (53, 74, 90),
  (53, 35, 5),
  (53, 67, 15),
  (54, 76, 45),
  (54, 67, 15),
  (54, 64, 15),
  (56, 77, 45),
  (56, 67, 15),
  (56, 70, 15),
  (56, 71, 15),
  (57, 78, 45),
  (57, 67, 15),
  (57, 35, 5),
  (57, 31, 8),
  (57, 68, 45),
  (58, 79, 120),
  (58, 80, 15),
  (58, 81, 15),
  (59, 77, 45),
  (59, 3, 15),
  (59, 82, 45),
  (60, 35, 5),
  (60, 67, 30),
  (60, 31, 8),
  (60, 68, 45),
  (61, 72, 50),
  (61, 35, 5),
  (61, 31, 8),
  (61, 68, 45),
  (62, 63, 30),
  (62, 67, 15),
  (62, 35, 5),
  (62, 83, 30),
  (62, 68, 45),
  (63, 80, 45),
  (63, 81, 15),
  (63, 75, 15),
  (63, 35, 5),
  (64, 84, 550),
  (65, 85, 550),
  (66, 86, 550),
  (67, 87, 550),
  (68, 88, 550),
  (69, 89, 550),
  (70, 90, 125),
  (71, 91, 125),
  (72, 92, 125),
  (13, 93, 330),
  (14, 94, 330),
  (15, 95, 330),
  (16, 96, 330),
  (17, 97, 500);
--   (73, 1, 125),
--   (73, 2, 10),
--   (73, 3, 7),
--   (73, 4, 5),
--   (73, 5, 2),
--   (73, 6, 2),
--   (73, 7, 2),
--   (73, 8, 4),
--   (73, 9, 2),
--   (73, 38, 125),
--   (73, 39, 2),
--   (73, 31, 2),
--   (73, 10, 50),
--   (73, 11, 40),
--   (73, 12, 50), 
--   (73, 13, 25), 
--   (73, 14, 50),
--   (73, 15, 8),
--   (74, 17, 125),
--   (74, 2, 10),
--   (74, 3, 7),
--   (74, 4, 5),
--   (74, 5, 2),
--   (74, 6, 2),
--   (74, 7, 2),
--   (74, 8, 4),
--   (74, 9, 2),
--   (74, 38, 125),
--   (74, 39, 2),
--   (74, 31, 2),
--   (74, 10, 50),
--   (74, 11, 40),
--   (74, 12, 50), 
--   (74, 13, 25), 
--   (74, 14, 50),
--   (74, 15, 8),
--   (75, 16, 150),
--   (75, 2, 10),
--   (75, 3, 7),
--   (75, 4, 5),
--   (75, 5, 2),
--   (75, 7, 2),
--   (75, 6, 2),
--   (75, 8, 4),
--   (75, 9, 2),
--   (75, 38, 125),
--   (75, 39, 2),
--   (75, 31, 2),
--   (75, 10, 50),
--   (75, 11, 40),
--   (75, 12, 50), 
--   (75, 13, 25), 
--   (75, 14, 50),
--   (75, 15, 8),
--   (76, 23, 150),
--   (76, 2, 10),
--   (76, 3, 7),
--   (76, 4, 5),
--   (76, 5, 2),
--   (76, 24, 2),
--   (76, 6, 2),
--   (76, 8, 4),
--   (76, 9, 2),
--   (76, 38, 125),
--   (76, 39, 2),
--   (76, 31, 2),
--   (76, 10, 50),
--   (76, 11, 40),
--   (76, 12, 50), 
--   (76, 13, 25), 
--   (76, 14, 50),
--   (76, 15, 8),
--   (77, 18, 100),
--   (77, 19, 50),
--   (77, 4, 10),
--   (77, 15, 8),
--   (77, 7, 2),
--   (77, 20, 2),
--   (77, 21, 2),
--   (77, 8, 4),
--   (77, 9, 2),
--   (77, 38, 125),
--   (77, 39, 2),
--   (77, 31, 2),
--   (77, 10, 50),
--   (77, 11, 40),
--   (77, 12, 50), 
--   (77, 13, 25), 
--   (77, 14, 50),
--   (78, 1, 150),
--   (78, 2, 10),
--   (78, 3, 7),
--   (78, 4, 5),
--   (78, 5, 2),
--   (78, 24, 2),
--   (78, 6, 2),
--   (78, 8, 4),
--   (78, 9, 2),
--   (78, 38, 125),
--   (78, 39, 2),
--   (78, 31, 2),
--   (78, 10, 50),
--   (78, 11, 40),
--   (78, 12, 50), 
--   (78, 13, 25), 
--   (78, 14, 50),
--   (78, 15, 8),
--   (79, 17, 150),
--   (79, 2, 10),
--   (79, 3, 7),
--   (79, 4, 5),
--   (79, 5, 2),
--   (79, 24, 2),
--   (79, 6, 2),
--   (79, 8, 4),
--   (79, 9, 2),
--   (79, 38, 125),
--   (79, 39, 2),
--   (79, 31, 2),
--   (79, 10, 50),
--   (79, 11, 40),
--   (79, 12, 50), 
--   (79, 13, 25), 
--   (79, 14, 50),
--   (79, 15, 8),
--   (80, 16, 150),
--   (80, 2, 10),
--   (80, 3, 7),
--   (80, 4, 5),
--   (80, 5, 2),
--   (80, 24, 2),
--   (80, 6, 2),
--   (80, 8, 4),
--   (80, 9, 2),
--   (80, 38, 125),
--   (80, 39, 2),
--   (80, 31, 2),
--   (80, 10, 50),
--   (80, 11, 40),
--   (80, 12, 50), 
--   (80, 13, 25), 
--   (80, 14, 50),
--   (80, 15, 8),
--   (81, 10, 50),
--   (81, 11, 80),
--   (81, 12, 50),
--   (81, 13, 25),
--   (81, 14, 50),
--   (81, 29, 50),
--   (81, 23, 100),
--   (82, 45, 150),
--   (82, 4, 5),
--   (82, 35, 8),
--   (82, 5, 2),
--   (82, 7, 2),
--   (82, 8, 2),
--   (82, 9, 2),
--   (82, 47, 7),
--   (82, 25, 30),
--   (83, 50, 150),
--   (83, 38, 30),
--   (83, 51, 20),
--   (83, 6, 2),
--   (83, 8, 4),
--   (83, 9, 4),
--   (83, 52, 30),
--   (83, 54, 15),
--   (83, 3, 15),
--   (83, 55, 3),
--   (83, 34, 2),
--   (83, 25, 30);
-- DELETE FROM "ingredient_allergen";
-- Insert data into the ingredient_allergen table
INSERT INTO "ingredient_allergen" ("ingredient_id", "allergen_id")
VALUES
  (23, 7), 
  (27, 7), 
  (28, 2), 
  (32, 11), 
  (33, 7), 
  (37, 2), 
  (42, 5), 
  (43, 2), 
  (46, 2), 
  (48, 3), 
  (50, 8), 
  (52, 4), 
  (57, 7), 
  (58, 12), 
  (59, 7);

-- DELETE FROM "location";
-- Insert data into the location table
INSERT INTO "location" ("location_name")
VALUES
  ('Pantry'),
  ('Refrigerator'),
  ('Freezer'),
  ('Refrigerator - meat/poultry/fish drawer'),
  ('Refrigerator - dairy drawer'),
  ('Condiment rack'),
  ('Wine rack'),
  ('Refrigerator - beverage'),
  ('Liquor cabinet');

-- DELETE FROM "current_stock";
-- Insert data into the current_stock table
INSERT INTO "current_stock" ("ingredient_id", "location_id", "delivery_date", "total_cost", "expiry_date", "quantity")
VALUES
-- dates must be in YYYY-MM-DD format
-- example entry: (6, 4, '2023-07-19', 200.14, '2023-07-26', 500)
  (1, 4, '2023-08-01', 349.86, '2023-08-05', 6000), 
  (2, 1, '2023-08-01', 159.95, '2023-09-01', 20000), 
  (3, 1, '2023-08-01', 64.17, '2023-09-01', 8000), 
  (4, 1, '2023-08-01', 75.60, '2023-09-01', 10000), 
  (5, 6, '2023-08-01', 21.45, '2023-10-01', 1820), 
  (6, 6, '2023-08-01', 27.45, '2023-10-01', 4000), 
  (7, 6, '2023-08-01', 40.45, '2023-10-01', 3600), 
  (8, 6, '2023-08-01', 9.45, '2023-10-01', 4500), 
  (9, 6, '2023-08-01', 66.27, '2023-10-01', 6000), 
  (10, 2, '2023-08-01', 72.57, '2023-08-08', 25000), 
  (11, 1, '2023-08-01', 43.47, '2023-08-11', 40000), 
  (12, 2, '2023-08-01', 62.45, '2023-08-15', 48000), 
  (13, 1, '2023-08-01', 63.57, '2023-08-11', 35000), 
  (14, 1, '2023-08-01', 69.95, '2023-09-01', 10000), 
  (15, 2, '2023-08-01', 18.78, '2023-08-08', 6000), 
  (16, 4, '2023-08-01', 1421.64, '2023-08-06', 35000), 
  (17, 4, '2023-08-01', 719.78, '2023-08-05', 35000), 
  (18, 1, '2023-08-01', 428.91, '2023-09-01', 15000), 
  (19, 1, '2023-08-01', 37.89, '2023-08-11', 30000), 
  (20, 6, '2023-08-01', 21.45, '2023-10-01', 5000), 
  (21, 1, '2023-08-01', 4.99, '2023-09-01', 5000), 
  (22, 1, '2023-08-01', 101.18, '2023-09-01', 35000), 
  (23, 5, '2023-08-01', 265.56, '2023-08-06', 10000), 
  (24, 6, '2023-08-01', 35.45, '2023-10-01', 3000), 
  (25, 2, '2023-08-01', 594.50, '2023-08-08', 6000), 
  (26, 1, '2023-08-01', 176.31, '2023-08-08', 8000), 
  (27, 5, '2023-08-01', 531.62, '2023-08-06', 6000), 
  (28, 1, '2023-08-01', 415.48, '2023-09-01', 5000), 
  (29, 1, '2023-08-01', 52.15, '2023-10-01', 4500), 
  (30, 1, '2023-08-01', 7.78, '2023-08-15', 6000), 
  (31, 1, '2023-08-01', 38.36, '2023-10-01', 7000), 
  (32, 1, '2023-08-01', 1828.32, '2023-09-01', 3000), 
  (33, 5, '2023-08-01', 305.90, '2023-08-08', 5000), 
  (34, 2, '2023-08-01', 16.45, '2023-08-08', 2000), 
  (35, 2, '2023-08-01', 27.90, '2023-08-08', 2000), 
  (36, 1, '2023-08-01', 48.45, '2023-09-01', 3000), 
  (37, 1, '2023-08-01', 573.59, '2023-10-01', 10000), 
  (38, 1, '2023-08-01', 406.78, '2023-10-01', 10000), 
  (39, 1, '2023-08-01', 109.62, '2023-09-01', 3000), 
  (40, 1, '2023-08-01', 233.87, '2023-08-15', 20000), 
  (41, 6, '2023-08-01', 20.80, '2023-10-01', 4000), 
  (42, 4, '2023-08-01', 52.50, '2023-08-08', 4000), 
  (43, 1, '2023-08-01', 43.20, '2023-08-15', 6000), 
  (44, 1, '2023-08-01', 43.20, '2023-08-15', 6000), 
  (45, 4, '2023-08-01', 766.74, '2023-08-06', 30000), 
  (46, 1, '2023-08-01', 9.39, '2023-09-01', 6000), 
  (47, 1, '2023-08-01', 8.59, '2023-09-01', 6000), 
  (48, 4, '2023-08-01', 132.72, '2023-08-04', 10000), 
  (49, 2, '2023-08-01', 18.36, '2023-08-08', 3000), 
  (50, 4, '2023-08-01', 67.92, '2023-08-08', 10000), 
  (51, 1, '2023-08-01', 16.09, '2023-08-03', 4000), 
  (52, 2, '2023-08-01', 17.98, '2023-08-15', 7000), 
  (53, 2, '2023-08-01', 17.98, '2023-08-15', 7000), 
  (54, 2, '2023-08-01', 10.69, '2023-08-15', 4000), 
  (55, 2, '2023-08-01', 18.69, '2023-09-01', 4000), 
  (56, 2, '2023-08-01', 54.27, '2023-08-08', 6000), 
  (57, 1, '2023-08-01', 19.50, '2023-09-01', 6000), 
  (58, 2, '2023-08-01', 19.50, '2023-09-01', 7000), 
  (59, 5, '2023-08-01', 17.98, '2023-08-08', 6500), 
  (60, 2, '2023-08-01', 17.98, '2023-08-08', 6500), 
  (61, 1, '2023-08-01', 75.96, '2023-08-08', 4000), 
  (62, 9, '2023-08-01', 66.45, '2023-10-01', 14000), 
  (63, 8, '2023-08-01', 23.98, '2023-08-08', 60000), 
  (64, 1, '2023-08-01', 33.45, '2023-09-01', 8000), 
  (65, 8, '2023-08-01', 40.58, '2023-08-08', 8000), 
  (66, 9, '2023-08-01', 79.95, '2023-10-01', 14000), 
  (67, 8, '2023-08-01', 21.39, '2023-08-06', 8000), 
  (68, 1, '2023-08-01', 27.18, '2023-10-01', 10000), 
  (69, 9, '2023-08-01', 155.00, '2023-10-01', 10000), 
  (70, 9, '2023-08-01', 170.00, '2023-10-01', 10000), 
  (71, 1, '2023-08-01', 50.00, '2023-09-01', 6000), 
  (72, 2, '2023-08-01', 21.95, '2023-08-04', 4000), 
  (73, 9, '2023-08-01', 76.95, '2023-10-01', 14000), 
  (74, 9, '2023-08-01', 38.35, '2023-08-04', 15000), 
  (75, 8, '2023-08-01', 68.07, '2023-09-01', 8000), 
  (76, 9, '2023-08-01', 51.45, '2023-10-01', 14000), 
  (77, 9, '2023-08-01', 74.40, '2023-10-01', 15000), 
  (78, 9, '2023-08-01', 83.95, '2023-10-01', 14000), 
  (79, 7, '2023-08-01', 29.95, '2023-08-06', 15000), 
  (80, 8, '2023-08-01', 163.80, '2023-08-08', 12000), 
  (81, 8, '2023-08-01', 215.32, '2023-08-08', 8000), 
  (82, 8, '2023-08-01', 135.12, '2023-10-01', 12000), 
  (83, 1, '2023-08-01', 17.95, '2023-08-06', 12000), 
  (84, 8, '2023-08-01', 285.00, '2023-09-01', 30000), 
  (85, 8, '2023-08-01', 285.00, '2023-09-01', 30000), 
  (86, 8, '2023-08-01', 285.00, '2023-09-01', 30000), 
  (87, 8, '2023-08-01', 310.00, '2023-09-01', 20000), 
  (88, 8, '2023-08-01', 280.00, '2023-09-01', 20000), 
  (89, 8, '2023-08-01', 310.00, '2023-09-01', 20000), 
  (90, 7, '2023-08-01', 240.00, '2023-08-06', 10000), 
  (91, 7, '2023-08-01', 123.80, '2023-08-06', 10000), 
  (92, 7, '2023-08-01', 161.80, '2023-08-06', 10000), 
  (93, 8, '2023-08-01', 387.25, '2023-09-01', 10000), 
  (94, 8, '2023-08-01', 387.25, '2023-09-01', 10000), 
  (95, 8, '2023-08-01', 387.25, '2023-09-01', 8000), 
  (96, 8, '2023-08-01', 387.25, '2023-09-01', 8000), 
  (97, 8, '2023-08-01', 269.75, '2023-10-01', 12000);


/*
---------------------------------------------------------------------------------------------
Function to add a new order to the database more easily
*/
CREATE OR REPLACE FUNCTION create_new_order(
  p_menu_item_ids INT[],
  p_quantities INT[],
  p_table_id INT
) RETURNS INT
AS $$
DECLARE
  new_order_id INT;
  array_length INT;
  i INT;
  new_ingredient_id INT;
  ingredient_quantity_rec RECORD;
  new_ingredient_quantity NUMERIC;
BEGIN
  -- Insert a new order into the "Order" table
  INSERT INTO "order" (time_ordered, time_delivered, table_id)
  VALUES (NOW(), NULL, p_table_id)
  RETURNING order_id INTO new_order_id;

  -- Determine the length of the input arrays
  array_length := array_length(p_menu_item_ids, 1);

  -- Insert order items into the "OrderItem" table for each menu item
  FOR i IN 1..array_length
  LOOP
    INSERT INTO "order_item" (order_id, menu_item_id, quantity)
    VALUES (new_order_id, p_menu_item_ids[i], p_quantities[i]);
    
    -- Update current stock for each ingredient used in the order
    FOR ingredient_quantity_rec IN (
      SELECT r.ingredient_id, r.quantity * p_quantities[i] AS ingredient_quantity
      FROM "recipe" AS r
      WHERE r.menu_item_id = p_menu_item_ids[i]
    )
    LOOP
      new_ingredient_id := ingredient_quantity_rec.ingredient_id;
      new_ingredient_quantity := ingredient_quantity_rec.ingredient_quantity;
      
      UPDATE "current_stock"
      SET quantity = quantity - new_ingredient_quantity
      WHERE ingredient_id = new_ingredient_id;
    END LOOP;
  END LOOP;

  -- Return the new order_id
  RETURN new_order_id;
END;
$$ LANGUAGE plpgsql;




/*
---------------------------------------------------------------------------------------------
Get todays orders
*/

CREATE OR REPLACE FUNCTION get_todays_orders()
  RETURNS TABLE (
    order_id INT,
    table_id INT,
    menu_item_name TEXT,
    price MONEY,
    quantity INT,
	status TEXT
  )
AS $$
BEGIN
  RETURN QUERY
    SELECT
      o.order_id,
      o.table_id,
      mi.menu_item_name,
      mi.price,
      oi.quantity,
	  CASE
        WHEN o.paid THEN 'closed'
        ELSE 'open'
      END AS status
    FROM
      "order" o
    INNER JOIN
      "order_item" oi ON o.order_id = oi.order_id
    INNER JOIN
      "menu_item" mi ON oi.menu_item_id = mi.menu_item_id
	WHERE
      DATE(o.time_ordered) = CURRENT_DATE
	GROUP BY
	  o.order_id,
      o.table_id,
      mi.menu_item_name,
	  mi.price,
      oi.quantity
    ORDER BY
--       o.table_id,
      o.order_id desc;
END;
$$ LANGUAGE plpgsql;


/*
---------------------------------------------------------------------------------------------
To create a dummy order of 5-6 items on each table for testing
*/


-- Create the function
CREATE OR REPLACE FUNCTION create_dummy_orders()
RETURNS VOID AS $$
DECLARE
  table_id INT;
BEGIN
  -- Loop through table IDs
  FOR table_id IN SELECT DISTINCT "table_number".table_id FROM "table_number"
  LOOP
    -- Generate random menu_item_ids and quantities
    DECLARE
      menu_item_ids INT[] := ARRAY(SELECT menu_item_id FROM "menu_item" ORDER BY random() LIMIT floor(random() * 2) + 3);
      quantities INT[] := ARRAY(SELECT floor(random() * 3) + 1 FROM generate_series(1, array_length(menu_item_ids, 1)));
    BEGIN
      -- Create the order
      PERFORM create_new_order(menu_item_ids, quantities, table_id);
    END;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

/*
---------------------------------------------------------------------------------------------
Insert booking on a table/list of tables
*/

-- Create the function
CREATE OR REPLACE FUNCTION insert_booking(
    new_table_ids INT[],
	new_group_size INT,
    new_start_time TIMESTAMP DEFAULT NULL,
    new_duration INTERVAL DEFAULT '1.5 hours',
	new_comment TEXT DEFAULT NULL
)
RETURNS VOID AS
$$
DECLARE
    table_id INT;
BEGIN
    -- Check if new_start_time is NULL and assign current timestamp if it is
    IF new_start_time IS NULL THEN
        new_start_time := now();
    END IF;

    -- Loop through each table ID in the list
    FOREACH table_id IN ARRAY new_table_ids
    LOOP
        -- Insert a new booking into the Booking table
        INSERT INTO "booking" (group_size, start_time, duration, table_id, comments)
        VALUES (new_group_size, new_start_time, new_duration, table_id, new_comment);
    END LOOP;
END;
$$
LANGUAGE plpgsql;



/*
---------------------------------------------------------------------------------------------
Get order total cost
*/

CREATE OR REPLACE FUNCTION get_order_total_cost(order_id_param INT) 
RETURNS MONEY AS
$$
DECLARE
    total_cost MONEY := 0;
BEGIN
    SELECT SUM(oi.quantity * mi.price)
    INTO total_cost
    FROM "order" o
    JOIN "order_item" oi ON o.order_id = oi.order_id
    JOIN "menu_item" mi ON oi.menu_item_id = mi.menu_item_id
    WHERE o.order_id = order_id_param;
    
    RETURN total_cost;
END;
$$
LANGUAGE plpgsql;

-- --check if any ingredient qunatity is less than the threshold
CREATE OR REPLACE FUNCTION check_low_threshold()
RETURNS TRIGGER AS $$
DECLARE
  ingredient_rec RECORD;
BEGIN
  -- Check if any ingredient goes below the low threshold
  FOR ingredient_rec IN (
    SELECT ingredient_id, SUM(quantity) AS total_quantity
    FROM "current_stock"
    GROUP BY ingredient_id
  )
  LOOP
    IF ingredient_rec.total_quantity < (SELECT low_threshold FROM "ingredient" WHERE ingredient_id = ingredient_rec.ingredient_id) THEN
      -- Perform any action or raise a warning/log as needed
      RAISE NOTICE 'Ingredient % is below the low threshold!', ingredient_rec.ingredient_id;
    END IF;
  END LOOP;
  
  RETURN NULL; -- The trigger is after insert/update, so we don't need to change the inserted/updated row.
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE OR REPLACE TRIGGER check_low_threshold_trigger
AFTER INSERT OR UPDATE ON "current_stock"
FOR EACH STATEMENT
EXECUTE FUNCTION check_low_threshold();

CREATE OR REPLACE VIEW out_of_stock_ingredients AS
SELECT cs.ingredient_id, i.low_threshold_grams
FROM "current_stock" cs
INNER JOIN "ingredient" i ON cs.ingredient_id = i.ingredient_id
GROUP BY cs.ingredient_id, i.low_threshold_grams
HAVING SUM(cs.quantity) < AVG(i.low_threshold_grams);


CREATE OR REPLACE VIEW out_of_stock_menu_items AS
SELECT DISTINCT mi.menu_item_id
FROM "menu_item" mi
JOIN "recipe" r ON mi.menu_item_id = r.menu_item_id
JOIN "out_of_stock_ingredients" oosi ON r.ingredient_id = oosi.ingredient_id;



CREATE OR REPLACE FUNCTION restock_ingredients()
RETURNS VOID
AS $$
DECLARE
    ingredient_row RECORD;
BEGIN
    -- Loop through ingredients below their low threshold
    FOR ingredient_row IN
        SELECT cs.ingredient_id, i.ingredient_name, cs.expiry_date, cs.quantity, i.low_threshold_grams, i.unit
        FROM "current_stock" cs
        INNER JOIN "ingredient" i ON cs.ingredient_id = i.ingredient_id
        WHERE cs.quantity < i.low_threshold_grams
    LOOP
        -- Insert a new row into current_stock with restocked quantity
        INSERT INTO "current_stock" (ingredient_id, location_id, delivery_date, total_cost, expiry_date, quantity)
        VALUES (ingredient_row.ingredient_id, 1, CURRENT_DATE, 0, CURRENT_DATE + interval '1 week', ingredient_row.low_threshold_grams * 5);
    END LOOP;
END;
$$ LANGUAGE plpgsql;
