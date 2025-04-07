SET FOREIGN_KEY_CHECKS = 0;

USE `library`;

TRUNCATE TABLE `library`.`address`;
TRUNCATE TABLE `library`.`author`;
TRUNCATE TABLE `library`.`book`;
TRUNCATE TABLE `library`.`book_author`;
TRUNCATE TABLE `library`.`city`;
TRUNCATE TABLE `library`.`genre`;
TRUNCATE TABLE `library`.`member`;
TRUNCATE TABLE `library`.`membership`;
TRUNCATE TABLE `library`.`nationality`;
TRUNCATE TABLE `library`.`reservation`;

USE `library_denormalized`;

TRUNCATE TABLE `library_denormalized`.`address`;
TRUNCATE TABLE `library_denormalized`.`author`;
TRUNCATE TABLE `library_denormalized`.`book`;
TRUNCATE TABLE `library_denormalized`.`book_author`;
TRUNCATE TABLE `library_denormalized`.`city`;
TRUNCATE TABLE `library_denormalized`.`genre`;
TRUNCATE TABLE `library_denormalized`.`member`;
TRUNCATE TABLE `library_denormalized`.`nationality`;
TRUNCATE TABLE `library_denormalized`.`reservation`;

SET FOREIGN_KEY_CHECKS = 1;

USE `library`;

DROP TABLE IF EXISTS `library`.`result2`;
CREATE TABLE `library`.`result2` (
                          id_result INT PRIMARY KEY AUTO_INCREMENT,
                          scenario VARCHAR(30) NOT NULL,
                          records_number INT NOT NULL,
                          query_type VARCHAR(45) NOT NULL,
                          query_info TEXT NOT NULL,
                          query_time BIGINT NOT NULL
);

DROP PROCEDURE IF EXISTS TestQueriesPerformanceNormalized;

DELIMITER $$
CREATE PROCEDURE TestQueriesPerformanceNormalized(IN number_of_records INT, IN scenario VARCHAR(30))
BEGIN
    DECLARE query_type VARCHAR(45);
    DECLARE query_info TEXT;
    DECLARE execution_time BIGINT;

    CALL InsertCities(number_of_records);
    CALL InsertGenres(number_of_records);
    CALL InsertNationalities(number_of_records);
    CALL InsertAddresses(number_of_records);
    CALL InsertAuthors(number_of_records);
    CALL InsertBooks(number_of_records);
    CALL InsertBookAuthors(number_of_records);
    CALL InsertMembers(number_of_records);
    CALL InsertMemberships(number_of_records);
    CALL InsertReservations(number_of_records);


    SET query_type = 'SELECT-1:1';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SELECT surname, date_to FROM `member` JOIN `membership` ON id_member = FK_member WHERE name = 'Amelia';

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'SELECT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result2` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT-1:N';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SELECT title, publication_year, name FROM `book` JOIN `genre`ON id_genre = FK_genre
                                         WHERE publication_year = 2022;

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'SELECT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result2` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT-M:N';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SELECT title, surname, due_date FROM `reservation` JOIN `member` ON id_member = FK_member
        JOIN `book` ON id_book = FK_book WHERE status = 'returned';

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'SELECT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result2` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT-repeating groups';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SELECT title, FK_author FROM `book` JOIN `book_author` ON id_book = FK_book WHERE publication_year = 2021;

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'SELECT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `result2` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);

END $$


USE `library_denormalized`;

DROP TABLE IF EXISTS `library_denormalized`.`result2`;
CREATE TABLE `library_denormalized`.`result2` (
                           id_result INT PRIMARY KEY AUTO_INCREMENT,
                           scenario VARCHAR(30) NOT NULL,
                           records_number INT NOT NULL,
                           query_type VARCHAR(45) NOT NULL,
                           query_info TEXT NOT NULL,
                           query_time BIGINT NOT NULL
);

DROP PROCEDURE IF EXISTS TestQueriesPerformanceDenormalized;

