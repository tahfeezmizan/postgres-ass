-- Active: 1748017382211@@127.0.0.1@5432@conservation_db

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

SELECT * from rangers;

INSERT INTO
    rangers (name, region)
VALUES ('Korim Mia', 'Northern Hills'),
    ('Rofik', 'River Delta'),
    ('Shamim', 'Marshlands'),
    ('Bishal', 'Eastern Wetlands');

SELECT name, COUNT(*) AS total_sightings
FROM rangers
    JOIN sightings USING (ranger_id)
GROUP BY
    name;

DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT ranger_id
        FROM sightings
    );

--------------------------------------------------

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);

SELECT * FROM species;

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Himalayan Brown Bear',
        'Ursus arctos isabellinus',
        '1854-01-01',
        'Vulnerable'
    ),
    (
        'Indian Pangolin',
        'Manis crassicaudata',
        '1822-01-01',
        'Endangered'
    ),
    (
        'Clouded Leopard',
        'Neofelis nebulosa',
        '1821-01-01',
        'Vulnerable'
    ),
    (
        'Ganges River Dolphin',
        'Platanista gangetica',
        '1801-01-01',
        'Endangered'
    );

SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

SELECT common_name, sighting_time, name
FROM sightings
    JOIN rangers USING (ranger_id)
    JOIN species USING (species_id)
ORDER BY sighting_time DESC
LIMIT 2;

UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1800-01-01';

------------------------------------------------------

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER NOT NULL,
    species_id INTEGER NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT,
    FOREIGN KEY (ranger_id) REFERENCES rangers (ranger_id),
    FOREIGN KEY (species_id) REFERENCES species (species_id)
);

SELECT * FROM sightings;

INSERT INTO
    sightings (
        ranger_id,
        species_id,
        sighting_time,
        location,
        notes
    )
VALUES (
        2,
        4,
        '2023-09-10 08:30:00',
        'Western Ghats',
        'Seen near the river edge'
    );

SELECT * FROM sightings WHERE location LIKE '%Forest%';

SELECT common_name
FROM species
WHERE
    species_id NOT IN (
        SELECT species_id
        FROM sightings
    );

SELECT
    sighting_id,
    CASE
        WHEN sighting_time::TIME < '12:00:00' THEN 'Morning'
        WHEN sighting_time::TIME BETWEEN '12:00:00' AND '17:00:00'  THEN 'Afternoon'
        WHEN sighting_time::TIME > '17:00:00' THEN 'Evening'
    END AS time_of_day
FROM sightings;