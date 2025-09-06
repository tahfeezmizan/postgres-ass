CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(70)
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(70),
    scientific_name VARCHAR(120),
    discovery_date DATE,
    conservation_status VARCHAR(30)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(70),
    sighting_time TIMESTAMP,
    notes VARCHAR(100)
);


INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name , region) VALUES
('Derek Fox', 'Coastal Plains');
SELECT * FROM rangers;






SELECT * FROM species;

-- 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';



-- DROP TABLE IF EXISTS sightings;


SELECT * FROM sightings
-- 3️⃣ Find all sightings where the location includes "Pass".
WHERE location LIKE '%Pass';

-- 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

SELECT 
    sighting_id, 
    sighting_time,
    CASE 
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings



--4 List each ranger's name and their total number of sightings.
SELECT rangers.name , count(*) as total_sightings FROM sightings
JOIN rangers on sightings.ranger_id = rangers.ranger_id
GROUP BY rangers.name  ;


-- 5 List species that have never been sighted.
SELECT *
FROM species
WHERE species_id NOT IN (SELECT species_id FROM sightings);


--6 Show the most recent 2 sightings.
SELECT 
    sightings.sighting_time,
    rangers.name AS ranger_name,
    species.common_name AS species_name
FROM sightings
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
JOIN species ON sightings.species_id = species.species_id
ORDER BY sightings.sighting_time DESC
LIMIT 2;


-- 2  Count unique species ever sighted.
SELECT COUNT(DISTINCT species_id) as unique_species_count FROM sightings

-- 9️⃣ Delete rangers who have never sighted any species
DELETE FROM rangers
WHERE ranger_id NOT IN (
  SELECT DISTINCT ranger_id FROM sightings
);