DELIMITER $$
CREATE PROCEDURE TestQueriesPerformanceDenormalized(IN number_of_records INT, IN scenario VARCHAR(30))
BEGIN
    DECLARE query_type VARCHAR(45);
    DECLARE query_info TEXT;
    DECLARE execution_time BIGINT;

    CALL InsertCities(number_of_records);
    CALL InsertGenres(number_of_records);
    CALL InsertNationalities(number_of_records);
    CALL InsertAddresses(number_of_records);
    CALL InsertAuthors(number_of_records);
    CALL InsertBooks(number_of_records);
    CALL InsertBookAuthors(number_of_records);
    CALL InsertMembers(number_of_records);
    CALL InsertReservations(number_of_records);


    SET query_type = 'SELECT-1:1';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SELECT surname, membership_date_to FROM `member` WHERE name = 'Amelia';

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'SELECT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `library_denormalized`.`result2` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT-1:N';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SELECT title, publication_year, genre_name FROM `book` WHERE publication_year = 2022;

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'SELECT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `library_denormalized`.`result2` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT-M:N';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SELECT book_title, member_surname, due_date FROM `reservation` WHERE status = 'returned';

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'SELECT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `library_denormalized`.`result2` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);


    SET query_type = 'SELECT-repeating groups';

    TRUNCATE TABLE performance_schema.events_statements_history;

    SELECT title, author_1_id, author_2_id, author_3_id FROM `book` WHERE publication_year = 2021;

    SELECT SQL_TEXT, TIMER_WAIT INTO query_info, execution_time
    FROM performance_schema.events_statements_history
    WHERE SQL_TEXT LIKE 'SELECT%'
    ORDER BY event_id DESC
    LIMIT 1;

    INSERT INTO `library_denormalized`.`result2` (scenario, records_number, query_type, query_info, query_time)
    VALUES (scenario, number_of_records, query_type, query_info, execution_time);

END $$

DELIMITER ;


SET @records_number_1k = 1000;
SET @records_number_10k = 10000;


USE `library`;
CALL TestQueriesPerformanceNormalized(@records_number_1k, 'Scenario 1.1');
USE `library_denormalized`;
CALL TestQueriesPerformanceDenormalized(@records_number_1k, 'Scenario 1.2');


SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `library`.`address`;
TRUNCATE TABLE `library`.`author`;
TRUNCATE TABLE `library`.`book`;
TRUNCATE TABLE `library`.`book_author`;
TRUNCATE TABLE `library`.`city`;
TRUNCATE TABLE `library`.`genre`;
TRUNCATE TABLE `library`.`member`;
TRUNCATE TABLE `library`.`membership`;
TRUNCATE TABLE `library`.`nationality`;
TRUNCATE TABLE `library`.`reservation`;

TRUNCATE TABLE `library_denormalized`.`address`;
TRUNCATE TABLE `library_denormalized`.`author`;
TRUNCATE TABLE `library_denormalized`.`book`;
TRUNCATE TABLE `library_denormalized`.`book_author`;
TRUNCATE TABLE `library_denormalized`.`city`;
TRUNCATE TABLE `library_denormalized`.`genre`;
TRUNCATE TABLE `library_denormalized`.`member`;
TRUNCATE TABLE `library_denormalized`.`nationality`;
TRUNCATE TABLE `library_denormalized`.`reservation`;

SET FOREIGN_KEY_CHECKS = 1;


USE `library`;
CALL TestQueriesPerformanceNormalized(@records_number_10k, 'Scenario 2.1');
USE `library_denormalized`;
CALL TestQueriesPerformanceDenormalized(@records_number_10k, 'Scenario 2.2');


/*
 The query execution times show clear differences between normalized and denormalized databases.
 The normalized database performs worse, particularly for complex queries that require multiple joins,
 while the denormalized database shows improved performance due to fewer joins and a flatter data structure.
 As the data volume increases, the gap in execution times becomes more noticeable, with denormalized structures
 handling large volumes more efficiently. This observation confirms that denormalization is suitable for performance
 optimization, but sacrifices data redundancy and consistency.
 */