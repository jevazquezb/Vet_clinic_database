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

/* Queries: many-to-many */

/* Who was the last animal seen by William Tatcher?*/
SELECT vets.name AS vet, animals.name AS animal, date_of_visit
FROM visits
JOIN vets ON vets_id = vets.id
JOIN animals ON animals_id = animals.id
WHERE vets.name = 'William Tatcher'
ORDER BY date_of_visit DESC
LIMIT 1;

/* How many different animals did Stephanie Mendez see? */
SELECT vets.name AS vet, COUNT(DISTINCT animals.name) AS num_animals
FROM visits
JOIN vets ON vets_id = vets.id
JOIN animals ON animals_id = animals.id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vet;

/* Another solution */
SELECT COUNT(animal) AS num_animals FROM (
  SELECT COUNT(vets.name) AS num_visits, animals.name AS animal
  FROM visits
  JOIN vets ON vets_id = vets.id
  JOIN animals ON animals_id = animals.id
  WHERE vets.name = 'Stephanie Mendez'
  GROUP BY animal
) AS animal_kind;

/* List all vets and their specialties, including vets with no specialties. */ 
SELECT vets.name AS vet, species.name AS specialty
FROM specializations
JOIN vets ON vets_id = vets.id
LEFT JOIN species ON species_id = species.id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */ 
SELECT vets.name AS vet, animals.name AS animal, date_of_visit
FROM visits
JOIN vets ON vets_id = vets.id
JOIN animals ON animals_id = animals.id
WHERE vets.name = 'Stephanie Mendez' AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

/* What animal has the most visits to vets? */
SELECT animals.name AS animal, COUNT(vets.name) AS num_visits
FROM visits
JOIN vets ON vets_id = vets.id
JOIN animals ON animals_id = animals.id
GROUP BY animal
ORDER BY num_visits DESC
limit 1;

/* Who was Maisy Smith's first visit? */
SELECT vets.name AS vet, animals.name AS animal, date_of_visit
FROM visits
JOIN vets ON vets_id = vets.id
JOIN animals ON animals_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY date_of_visit
LIMIT 1;

/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT
  animals.name AS animal,
  date_of_birth,
  escape_attempts,
  neutered,
  weight_kg,
  vets.name AS vet,
  age AS vet_age,
  date_of_graduation AS vet_graduation,
  date_of_visit
FROM visits
JOIN vets ON vets_id = vets.id
JOIN animals ON animals_id = animals.id
ORDER BY date_of_visit DESC
LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(vet) as num_visits
FROM (
  SELECT animals.name AS animal, animals.species_id AS species, vets.name AS vet, S.species_id AS vet_specialty
  FROM visits
  JOIN vets ON vets_id = vets.id
  JOIN animals ON animals_id = animals.id
  JOIN specializations S ON S.vets_id = vets.id
  WHERE vets.name != 'Stephanie Mendez' AND animals.species_id != S.species_id OR S.species_id IS NULL
) AS not_specialized;

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT species.name AS species, COUNT(vets.name) AS num_visits
FROM visits
JOIN vets ON vets_id = vets.id
JOIN animals ON animals_id = animals.id
JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name;