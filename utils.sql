CREATE TABLE IF NOT EXISTS colors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    color VARCHAR(50));

INSERT INTO colors(color)
    SELECT DISTINCT color1  AS color FROM animals
    UNION
    SELECT DISTINCT color2 AS color FROM animals;

CREATE TABLE IF NOT EXISTS animals_colors(
    animal_id INTEGER ,
    color1 INTEGER,
    color2 INTEGER,
    FOREIGN KEY (animal_id) REFERENCES animals ('index'),
    FOREIGN KEY (color1) REFERENCES colors(id),
    FOREIGN KEY (color2) REFERENCES colors(id));

INSERT INTO animals_colors(animal_id, color1, color2)
SELECT animals."index", animals.color1, animals.color2
FROM animals;

UPDATE animals_colors
SET color1 = (SELECT colors.id
            FROM colors
            where color1 = colors.color)
WHERE EXISTS (
    SELECT * FROM colors
    WHERE color1 = colors.color);

UPDATE animals_colors
SET color2 = (SELECT colors.id
            FROM colors
            where color2 = colors.color)
WHERE EXISTS (
    SELECT * FROM colors
    WHERE color2 = colors.color);




CREATE TABLE types(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type VARCHAR(50));

INSERT INTO types(type)
    SELECT DISTINCT animal_type FROM animals;

CREATE TABLE IF NOT EXISTS animals_types(
    animal_id INTEGER,
    animal_type_id  INTEGER,
    FOREIGN KEY (animal_id) REFERENCES animals ('index'),
    FOREIGN KEY (animal_type_id) REFERENCES types (id));

INSERT INTO animals_types(animal_id, animal_type_id)
    SELECT animals.'index', types.id FROM animals
    JOIN types ON animals.animal_type = types.type;




CREATE TABLE breeds(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    breed VARCHAR(50));

INSERT INTO breeds(breed)
    SELECT DISTINCT breed FROM animals;

CREATE TABLE IF NOT EXISTS animals_breeds(
    animal_id INTEGER,
    breed_id  INTEGER,
    FOREIGN KEY (animal_id) REFERENCES animals ('index'),
    FOREIGN KEY (breed_id) REFERENCES breeds (id));

INSERT INTO animals_breeds(animal_id, breed_id)
    SELECT animals.'index', breeds.id FROM animals
    JOIN breeds ON animals.breed = breeds.breed;




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
    colors INTEGER,
    date_of_birth DATE,
    outcome_id INTEGER,
    FOREIGN KEY (animal_type) REFERENCES animals_types(animal_type_id),
    FOREIGN KEY (breed) REFERENCES animals_breeds(breed_id),
    FOREIGN KEY (colors) REFERENCES animals_colors(animal_id) ,
    FOREIGN KEY (outcome_id) REFERENCES outcome(id)
);

INSERT INTO animals_final (age_upon_outcome, animal_id, animal_type, name, breed, colors, date_of_birth, outcome_id )
SELECT  animals.age_upon_outcome, animals.animal_id, animals_types.animal_type_id,
       animals.name, animals_breeds.breed_id AS breed, animals_colors.animal_id,  animals.date_of_birth, outcome.id
FROM animals
JOIN animals_colors
    ON animals.'index' = animals_colors.animal_id
JOIN animals_breeds
ON animals.'index' = animals_breeds.animal_id
JOIN animals_types
ON animals.'index' = animals_types.animal_id
JOIN outcome
    ON animals.'index' = outcome.id;







