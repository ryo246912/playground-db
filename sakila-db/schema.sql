-- Create "actor" table
CREATE TABLE `actor` (
  `actor_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`),
  INDEX `idx_actor_last_name` (`last_name`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "address" table
CREATE TABLE `address` (
  `address_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint unsigned NOT NULL,
  `postal_code` varchar(10) NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  INDEX `idx_fk_city_id` (`city_id`),
  SPATIAL INDEX `idx_location` (`location`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "category" table
CREATE TABLE `category` (
  `category_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "city" table
CREATE TABLE `city` (
  `city_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `city` varchar(50) NOT NULL,
  `country_id` smallint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`city_id`),
  INDEX `idx_fk_country_id` (`country_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "country" table
CREATE TABLE `country` (
  `country_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `country` varchar(50) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`country_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "customer" table
CREATE TABLE `customer` (
  `customer_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `store_id` tinyint unsigned NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `email` varchar(50) NULL,
  `address_id` smallint unsigned NOT NULL,
  `active` bool NOT NULL DEFAULT 1,
  `create_date` datetime NOT NULL,
  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  INDEX `idx_fk_address_id` (`address_id`),
  INDEX `idx_fk_store_id` (`store_id`),
  INDEX `idx_last_name` (`last_name`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "film" table
CREATE TABLE `film` (
  `film_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `description` text NULL,
  `release_year` year NULL,
  `language_id` tinyint unsigned NOT NULL,
  `original_language_id` tinyint unsigned NULL,
  `rental_duration` tinyint unsigned NOT NULL DEFAULT 3,
  `rental_rate` decimal(4,2) NOT NULL DEFAULT 4.99,
  `length` smallint unsigned NULL,
  `replacement_cost` decimal(5,2) NOT NULL DEFAULT 19.99,
  `rating` enum('G','PG','PG-13','R','NC-17') NULL DEFAULT "G",
  `special_features` set('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`film_id`),
  INDEX `idx_fk_language_id` (`language_id`),
  INDEX `idx_fk_original_language_id` (`original_language_id`),
  INDEX `idx_title` (`title`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "film_actor" table
CREATE TABLE `film_actor` (
  `actor_id` smallint unsigned NOT NULL,
  `film_id` smallint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`, `film_id`),
  INDEX `idx_fk_film_id` (`film_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "film_category" table
CREATE TABLE `film_category` (
  `film_id` smallint unsigned NOT NULL,
  `category_id` tinyint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`film_id`, `category_id`),
  INDEX `fk_film_category_category` (`category_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "film_text" table
CREATE TABLE `film_text` (
  `film_id` smallint unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NULL,
  PRIMARY KEY (`film_id`),
  FULLTEXT INDEX `idx_title_description` (`title`, `description`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "inventory" table
CREATE TABLE `inventory` (
  `inventory_id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `film_id` smallint unsigned NOT NULL,
  `store_id` tinyint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`),
  INDEX `idx_fk_film_id` (`film_id`),
  INDEX `idx_store_id_film_id` (`store_id`, `film_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- Create "language" table
CREATE TABLE `language` (
  `language_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` char(20) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`language_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT 6;
-- Create "payment" table
CREATE TABLE `payment` (
  `payment_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` smallint unsigned NOT NULL,
  `staff_id` tinyint unsigned NOT NULL,
  `rental_id` int NULL,
  `amount` decimal(5,2) NOT NULL,
  `payment_date` datetime NOT NULL,
  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  INDEX `fk_payment_rental` (`rental_id`),
  INDEX `idx_fk_customer_id` (`customer_id`),
  INDEX `idx_fk_staff_id` (`staff_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT 16049;
-- Create "rental" table
CREATE TABLE `rental` (
  `rental_id` int NOT NULL AUTO_INCREMENT,
  `rental_date` datetime NOT NULL,
  `inventory_id` mediumint unsigned NOT NULL,
  `customer_id` smallint unsigned NOT NULL,
  `return_date` datetime NULL,
  `staff_id` tinyint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rental_id`),
  INDEX `idx_fk_customer_id` (`customer_id`),
  INDEX `idx_fk_inventory_id` (`inventory_id`),
  INDEX `idx_fk_staff_id` (`staff_id`),
  UNIQUE INDEX `rental_date` (`rental_date`, `inventory_id`, `customer_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT 16049;
-- Create "staff" table
CREATE TABLE `staff` (
  `staff_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `address_id` smallint unsigned NOT NULL,
  `picture` blob NULL,
  `email` varchar(50) NULL,
  `store_id` tinyint unsigned NOT NULL,
  `active` bool NOT NULL DEFAULT 1,
  `username` varchar(16) NOT NULL,
  `password` varchar(40) NULL COLLATE utf8mb4_bin,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`staff_id`),
  INDEX `idx_fk_address_id` (`address_id`),
  INDEX `idx_fk_store_id` (`store_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT 2;
-- Create "store" table
CREATE TABLE `store` (
  `store_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `manager_staff_id` tinyint unsigned NOT NULL,
  `address_id` smallint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`store_id`),
  INDEX `idx_fk_address_id` (`address_id`),
  UNIQUE INDEX `idx_unique_manager` (`manager_staff_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci AUTO_INCREMENT 2;
-- Modify "address" table
ALTER TABLE `address` ADD CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "city" table
ALTER TABLE `city` ADD CONSTRAINT `fk_city_country` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "customer" table
ALTER TABLE `customer` ADD CONSTRAINT `fk_customer_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_customer_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "film" table
ALTER TABLE `film` ADD CONSTRAINT `fk_film_language` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_film_language_original` FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "film_actor" table
ALTER TABLE `film_actor` ADD CONSTRAINT `fk_film_actor_actor` FOREIGN KEY (`actor_id`) REFERENCES `actor` (`actor_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "film_category" table
ALTER TABLE `film_category` ADD CONSTRAINT `fk_film_category_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_film_category_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "inventory" table
ALTER TABLE `inventory` ADD CONSTRAINT `fk_inventory_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_inventory_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "payment" table
ALTER TABLE `payment` ADD CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_payment_rental` FOREIGN KEY (`rental_id`) REFERENCES `rental` (`rental_id`) ON UPDATE CASCADE ON DELETE SET NULL, ADD CONSTRAINT `fk_payment_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "rental" table
ALTER TABLE `rental` ADD CONSTRAINT `fk_rental_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_rental_inventory` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_rental_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "staff" table
ALTER TABLE `staff` ADD CONSTRAINT `fk_staff_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_staff_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
-- Modify "store" table
ALTER TABLE `store` ADD CONSTRAINT `fk_store_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON UPDATE CASCADE ON DELETE RESTRICT, ADD CONSTRAINT `fk_store_staff` FOREIGN KEY (`manager_staff_id`) REFERENCES `staff` (`staff_id`) ON UPDATE CASCADE ON DELETE RESTRICT;
