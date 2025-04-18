-- MySQL Script generated by MySQL Workbench
-- Sun Mar 30 07:53:33 2025
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema library
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `library` ;

-- -----------------------------------------------------
-- Schema library
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `library` DEFAULT CHARACTER SET utf8 ;
USE `library` ;

-- -----------------------------------------------------
-- Table `library`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`city` ;

CREATE TABLE IF NOT EXISTS `library`.`city` (
                                                `id_city` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                `name` VARCHAR(45) NOT NULL,
                                                PRIMARY KEY (`id_city`),
                                                UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`address` ;

CREATE TABLE IF NOT EXISTS `library`.`address` (
                                                   `id_address` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                   `street_name` VARCHAR(45) NOT NULL,
                                                   `house_number` VARCHAR(10) NOT NULL,
                                                   `FK_city` INT UNSIGNED NOT NULL,
                                                   PRIMARY KEY (`id_address`),
                                                   INDEX `fk_address_city1_idx` (`FK_city` ASC) VISIBLE,
                                                   CONSTRAINT `fk_address_city1`
                                                       FOREIGN KEY (`FK_city`)
                                                           REFERENCES `library`.`city` (`id_city`)
                                                           ON DELETE NO ACTION
                                                           ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`member`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`member` ;

CREATE TABLE IF NOT EXISTS `library`.`member` (
                                                  `id_member` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                  `name` VARCHAR(45) NOT NULL,
                                                  `surname` VARCHAR(45) NOT NULL,
                                                  `phone_number` VARCHAR(15) NOT NULL,
                                                  `email_address` VARCHAR(45) NOT NULL,
                                                  `birth_date` DATE NOT NULL,
                                                  `FK_address` INT UNSIGNED NOT NULL,
                                                  PRIMARY KEY (`id_member`),
                                                  UNIQUE INDEX `phone_number_UNIQUE` (`phone_number` ASC) VISIBLE,
                                                  UNIQUE INDEX `email_address_UNIQUE` (`email_address` ASC) VISIBLE,
                                                  INDEX `fk_member_address1_idx` (`FK_address` ASC) VISIBLE,
                                                  CONSTRAINT `fk_member_address1`
                                                      FOREIGN KEY (`FK_address`)
                                                          REFERENCES `library`.`address` (`id_address`)
                                                          ON DELETE NO ACTION
                                                          ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`genre` ;

CREATE TABLE IF NOT EXISTS `library`.`genre` (
                                                 `id_genre` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                 `name` VARCHAR(45) NOT NULL,
                                                 `description` TEXT NULL,
                                                 PRIMARY KEY (`id_genre`),
                                                 UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`book` ;

CREATE TABLE IF NOT EXISTS `library`.`book` (
                                                `id_book` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                `title` VARCHAR(100) NOT NULL,
                                                `publication_year` YEAR NOT NULL,
                                                `ISBN` VARCHAR(20) NOT NULL,
                                                `FK_genre` INT UNSIGNED NULL,
                                                PRIMARY KEY (`id_book`),
                                                UNIQUE INDEX `ISBN_UNIQUE` (`ISBN` ASC) VISIBLE,
                                                INDEX `fk_book_genre1_idx` (`FK_genre` ASC) VISIBLE,
                                                CONSTRAINT `fk_book_genre1`
                                                    FOREIGN KEY (`FK_genre`)
                                                        REFERENCES `library`.`genre` (`id_genre`)
                                                        ON DELETE NO ACTION
                                                        ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`reservation` ;

CREATE TABLE IF NOT EXISTS `library`.`reservation` (
                                                       `id_reservation` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                       `reservation_date` DATE NOT NULL,
                                                       `due_date` DATE NOT NULL,
                                                       `return_date` DATE NULL,
                                                       `status` ENUM('borrowed', 'returned') NOT NULL DEFAULT 'borrowed',
                                                       `FK_member` INT UNSIGNED NOT NULL,
                                                       `FK_book` INT UNSIGNED NOT NULL,
                                                       PRIMARY KEY (`id_reservation`),
                                                       INDEX `fk_reservation_member_idx` (`FK_member` ASC) VISIBLE,
                                                       INDEX `fk_reservation_book1_idx` (`FK_book` ASC) VISIBLE,
                                                       CONSTRAINT `fk_reservation_member`
                                                           FOREIGN KEY (`FK_member`)
                                                               REFERENCES `library`.`member` (`id_member`)
                                                               ON DELETE NO ACTION
                                                               ON UPDATE NO ACTION,
                                                       CONSTRAINT `fk_reservation_book1`
                                                           FOREIGN KEY (`FK_book`)
                                                               REFERENCES `library`.`book` (`id_book`)
                                                               ON DELETE NO ACTION
                                                               ON UPDATE NO ACTION,
                                                       CONSTRAINT `chk_reservation_dates`
                                                               CHECK (reservation_date <= due_date))
    ENGINE = InnoDB;


DELIMITER $$

DROP TRIGGER IF EXISTS after_return_update;

CREATE TRIGGER after_return_update
    AFTER UPDATE ON `reservation`
    FOR EACH ROW
BEGIN
    IF NEW.return_date IS NOT NULL AND OLD.return_date IS NULL THEN
        UPDATE `reservation`
        SET status = 'returned'
        WHERE id_reservation = NEW.id_reservation;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- Table `library`.`nationality`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`nationality` ;

CREATE TABLE IF NOT EXISTS `library`.`nationality` (
                                                       `id_nationality` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                       `name` VARCHAR(45) NOT NULL,
                                                       PRIMARY KEY (`id_nationality`),
                                                       UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`author` ;

CREATE TABLE IF NOT EXISTS `library`.`author` (
                                                  `id_author` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                  `name` VARCHAR(45) NOT NULL,
                                                  `surname` VARCHAR(45) NOT NULL,
                                                  `birth_date` DATE NOT NULL,
                                                  `FK_nationality` INT UNSIGNED NOT NULL,
                                                  PRIMARY KEY (`id_author`),
                                                  INDEX `fk_author_nationality_idx` (`FK_nationality` ASC) VISIBLE,
                                                  CONSTRAINT `fk_author_nationality`
                                                      FOREIGN KEY (`FK_nationality`)
                                                          REFERENCES `library`.`nationality` (`id_nationality`)
                                                          ON DELETE NO ACTION
                                                          ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`membership`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`membership` ;

CREATE TABLE IF NOT EXISTS `library`.`membership` (
                                                      `id_membership` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                      `date_from` DATE NOT NULL,
                                                      `date_to` DATE NOT NULL,
                                                      `FK_member` INT UNSIGNED NOT NULL,
                                                      PRIMARY KEY (`id_membership`),
                                                      INDEX `fk_membership_member1_idx` (`FK_member` ASC) VISIBLE,
                                                      UNIQUE INDEX `FK_member_UNIQUE` (`FK_member` ASC) VISIBLE,
                                                      CONSTRAINT `chk_membership_dates`
                                                          CHECK (date_from < date_to),
                                                      CONSTRAINT `fk_membership_member1`
                                                          FOREIGN KEY (`FK_member`)
                                                              REFERENCES `library`.`member` (`id_member`)
                                                              ON DELETE NO ACTION
                                                              ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`book_author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library`.`book_author` ;

CREATE TABLE IF NOT EXISTS `library`.`book_author` (
                                                       `id_book_author` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                                       `FK_book` INT UNSIGNED NOT NULL,
                                                       `FK_author` INT UNSIGNED NOT NULL,
                                                       PRIMARY KEY (`id_book_author`),
                                                       INDEX `fk_book_author_book1_idx` (`FK_book` ASC) VISIBLE,
                                                       INDEX `fk_book_author_author1_idx` (`FK_author` ASC) VISIBLE,
                                                       CONSTRAINT `fk_book_author_book1`
                                                           FOREIGN KEY (`FK_book`)
                                                               REFERENCES `library`.`book` (`id_book`)
                                                               ON DELETE NO ACTION
                                                               ON UPDATE NO ACTION,
                                                       CONSTRAINT `fk_book_author_author1`
                                                           FOREIGN KEY (`FK_author`)
                                                               REFERENCES `library`.`author` (`id_author`)
                                                               ON DELETE NO ACTION
                                                               ON UPDATE NO ACTION)
    ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
