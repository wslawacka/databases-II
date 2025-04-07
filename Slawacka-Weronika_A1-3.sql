USE `library`;

DELIMITER $$

DROP PROCEDURE IF EXISTS InsertMembers$$
CREATE PROCEDURE InsertMembers(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_name VARCHAR(45);
    DECLARE random_surname VARCHAR(45);
    DECLARE random_birth_date DATE;
    DECLARE random_phone_number VARCHAR(15);
    DECLARE random_email_address VARCHAR(45);
    DECLARE address_id INT;
    DECLARE done INT DEFAULT 0;

    DECLARE address_cursor CURSOR FOR SELECT id_address FROM `library`.`address`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

START TRANSACTION;

OPEN address_cursor;

WHILE i < number_of_records DO

        FETCH address_cursor INTO address_id;
        IF done THEN
            SET done = 0;
            CLOSE address_cursor;
            OPEN address_cursor;
            FETCH address_cursor INTO address_id;
        END IF;

        SET random_name = ELT(FLOOR(1 + RAND() * 50),
                              'Aiden', 'Bella', 'Caleb', 'Daisy', 'Ethan', 'Fiona', 'Gavin', 'Hannah', 'Isaac',
                              'Jasmine', 'Kai', 'Luna', 'Mason', 'Nora', 'Owen', 'Piper', 'Quinn', 'Riley', 'Samuel',
                              'Tessa', 'Uriel', 'Violet', 'Wyatt', 'Xena', 'Yara', 'Zane', 'Amelia', 'Blake', 'Cora',
                              'Declan', 'Eliana', 'Felix', 'Grace', 'Hudson', 'Ivy', 'Jacob', 'Kylie', 'Leo', 'Mila',
                              'Nathan','Olivia', 'Preston', 'Quincy', 'Ryan', 'Sophia', 'Tristan', 'Ulysses',
                              'Victoria', 'William', 'Zoey');
        SET random_surname = ELT(FLOOR(1 + RAND() * 50),
                                 'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
                                 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
                                 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White',
                                 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker', 'Young',
                                 'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores', 'Green',
                                 'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell', 'Carter',
                                 'Roberts');
        SET random_birth_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(18 + RAND() * 42) YEAR);
        SET random_birth_date = DATE_SUB(random_birth_date, INTERVAL FLOOR(RAND() * 365) DAY);
        REPEAT
SET random_phone_number = CONCAT('+1', FLOOR(1000000000 + RAND() * 9000000000));
        UNTIL NOT EXISTS (SELECT 1 FROM `library`.`member` WHERE phone_number = random_phone_number)
END REPEAT;
        REPEAT
SET random_email_address = CONCAT(LOWER(random_name), '.', LOWER(random_surname),
                                              FLOOR(1 + RAND() * 1000), '@example.com');
        UNTIL NOT EXISTS (SELECT 1 FROM `library`.`member` WHERE email_address = random_email_address)
END REPEAT;

INSERT INTO `library`.`member`(name, surname, phone_number, email_address, birth_date, FK_address)
VALUES (random_name, random_surname, random_phone_number,
        random_email_address, random_birth_date, address_id);

SET i = i + 1;

END WHILE;
CLOSE address_cursor;
COMMIT;

END $$

DROP PROCEDURE IF EXISTS InsertAuthors$$
CREATE PROCEDURE InsertAuthors(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_name VARCHAR(45);
    DECLARE random_surname VARCHAR(45);
    DECLARE random_birth_date DATE;
    DECLARE nationality_id INT;
    DECLARE done INT DEFAULT 0;

    DECLARE nationality_cursor CURSOR FOR SELECT id_nationality FROM `library`.`nationality`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

START TRANSACTION;

OPEN nationality_cursor;

WHILE i < number_of_records DO

        FETCH nationality_cursor INTO nationality_id;
        IF done THEN
            SET done = 0;
            CLOSE nationality_cursor;
            OPEN nationality_cursor;
            FETCH nationality_cursor INTO nationality_id;
        END IF;

        SET random_name = ELT(FLOOR(1 + RAND() * 50),
                                  'Aiden', 'Bella', 'Caleb', 'Daisy', 'Ethan', 'Fiona', 'Gavin', 'Hannah', 'Isaac',
                                  'Jasmine', 'Kai', 'Luna', 'Mason', 'Nora', 'Owen', 'Piper', 'Quinn', 'Riley', 'Samuel',
                                  'Tessa', 'Uriel', 'Violet', 'Wyatt', 'Xena', 'Yara', 'Zane', 'Amelia', 'Blake', 'Cora',
                                  'Declan', 'Eliana', 'Felix', 'Grace', 'Hudson', 'Ivy', 'Jacob', 'Kylie', 'Leo', 'Mila',
                                  'Nathan','Olivia', 'Preston', 'Quincy', 'Ryan', 'Sophia', 'Tristan', 'Ulysses',
                                  'Victoria', 'William', 'Zoey');
        SET random_surname = ELT(FLOOR(1 + RAND() * 50),
                                     'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
                                     'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
                                     'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White',
                                     'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker', 'Young',
                                     'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores', 'Green',
                                     'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell', 'Carter',
                                     'Roberts');
        SET random_birth_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(18 + RAND() * 42) YEAR);
        SET random_birth_date = DATE_SUB(random_birth_date, INTERVAL FLOOR(RAND() * 365) DAY);

