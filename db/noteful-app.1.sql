--psql -U dev -f noteful-app.1.sql  noteful-app;

DROP TABLE IF EXISTS notes_tags;
DROP TABLE IF EXISTS notes;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS folders;

-- SELECT CURRENT_DATE;

CREATE TABLE folders(
	id serial PRIMARY KEY,
	name text NOT NULL
);

CREATE TABLE notes(
	id serial PRIMARY KEY,
	title text NOT NULL,
	content text,
	created TIMESTAMP DEFAULT now(),
	folder_id int REFERENCES folders(id) ON DELETE SET NULL
);
CREATE TABLE tags(
	id serial PRIMARY KEY,
	name text NOT NULL UNIQUE
);

CREATE TABLE notes_tags (
  note_id INTEGER NOT NULL REFERENCES notes ON DELETE CASCADE,
  tag_id INTEGER NOT NULL REFERENCES tags ON DELETE CASCADE
);


ALTER SEQUENCE notes_id_seq RESTART WITH 1000;
ALTER SEQUENCE folders_id_seq RESTART WITH 100;
ALTER SEQUENCE tags_id_seq RESTART WITH 500;

INSERT INTO folders
(name)
VALUES
('Archive'), ('Drafts'), ('Personal'), ('Work');

-- INSERT INTO notes
-- (title, content)
-- VALUES

INSERT INTO notes (title, content, folder_id) VALUES
('5 life lessons learned from cats', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 100),

('What the government does not want you to know about cats', 'Posuere sollicitudin aliquam ultrices sagittis orci a. Feugiat sed lectus vestibulum mattis ullamcorper velit. Odio pellentesque diam volutpat commodo sed egestas egestas fringilla. Velit egestas dui id ornare arcu odio. Molestie at elementum eu facilisis sed odio morbi.', 101),

('The most boring article about cats you will ever read', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 102),

