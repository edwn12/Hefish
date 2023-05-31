-- Valentina Studio --
-- MySQL dump --
-- ---------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- ---------------------------------------------------------


-- DROP DATABASE "hefish_1" --------------------------------
DROP DATABASE IF EXISTS `hefish_1`;
-- ---------------------------------------------------------


-- CREATE DATABASE "hefish_1" ------------------------------
CREATE DATABASE `hefish_1` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `hefish_1`;
-- ---------------------------------------------------------


-- CREATE TABLE "fish_types" -----------------------------------
CREATE TABLE `fish_types`( 
	`id` Int( 0 ) NOT NULL,
	`name` VarChar( 50 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
ENGINE = InnoDB;
-- -------------------------------------------------------------


-- CREATE TABLE "fishes" ---------------------------------------
CREATE TABLE `fishes`( 
	`id` Int( 0 ) NOT NULL,
	`user_id` Int( 0 ) NOT NULL,
	`fish_type_id` Int( 0 ) NOT NULL,
	`name` VarChar( 50 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
	`description` VarChar( 255 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
	`price` Int( 0 ) NOT NULL,
	`image_path` VarChar( 100 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
ENGINE = InnoDB;
-- -------------------------------------------------------------


-- CREATE TABLE "users" ----------------------------------------
CREATE TABLE `users`( 
	`id` Int( 0 ) NOT NULL,
	`email` VarChar( 50 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
	`username` VarChar( 50 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
	`password` VarChar( 20 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
	`token` Char( 10 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
ENGINE = InnoDB;
-- -------------------------------------------------------------


-- Dump data of "fish_types" -------------------------------
BEGIN;

INSERT INTO `fish_types`(`id`,`name`) VALUES 
( '1', 'Fresh' ),
( '2', 'Salt' ),
( '3', 'Mixed' );
COMMIT;
-- ---------------------------------------------------------


-- Dump data of "fishes" -----------------------------------
BEGIN;

INSERT INTO `fishes`(`id`,`user_id`,`fish_type_id`,`name`,`description`,`price`,`image_path`) VALUES 
( '1', '1', '1', 'Koi Chagoi', 'Koi Chagoi Description', '1200000', 'chagoi.jpg' ),
( '2', '1', '1', 'Koi Tancho', 'Koi Tancho Description', '3500000', 'tancho.jpg' ),
( '3', '1', '2', 'Channa Auranti', 'Channa Auranti Description', '250000', 'auranti.jpeg' ),
( '4', '1', '2', 'Channa Andrao', 'Channa Andrao Description', '300000', 'andrao.jpg' ),
( '5', '1', '1', 'Koi Shiro Utsuri', 'Koi Shiro Utsuri Description', '2000000', 'shiro_utsuri.jpeg' ),
( '6', '1', '3', 'Tiger Shovelnose', 'Catfish Tiger Shovelnose Description', '1250000', 'tiger.jpg' ),
( '7', '1', '3', 'Red Catfish', 'Red Catfish Description', '450000', 'redcatfish.jpeg' );
COMMIT;
-- ---------------------------------------------------------


-- Dump data of "users" ------------------------------------
BEGIN;

INSERT INTO `users`(`id`,`email`,`username`,`password`,`token`) VALUES 
( '1', 'adminhe@gmail.com', 'admin', 'Admin123', 'hfRQebrO6V' ),
( '2', 'user@gmail.com', 'user1', 'User123', 'MTvG38J4He' );
COMMIT;
-- ---------------------------------------------------------


-- CREATE INDEX "lnk_fish_types_fishes" ------------------------
CREATE INDEX `lnk_fish_types_fishes` USING BTREE ON `fishes`( `fish_type_id` );
-- -------------------------------------------------------------


-- CREATE INDEX "lnk_users_fishes" -----------------------------
CREATE INDEX `lnk_users_fishes` USING BTREE ON `fishes`( `user_id` );
-- -------------------------------------------------------------


-- CREATE LINK "lnk_fish_types_fishes" -------------------------
ALTER TABLE `fishes`
	ADD CONSTRAINT `lnk_fish_types_fishes` FOREIGN KEY ( `fish_type_id` )
	REFERENCES `fish_types`( `id` )
	ON DELETE Cascade
	ON UPDATE Cascade;
-- -------------------------------------------------------------


-- CREATE LINK "lnk_users_fishes" ------------------------------
ALTER TABLE `fishes`
	ADD CONSTRAINT `lnk_users_fishes` FOREIGN KEY ( `user_id` )
	REFERENCES `users`( `id` )
	ON DELETE Cascade
	ON UPDATE Cascade;
-- -------------------------------------------------------------


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- ---------------------------------------------------------