INSERT INTO `library`.`author`(name, surname, birth_date, FK_nationality)
VALUES (random_name, random_surname, random_birth_date, nationality_id);

SET i = i + 1;

END WHILE;
CLOSE nationality_cursor;
COMMIT;

END $$


DROP PROCEDURE IF EXISTS InsertAddresses$$
CREATE PROCEDURE InsertAddresses(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_street_name VARCHAR(45);
    DECLARE random_house_number VARCHAR(10);
    DECLARE city_id INT;
    DECLARE done INT DEFAULT 0;

    DECLARE city_cursor CURSOR FOR SELECT id_city FROM `library`.`city`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

START TRANSACTION;

OPEN city_cursor;

WHILE i < number_of_records DO

        FETCH city_cursor INTO city_id;
        IF done THEN
            SET done = 0;
            CLOSE city_cursor;
            OPEN city_cursor;
            FETCH city_cursor INTO city_id;
        END IF;

        SET random_street_name = ELT(FLOOR(1 + RAND() * 50),
                'Bamboo Road','Cypress Drive','Lotus Boulevard','Sunflower Drive','Almond Road','Maple Avenue',
                'Hazel Lane','Birch Drive','Linden Road','Juniper Street','Pinecone Way','Geranium Drive',
                'Orchid Avenue','Sycamore Street','Daisy Lane','Magnolia Lane','Acacia Road','Ash Street',
                'Daffodil Lane','Fuchsia Way','Clover Street','Cherry Blossom Road','Mimosa Lane','Marigold Avenue',
                'Pine Road','Oak Street','Redwood Drive','Ivy Street','Camellia Avenue','Lilac Way',
                'Jasmine Boulevard','Saffron Street','Cinnamon Road','Magnolia Lane','Cedar Lane','Rosemary Street',
                'Elm Street','Wisteria Drive','Spruce Drive','Violet Road','Cherry Boulevard','Azalea Way',
                'Poppy Street','Hickory Avenue','Sequoia Way','Willow Way','Tulip Avenue','Mulberry Avenue',
                'Lavender Road','Buttercup Street');
        SET random_house_number = ELT(FLOOR(1 + RAND() * 50),
                                  '52','28','17','55','44','22','12','46','6','49',
                                  '31','2','35','13','48','53','20','23','19','51',
                                  '43','38','7','45','50','58','21','11','29','57',
                                  '37','15','33','4','3','41','16','56','1','32',
                                  '34','27','24','30','8','9','18','47','39','36'

                              );

INSERT INTO `library`.`address`(street_name, house_number, FK_city)
VALUES(random_street_name, random_house_number, city_id);

SET i = i + 1;

END WHILE;
CLOSE city_cursor;
COMMIT;

END $$

DROP PROCEDURE IF EXISTS InsertBooks$$
CREATE PROCEDURE InsertBooks(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_title VARCHAR(100);
    DECLARE random_publication_year YEAR;
    DECLARE random_ISBN VARCHAR(20);
    DECLARE genre_id INT;
    DECLARE done INT DEFAULT 0;

    DECLARE genre_cursor CURSOR FOR SELECT id_genre FROM `library`.`genre`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

START TRANSACTION;

OPEN genre_cursor;

WHILE i < number_of_records DO

        FETCH genre_cursor INTO genre_id;
        IF done THEN
            SET done = 0;
            CLOSE genre_cursor;
            OPEN genre_cursor;
            FETCH genre_cursor INTO genre_id;
        END IF;

        SET random_title = ELT(FLOOR(1 + RAND() * 50),
                               'The Silent Echo','Whispers of the Past','Journey to the Unknown','Beyond the Horizon',
                               'The Last Secret','Echoes in the Dark','Tides of Destiny','Shadows of the Forgotten',
                               'The Painted Sky','Dreams of Tomorrow','The Hidden Path','The Clockwork Heart',
                               'A Dance with Time','The Lost Key','Fires of Eternity','Wings of the Phoenix',
                               'The Broken Crown','Into the Abyss','The Garden of Souls','The Enchanted Forest',
                               'Beneath the Moonlight','The Midnight Song','The Fallen Star','Whispers in the Wind',
                               'The Twilight Chronicles','The Rose of the Desert','Blood and Sand',
                               'The Edge of the World','The Secret Beneath','Storm of Fire','The Last Knight',
                               'Rise of the Forgotten','The Emerald City','Tales from the Other Side',
                               'The Crystal Labyrinth','A Heart of Ice','The Shadow\'s Embrace','When the Stars Fade',
                               'The Edge of Forever','The Sorcerer\'s Spell','In the Wake of the Storm',
                               'The Celestial Map','The Firebird\'s Song','The Masked Stranger','Veins of Gold',
                               'The Abyssal Tide','The Last Dreamer','Beneath the Starlight','The Phantom\'s Curse',
                               'The Clockwork Prince'
                           );
        SET random_publication_year = FLOOR(1901 + RAND() * 124);

        REPEAT
            SET random_ISBN = CONCAT('978-', LPAD(FLOOR(RAND() * 1000000000000), 12, '0'));
        UNTIL NOT EXISTS(SELECT 1 FROM book WHERE ISBN = random_ISBN)
        END REPEAT;
INSERT INTO `library`.`book`(title, publication_year, ISBN, FK_genre)
VALUES (random_title, random_publication_year, random_ISBN, genre_id);

SET i = i + 1;

END WHILE;
CLOSE genre_cursor;
COMMIT;

END $$

DROP PROCEDURE IF EXISTS InsertCities$$
CREATE PROCEDURE InsertCities(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_name VARCHAR(45);
    DECLARE random_adjective VARCHAR(20);
    DECLARE random_feature VARCHAR(20);
    DECLARE random_number INT;

START TRANSACTION;

WHILE i < number_of_records DO

        REPEAT
            SET random_adjective = ELT(FLOOR(1 + RAND() * 19),
                                       'Green', 'Sunny', 'Crystal', 'Silver', 'Red', 'Mountain', 'River', 'Blue',
                                       'Golden', 'Bright', 'New', 'West', 'North', 'East', 'South', 'Little', 'Big',
                                       'Cold', 'Warm');
            SET random_feature = ELT(FLOOR(1 + RAND() * 18),
                                     'River', 'Hill', 'Lake', 'Valley', 'Forest', 'Park', 'Beach', 'Bay', 'Point',
                                     'Grove', 'Spring', 'Cliff', 'Creek', 'Island', 'Shore', 'Cove', 'Peak', 'Wood');
            SET random_number = FLOOR(1000 + RAND() * 9000);
            SET random_name = CONCAT(random_adjective, random_feature, '-', random_number);
            IF LENGTH(random_name) > 45 THEN
                SET random_name = LEFT(random_name, 45);
            END IF;

        UNTIL NOT EXISTS (SELECT 1 FROM `library`.`city` WHERE name = random_name)
        END REPEAT;

INSERT INTO `library`.`city`(name)
VALUES (random_name);

SET i = i + 1;

END WHILE;

COMMIT;

END $$


DROP PROCEDURE IF EXISTS InsertGenres$$
CREATE PROCEDURE InsertGenres(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_name VARCHAR(45);
    DECLARE random_description TEXT;
    DECLARE random_adjective VARCHAR(20);
    DECLARE random_theme VARCHAR(20);
    DECLARE random_number INT;

START TRANSACTION;

WHILE i < number_of_records DO
            REPEAT
                SET random_adjective = ELT(FLOOR(1 + RAND() * 15),
                                           'Epic', 'Dark', 'Futuristic', 'Mythic', 'Ancient', 'Enchanted',
                                           'Mysterious', 'Lost', 'Secret', 'Forbidden', 'Infinite',
                                           'Legendary', 'Parallel', 'Celestial', 'Obscure');
                SET random_theme = ELT(FLOOR(1 + RAND() * 15),
                                       'Fantasy', 'Chronicles', 'Mystery', 'Saga', 'Realm', 'Tales',
                                       'Cyberpunk', 'Horror', 'Mythology', 'Adventure', 'Thriller',
                                       'Dystopia', 'Romance', 'Paradox', 'Expedition');
                SET random_number = FLOOR(100 + RAND() * 900);
                SET random_name = CONCAT(random_adjective, ' ', random_theme, ' ', random_number);
                IF LENGTH(random_name) > 45 THEN
                    SET random_name = LEFT(random_name, 45);
END IF;
            UNTIL NOT EXISTS (SELECT 1 FROM `library`.`genre` WHERE name = random_name)
END REPEAT;
            SET random_description = CONCAT('A unique blend of ', random_adjective, ' and ', random_theme, ' stories.');

INSERT INTO `library`.`genre`(name, description)
VALUES (random_name, random_description);

SET i = i + 1;

END WHILE;

COMMIT;

END $$


DROP PROCEDURE IF EXISTS InsertNationalities$$
CREATE PROCEDURE InsertNationalities(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_name VARCHAR(45);
    DECLARE random_prefix VARCHAR(10);
    DECLARE random_base VARCHAR(20);
    DECLARE random_suffix VARCHAR(10);
    DECLARE random_number INT;

START TRANSACTION;

WHILE i < number_of_records DO
        REPEAT
            SET random_prefix = ELT(FLOOR(1 + RAND() * 6),
                                        '', 'Rep.', 'Fed.', 'Kingdom', 'State', 'Empire');
            SET random_base = ELT(FLOOR(1 + RAND() * 20),
                                      'Atlantis', 'Avalon', 'Zetonia', 'Eldor', 'Nordic', 'Valer',
                                      'Azuri', 'Dracon', 'Celest', 'Novar', 'Verid', 'Orion',
                                      'Solter', 'Lumin', 'Zephyr', 'Mystar', 'Arcan', 'Vesper',
                                      'Thalas', 'Merid');
            SET random_suffix = ELT(FLOOR(1 + RAND() * 5),
                                        '', ' Union', ' State', ' Confed.', ' Nation');
            SET random_number = FLOOR(10 + RAND() * 90);
            SET random_name = TRIM(CONCAT(random_prefix, ' ', random_base, random_suffix, ' ', random_number));
            IF LENGTH(random_name) > 45 THEN
                SET random_name = LEFT(random_name, 45);
END IF;
        UNTIL NOT EXISTS (SELECT 1 FROM `library`.`nationality` WHERE name = random_name)
END REPEAT;

INSERT INTO `library`.`nationality`(name)
VALUES (random_name);

SET i = i + 1;

END WHILE;

COMMIT;

END $$


DROP PROCEDURE IF EXISTS InsertBookAuthors$$
CREATE PROCEDURE InsertBookAuthors(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE book_id INT;
    DECLARE author_id INT;
    DECLARE author_count INT;

    DECLARE book_cursor CURSOR FOR SELECT id_book FROM `library`.`book`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    START TRANSACTION;

    OPEN book_cursor;

    WHILE i < number_of_records DO

            FETCH book_cursor INTO book_id;
            IF done THEN
                SET done = 0;
                CLOSE book_cursor;
                OPEN book_cursor;
                FETCH book_cursor INTO book_id;
            END IF;

            SET author_count = FLOOR(1 + RAND() * 3);

            WHILE author_count > 0 DO
                    SELECT id_author INTO author_id FROM `library`.`author` ORDER BY RAND() LIMIT 1;

                    IF NOT EXISTS (
                        SELECT 1 FROM `library`.`book_author`
                        WHERE FK_Book = book_id AND FK_Author = author_id
                    ) THEN
                        INSERT INTO `library`.`book_author` (FK_book, FK_author)
                        VALUES (book_id, author_id);
                    END IF;

                    SET author_count = author_count - 1;
            END WHILE;

            SET i = i + 1;
    END WHILE;

    CLOSE book_cursor;
    COMMIT;

END $$


DROP PROCEDURE IF EXISTS InsertMemberships$$
CREATE PROCEDURE InsertMemberships(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE member_id INT;
    DECLARE random_date_from DATE;
    DECLARE random_date_to DATE;

    DECLARE member_cursor CURSOR FOR SELECT id_member FROM `library`.`member`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    START TRANSACTION;

    OPEN member_cursor;

    WHILE i < number_of_records DO
            FETCH member_cursor INTO member_id;
            IF done THEN
                SET done = 0;
                CLOSE member_cursor;
                OPEN member_cursor;
                FETCH member_cursor INTO member_id;
            END IF;

            SET random_date_from = DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * DATEDIFF(CURDATE(), '2020-01-01')) DAY);
            SET random_date_to = DATE_ADD(random_date_from, INTERVAL FLOOR(30 + RAND() * 1035) DAY);

            INSERT INTO `library`.`membership` (date_from, date_to, FK_member)
            VALUES (random_date_from, random_date_to, member_id);

            SET i = i + 1;
        END WHILE;

    CLOSE member_cursor;
    COMMIT;

END $$


DROP PROCEDURE IF EXISTS InsertReservations$$
CREATE PROCEDURE InsertReservations(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE done1 INT DEFAULT 0;
    DECLARE done2 INT DEFAULT 0;
    DECLARE member_id INT;
    DECLARE book_id INT;
    DECLARE random_reservation_date DATE;
    DECLARE random_due_date DATE;
    DECLARE random_return_date DATE;
    DECLARE random_status ENUM('borrowed', 'returned');

    DECLARE member_cursor CURSOR FOR SELECT id_member FROM `library`.`member`;
    DECLARE book_cursor CURSOR FOR SELECT id_book FROM `library`.`book`;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = 1, done2 = 1;

    START TRANSACTION;

    OPEN member_cursor;
    OPEN book_cursor;

    WHILE i < number_of_records DO

            FETCH member_cursor INTO member_id;
            IF done1 THEN
                SET done1 = 0;
                CLOSE member_cursor;
                OPEN member_cursor;
                FETCH member_cursor INTO member_id;
            END IF;

            FETCH book_cursor INTO book_id;
            IF done2 THEN
                SET done2 = 0;
                CLOSE book_cursor;
                OPEN book_cursor;
                FETCH book_cursor INTO book_id;
            END IF;

            SET random_reservation_date = DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * DATEDIFF(CURDATE(), '2020-01-01')) DAY);
            SET random_due_date = DATE_ADD(random_reservation_date, INTERVAL FLOOR(7 + RAND() * 23) DAY);
            IF RAND() < 0.5 THEN
                SET random_status = 'borrowed';
                SET random_return_date = NULL;
            ELSE
                SET random_status = 'returned';
                SET random_return_date = DATE_ADD(random_due_date, INTERVAL FLOOR(-5 + RAND() * 10) DAY);
            END IF;

            INSERT INTO `library`.`reservation`(reservation_date, due_date, return_date, status, FK_member, FK_book)
            VALUES (random_reservation_date, random_due_date, random_return_date,
                    random_status, member_id, book_id);

        SET i = i + 1;
    END WHILE;

    CLOSE member_cursor;
    CLOSE book_cursor;
    COMMIT;

END $$



DELIMITER ;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `address`;
TRUNCATE TABLE `author`;
TRUNCATE TABLE `book`;
TRUNCATE TABLE `book_author`;
TRUNCATE TABLE `city`;
TRUNCATE TABLE `genre`;
TRUNCATE TABLE `member`;
TRUNCATE TABLE `membership`;
TRUNCATE TABLE `nationality`;
TRUNCATE TABLE `reservation`;

SET FOREIGN_KEY_CHECKS = 1;

CALL InsertCities(1000);
CALL InsertGenres(1000);
CALL InsertNationalities(1000);
CALL InsertAddresses(1000);
CALL InsertAuthors(1000);
CALL InsertBooks(1000);
CALL InsertBookAuthors(1000);
CALL InsertMembers(1000);
CALL InsertMemberships(1000);
CALL InsertReservations(1000);

SELECT * FROM `city`;
SELECT * FROM `genre`;
SELECT * FROM `nationality`;
SELECT * FROM `address`;
SELECT * FROM `author`;
SELECT * FROM `book`;
SELECT * FROM `book_author`;
SELECT * FROM `member`;
SELECT * FROM `membership`;
SELECT * FROM `reservation`;