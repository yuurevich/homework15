CREATE TABLE IF NOT EXISTS colors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    color VARCHAR(50));

INSERT INTO colors(color)
    SELECT DISTINCT color1  AS color FROM animals
    UNION
    SELECT DISTINCT color2 AS color FROM animals;



CREATE TABLE types(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type VARCHAR(50));

INSERT INTO types(type)
    SELECT DISTINCT animal_type FROM animals;



CREATE TABLE breeds(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    breed VARCHAR(50));

INSERT INTO breeds(breed)
    SELECT DISTINCT breed FROM animals;



CREATE TABLE IF NOT EXISTS outcome(
    id INTEGER,
    outcome_subtype VARCHAR(50),
    outcome_type VARCHAR(50),
    outcome_month INTEGER,
    outcome_year INTEGER
);

INSERT INTO outcome(id, outcome_subtype, outcome_type, outcome_month, outcome_year)
SELECT  "index",
        outcome_subtype,
        outcome_type,
        outcome_month,
        outcome_year
FROM animals;



CREATE TABLE IF NOT EXISTS animals_final(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    age_upon_outcome VARCHAR(50),
    animal_id VARCHAR(50),
    animal_type INTEGER,
    name VARCHAR(50),
    breed INTEGER,
    color INTEGER,
    date_of_birth DATE,
    outcome_id INTEGER,
    FOREIGN KEY (animal_type) REFERENCES types(id),
    FOREIGN KEY (breed) REFERENCES breeds(id),
    FOREIGN KEY (color) REFERENCES colors(id) ,
    FOREIGN KEY (outcome_id) REFERENCES outcome(id)
);

INSERT INTO animals_final (age_upon_outcome, animal_id, animal_type, name, breed, color, date_of_birth, outcome_id )
SELECT  animals.age_upon_outcome, animals.animal_id, types.id,
       animals.name, breeds.id AS breed, colors.id as main_color,  animals.date_of_birth, outcome.id
FROM animals
LEFT JOIN colors
    ON colors.color = color1
LEFT JOIN breeds
    ON animals.breed = breeds.breed
LEFT JOIN types
    ON animals.animal_type = types.type
LEFT JOIN outcome
    ON animals.'index' = outcome.id;
