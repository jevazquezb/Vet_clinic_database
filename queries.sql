/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals;
SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered AND escape_attempts < 3;
SELECT * FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT * FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3; /*The same as using BETWEEN*/

/* Transactions */
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon%';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth >= '2022-01-01';
SELECT * FROM animals;
SAVEPOINT SPDABD;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO SPDABD;
SELECT * FROM animals;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;

/* Queries */
SELECT COUNT(*) FROM animals;
SELECT COUNT(escape_attempts) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

/* Queries: JOIN statement */
SELECT full_name AS owner, name AS animal
FROM animals
JOIN owners ON owner_id = owners.id
WHERE full_name = 'Melody Pond';

SELECT animals.name AS animal, species.name AS species
FROM animals
JOIN species ON species_id = species.id
WHERE species.name = 'Pokemon';

SELECT full_name AS owner, name AS animal
FROM animals
RIGHT JOIN owners ON owner_id = owners.id;

SELECT species.name AS species, COUNT(species.name) AS num_animals
FROM animals
JOIN species ON species_id = species.id
GROUP BY species.name;

SELECT full_name AS owner, animals.name AS animal, species.name AS species
FROM animals
JOIN owners ON owner_id = owners.id
JOIN species ON species_id = species.id
WHERE full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

SELECT full_name AS owner, name AS animal, escape_attempts
FROM animals
JOIN owners ON owner_id = owners.id
WHERE full_name = 'Dean Winchester' AND escape_attempts = 0;

SELECT full_name AS owner, COUNT(name) AS num_animals
FROM animals
RIGHT JOIN owners ON owner_id = owners.id
GROUP BY full_name ORDER BY num_animals DESC;