('The most incredible article about cats you will ever read', 'Lorem ipsum dolor sit amet, boring consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 103),
('10 ways cats can help you live to 100', 'Posuere sollicitudin aliquam ultrices sagittis orci a. Feugiat sed lectus vestibulum mattis ullamcorper velit. Odio pellentesque diam volutpat commodo sed egestas egestas fringilla. Velit egestas dui id ornare arcu odio. Molestie at elementum eu facilisis sed odio morbi. Tempor nec feugiat nisl pretium. At tempor commodo ullamcorper a lacus. Egestas dui id ornare arcu odio.', 103),
('9 reasons you can blame the recession on cats', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 102),
('10 ways marketers are making you addicted to cats', 'Posuere sollicitudin aliquam ultrices sagittis orci a. Feugiat sed lectus vestibulum mattis ullamcorper velit. Odio pellentesque diam volutpat commodo sed egestas egestas fringilla. Velit egestas dui id ornare arcu odio. Molestie at elementum eu facilisis sed odio morbi. Tempor nec feugiat nisl pretium. At tempor commodo ullamcorper a lacus.', 101),
('11 ways investing in cats can make you a millionaire', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 100),
('Why you should forget everything you learned about cats', 'Posuere sollicitudin aliquam ultrices sagittis orci a. Feugiat sed lectus vestibulum mattis ullamcorper velit. Odio pellentesque diam volutpat commodo sed egestas egestas fringilla. Velit egestas dui id ornare arcu odio. Molestie at elementum eu facilisis sed odio morbi. Tempor nec feugiat nisl pretium. At tempor commodo ullamcorper a lacus.', 101),
('Bob Ross', 'With practice comes confidence. Only God can make a tree - but you can paint one. All you have to learn here is how to have fun.', 102),
('Bob Ross Paints', 'Just make little strokes like that. But we are not there yet, so we do not need to worry about it. Let us have a happy little tree in here.', 103),
('Bob Ross Trees', 'Let us put some happy little bushes on the other side now. Even trees need a friend. We all need friends.', 103),
('Happy Little Trees', 'Do not hurry. Take your time and enjoy. We wash our brush with odorless thinner. This is the way you take out your frustrations', 101),
('You Can Do It', 'Clouds are free they come and go as they please. Of course he is a happy little stone, cause we do not have any other kind.', 100),
('Little Stokes', 'This is probably the greatest thing that has ever happened in my life. Trees live in your fan brush, but you have to scare them out.', 101),
('Load Up That Brush', 'In nature, dead trees are just as normal as live trees. I like to beat the brush.', 102),
('Star Trek', 'These are the voyages of the Starship Enterprise. Its continuing mission, to explore strange new worlds, to seek out new life and new civilizations, to boldly go where no one has gone before.', 103),
('Warp Core Implosion', 'Deflector power at maximum. Energy discharge in six seconds. Warp reactor ', 102),
('Live Long', 'Stellar flares are increasing in magnitude and frequency. Set course for Rhomboid Dronegar 006, warp seven. ', 101),
('Another', 'Automatically create a time stamp.', 100),
('This is the Song That Never Ends', 'Oh, no. Not that song again', 101),
('My Hat', 'It has 3 corners', 102),
('All Aboard', 'Hear the whistle blow', 103),
('The Football Game', 'Rake, rake, shuffle shuffle, that is how it goes.', 102);

INSERT INTO tags
(name)
VALUES
('Dakota'), ('Ray'), ('Amanda'), ('Kate');

INSERT INTO notes_tags
(note_id, tag_id)
VALUES
(1000, 500),
(1001, 501), (1001, 502),
(1002, 502),
(1003, 503), (1003, 500),
(1004, 500),
(1005, 501), (1005, 503),
(1006, 502),
(1007, 503), (1007, 502),
(1008, 502),
(1009, 503), (1009, 501),
(1010, 500),
(1011, 501), (1011, 502),
(1012, 502),
(1013, 503), (1013, 500),
(1014, 500),
(1015, 501), (1015, 502),
(1016, 502),
(1017, 503), (1017, 502),
(1018, 500),
(1019, 501), (1019, 502),
(1020, 502),
(1021, 503), (1021, 500),
(1022, 500),
(1023, 501), (1023, 502);




--============================================= COMMANDS TO SELECT INSERT ETC =============
-- ADD JOIN
-- SELECT title, tags.name, folders.name  FROM notes
-- LEFT JOIN folders ON notes.folder_id = folders.id
-- LEFT JOIN notes_tags ON notes.id = notes_tags.note_id
-- LEFT JOIN tags ON notes_tags.tag_id = tags.id;

SELECT title, tags.name as tags_name, folders.name as folder_name FROM notes
LEFT JOIN folders ON notes.folder_id = folders.id
LEFT JOIN notes_tags ON notes.id = notes_tags.note_id
LEFT JOIN tags ON notes_tags.tag_id = tags.id;

--\x -- enable expanded display
-- SELECT id, title, created from notes;
-- SELECT title from notes;

-- SELECT * from notes LIMIT 5;
-- SELECT * from notes ORDER BY title;
-- SELECT * from notes ORDER BY title DESC;
-- SELECT * from notes ORDER BY created;
-- SELECT * from notes ORDER BY created DESC;
-- SELECT * from notes WHERE title = 'Bob Ross'
-- SELECT title from notes WHERE title LIKE '%the%';  -- find the anyplace in title
-- UPDATE notes SET title = 'New Title',  content = 'This is new, updated content' WHERE id = 1013;
-- INSERT INTO notes (title) VALUES ('New Note Title');
-- DELETE FROM notes WHERE id = 1013;

-- ----------------------USE TO RUN DATABASE -----------------------
--psql -U dev -f noteful-app.1.sql -d noteful-app;

--  -----------------Querying samples ------------------------------
-- SELECT id, name, borough, cuisine  FROM restaurants;
-- SELECT DISTINCT borough  FROM restaurants;
-- SELECT id, name, borough, cuisine FROM restaurants WHERE id='225';
-- SELECT name, borough, cuisine FROM restaurants WHERE borough = 'Brooklyn' AND cuisine = 'Italian';
-- SELECT name, borough, cuisine FROM restaurants WHERE borough = 'Brooklyn' AND cuisine in ('Italian', 'Chinese');

-- ----------------------ORDER BY    LIMIT ------------------------------
-- SELECT id, name from restaurants WHERE borough = 'Bronx' AND cuisine = 'Japanese' ORDER BY name DESC;
-- SELECT id, name FROM restaurants ORDER BY name DESC; LIMIT 3;

-- ------------------ Aggregate: Count, Max, Min, Avg ------------------------------
-- SELECT count(*) FROM grades;
-- SELECT max(score) FROM grades;
-- SELECT min(score) FROM grades;
-- SELECT avg(score) FROM grades;

-- ------------------ UPDATING   ------------------------------
-- UPDATE restaurants  SET name = 'Famous Original Ray''s Pizza'  WHERE id = 5269;
-- UPDATE restaurants  SET cuisine = 'Vegetarian'  WHERE cuisine = 'Pizza';

-- ------------------ DELETING  ------------------------------
-- DELETE FROM restaurants WHERE id = 225;
-- DELETE FROM grades WHERE grade = 'Z';
-- DELETE FROM grades;  (Beware: deletes all rows in grades)

-- ------------------ ENUMERATIONS  ------------------------------
-- CREATE TYPE mood AS ENUM ('sad', 'ok', 'happy');
-- CREATE TABLE person (
--     name text,
--     current_mood mood
-- );
-- INSERT INTO person VALUES ('Moe', 'happy');
-- INSERT INTO person VALUES ('Larry', 'sad');
-- INSERT INTO person VALUES ('Curly', 'ok');
-- SELECT * FROM person WHERE current_mood = 'happy';
--  name | current_mood
-- ------+--------------
--  Moe  | happy

-- SELECT * FROM person WHERE current_mood > 'sad';
--  name  | current_mood
-- -------+--------------
--  Moe   | happy
--  Curly | ok

--  -----------------Commands to use ------------------------------
--Start SERVER     	pg_ctl start -l "$PGDATA/server.log"
--Create Database  	createdb -U dev <DATABASE>
--Import      			psql <DATABASE> < ~/Downloads/import-file.sql
--             			psql -U dev -d <DATABASE> -f ~/Downloads/import-file.sql
--Server Status   	pg_ctl status
--Drop Database   	dropdb <DATABASE>
--  -----------------PSQL Shell Commands ------------------------------
--Login						psql -h <HOSTNAME> -U <USERNAME> <DATABASE>
--Meta-commands		List Databases   : \l
								-- Tables in DB    : \d
								-- Public Tables   : \dt
								-- Public Tables   : \dt+ (add size and description)
								-- To Exit/Quit    : \q
								-- Connect to other: \c
--Prompts
			-- mydb=# super-user
			-- mydb=> normal user
			-- mydb-# continuation
-- --------------------CREATE A TABLE-----------------------------
-- CREATE TABLE restaurants (
--   id                       serial     PRIMARY KEY,
--   name                     text       NOT NULL,
--   nyc_restaurant_id        integer,
--   borough                  borough_options,
--   cuisine                  text,
--   address_building_number  text,
--   address_street           text,
--   address_zipcode          text
-- );

-- PRIMARY KEY : unique (non-duplicate), non-null values
-- SERIAL: auto-incrementing sequence of integers
-- DROP TABLE restaurants;