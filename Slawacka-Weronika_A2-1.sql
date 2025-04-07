USE `library`;

SET foreign_key_checks = 0;

TRUNCATE TABLE `author`;
TRUNCATE TABLE `nationality`;

SET foreign_key_checks = 1;

DELIMITER $$

DROP PROCEDURE IF EXISTS InsertNationalities$$
CREATE PROCEDURE InsertNationalities(IN number_of_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_name VARCHAR(45);
    DECLARE random_prefix VARCHAR(10);
    DECLARE random_base VARCHAR(10);
    DECLARE random_suffix VARCHAR(10);
    DECLARE random_number INT;

    START TRANSACTION;

    WHILE i < number_of_records DO
            REPEAT
                SET random_prefix = ELT(FLOOR(1 + RAND() * 6),
                                        '', 'Rep.', 'Fed.', 'King.', 'State', 'Empire');
                SET random_base = ELT(FLOOR(1 + RAND() * 20),
                                      'Atlantis', 'Avalon', 'Zetonia', 'Eldor', 'Nordic', 'Valer',
                                      'Azuri', 'Dracon', 'Celest', 'Novar', 'Verid', 'Orion',
                                      'Solter', 'Lumin', 'Zephyr', 'Mystar', 'Arcan', 'Vesper',
                                      'Thalas', 'Merid');
                SET random_suffix = ELT(FLOOR(1 + RAND() * 5),
                                        '', ' Union', ' State', ' Confed.', ' Nation');
                SET random_number = FLOOR(1000 + RAND() * 9000);
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

DELIMITER ;

SET @records_number_1k = 1000;
SET @records_number_10k = 10000;

CALL InsertNationalities(@records_number_10k);

DROP TABLE IF EXISTS `result`;
CREATE TABLE `result` (
    id_result INT PRIMARY KEY AUTO_INCREMENT,
    scenario VARCHAR(30) NOT NULL,
    records_number INT NOT NULL,
    query_type VARCHAR(45) NOT NULL,
    query_info TEXT NOT NULL,
    query_time BIGINT NOT NULL
);

DROP PROCEDURE IF EXISTS TestQueriesPerformance;

DELIMITER $$
CREATE PROCEDURE TestQueriesPerformance(IN number_of_records INT, IN scenario VARCHAR(30))
BEGIN
    DECLARE query_type VARCHAR(45);
    DECLARE query_info TEXT;
    DECLARE execution_time BIGINT;

    SET query_type = 'INSERT';

    TRUNCATE TABLE performance_schema.events_statements_history;

    CALL InsertAuthors(number_of_records);

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'CALL InsertAuthors%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT-WHERE';

    TRUNCATE TABLE performance_schema.events_statements_history;

    DO(SELECT COUNT(id_author) FROM `author` WHERE FK_nationality BETWEEN 800 AND 1000);

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE '%SELECT COUNT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT-WHERE-AND/OR';

    TRUNCATE TABLE performance_schema.events_statements_history;

    DO(SELECT COUNT(id_author) FROM `author` WHERE name = 'Amelia' AND surname = 'Johnson');

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE '%SELECT COUNT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT';

    TRUNCATE TABLE performance_schema.events_statements_history;

    DO(SELECT COUNT(id_author) FROM `author`);

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE '%SELECT COUNT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'UPDATE-WHERE';

    SET SQL_SAFE_UPDATES = 0;

    TRUNCATE TABLE performance_schema.events_statements_history;

    UPDATE `author` SET name = CONCAT(name, '_updated') WHERE name = 'Amelia' AND surname = 'Johnson';

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'UPDATE `author`%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'UPDATE';

    TRUNCATE TABLE performance_schema.events_statements_history;

    UPDATE `author` SET name = 'John';

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'UPDATE `author`%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'DELETE';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SET foreign_key_checks = 0;
    DELETE FROM `author`;
    SET foreign_key_checks = 1;

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'DELETE FROM `author`%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);

    SET SQL_SAFE_UPDATES = 1;

END $$

DELIMITER ;


SHOW INDEXES FROM `author`;
CALL TestQueriesPerformance(@records_number_1k, 'Scenario 1.1');
CALL TestQueriesPerformance(@records_number_10k, 'Scenario 1.2');


ALTER TABLE `author` DROP FOREIGN KEY fk_author_nationality;
ALTER TABLE `author` DROP INDEX fk_author_nationality_idx;

SHOW INDEXES FROM `author`;
CALL TestQueriesPerformance(@records_number_1k, 'Scenario 2.1');
CALL TestQueriesPerformance(@records_number_10k, 'Scenario 2.2');


ALTER TABLE `author` ADD CONSTRAINT fk_author_nationality FOREIGN KEY (FK_nationality) REFERENCES `nationality`(id_nationality);
CREATE INDEX idx_author_name ON `author` (name);

SHOW INDEXES FROM `author`;
CALL TestQueriesPerformance(@records_number_1k, 'Scenario 3.1');
CALL TestQueriesPerformance(@records_number_10k, 'Scenario 3.2');


DROP INDEX idx_author_name ON `author`;
CREATE INDEX idx_composite ON `author` (name, surname);

SHOW INDEXES FROM `author`;
CALL TestQueriesPerformance(@records_number_1k, 'Scenario 4.1');
CALL TestQueriesPerformance(@records_number_10k, 'Scenario 4.2');


DROP INDEX idx_composite ON `author`;

SELECT id_result, scenario, records_number, query_type, query_info, ROUND(query_time * 1e-8, 1) AS query_time_ms FROM `result`;

ALTER TABLE `author` ADD INDEX fk_author_nationality_idx (FK_nationality);


/*

INSERT: Execution time increases as the number of inserted records grows, primarily due to the need to update indexes
and check foreign key constraints.
Foreign key constraints and secondary indexes further slow down insertion performance.

SELECT: Execution time varies significantly based on indexing. Without secondary indexes, queries often require full
table scans, which are slower. Simple and composite indexes, on the other hand, significantly improve search speed by
reducing the need for scanning the entire table.

UPDATE and DELETE: These operations take longer when foreign keys and indexes exist because they require additional
integrity checks and index updates.

CONCLUSION:
-> Foreign keys improve query speed but slow down inserts and updates due to integrity checks.
-> Secondary indexes (both simple and composite) can significantly boost query performance by reducing the search time,
but they increase the overhead for insert, update and delete operations due to the need for maintaining the indexes.
-> Composite indexes provide the best performance for queries, but they introduce higher overhead for write operations,
as they need to be updated whenever the indexed columns change.

*/