-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------Create Database---------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- To Create pizza_place_sales Database --
-- ------------------------------------ --
DROP DATABASE IF EXISTS `pizza_place_sales`;
CREATE DATABASE `pizza_place_sales`;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE `pizza_place_sales`;

-- -------------------------------------------------
-- Table Structure Of Orders Table
CREATE TABLE `orders` (
	`order_id` int (10) NOT NULL AUTO_INCREMENT,
    `date` date NOT NULL,
    `time` time NOT NULL,
    PRIMARY KEY (`order_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- -------------------------------------------------
-- To Import Data From CSV For Orders Table
LOAD DATA INFILE 'orders.csv'
INTO TABLE `orders`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Table Structure Of Pizza Types Table
CREATE TABLE `pizza_types` (
	`pizza_type_id` varchar (50) NOT NULL,
    `name` varchar (500) NOT NULL,
    `category` varchar (250) NOT NULL,
    `ingredients` text NOT NULL,
    PRIMARY KEY (`pizza_type_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- -------------------------------------------------
-- To Import Data From CSV For Pizza Types Table
LOAD DATA INFILE 'pizza_types.csv'
INTO TABLE `pizza_types`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Table Structure Of Pizzas Table
CREATE TABLE `pizzas` (
	`pizza_id` varchar (100) NOT NULL,
    `pizza_type_id` varchar (100) NOT NULL,
    `size` varchar (50) NOT NULL,
    `price` decimal (10,2),
    PRIMARY KEY (`pizza_id`),
    FOREIGN KEY (`pizza_type_id`) REFERENCES `pizza_types` (`pizza_type_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- -------------------------------------------------
-- To Import Data From CSV For Pizzas Table
LOAD DATA INFILE 'pizzas.csv'
INTO TABLE `pizzas`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Table Structure Of Order Details Table
CREATE TABLE `order_details` (
	`order_details_id` int (10) NOT NULL,
    `order_id` int (10) NOT NULL,
    `pizza_id` varchar (100) NOT NULL,
    `quantity` tinyint,
    PRIMARY KEY (`order_details_id`),
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
	FOREIGN KEY (`pizza_id`) REFERENCES `pizzas` (`pizza_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    -- -------------------------------------------------
-- To Import Data From CSV For Order Details
LOAD DATA INFILE 'order_details.csv'
INTO TABLE `order_details`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------Data Modelling---------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE `pizza_place_sales`;
SELECT 
	'order_id', 
    'order_details_id', 
    'date', 
    'monnth_name', 
    'month_name_order', 
    'day_name', 
    'day_name_order', 
    'time', 
    'sale_hour',
    'quantity', 
    'pizza_id', 
    'pizza_type_id', 
    'name', 
    'size', 
    'price',
    'revenue',
    'category', 
    'ingredients'
UNION ALL -- To include column name when export csv file
SELECT 
	o.`order_id`,
	od.`order_details_id`,
    o.`date`,
    MONTHNAME(o.`date`) AS `month_name`, -- To convert month name
    MONTH(o.`date`) AS `month_name_order`, -- To convert month number for visual order purposes
    UPPER(DATE_FORMAT(o.`date`, '%a')) AS `day_name`, -- To convert day name of the week
    WEEKDAY(o.`date`) AS `day_name_order`, -- To convert weekday number for visual order purposes
    o.`time`,
    TIME_FORMAT(o.`time`, '%h %p') AS `sale_hour`, -- To set the sale hour as AM/PM format
    od.`quantity`,
    p.`pizza_id`,
    pt.`pizza_type_id`,
    pt.`name`,
	CASE 
		WHEN size = 'XXL' THEN 'Double Extra Large'
        WHEN size = 'XL' THEN 'Extra Large'
        WHEN size = 'L' THEN 'Large'
        WHEN size = 'M' THEN 'Medium'
        WHEN size = 'S' THEN 'Small'
        ELSE size 
    END AS `size`, -- To convert abbreviation to normal format for pizza size
    p.`price`,
    SUM(od.`quantity` * p.`price`) AS `revenue`, -- To calculate revenue
    pt.`category`,
    pt.`ingredients`
FROM `order_details`od
LEFT JOIN `orders`o USING (`order_id`)
LEFT JOIN `pizzas`p USING (`pizza_id`)
LEFT JOIN `pizza_types`pt USING (`pizza_type_id`)
GROUP BY od.`order_details_id`


-- To export datasets as CSV file
-- --------------------------------------------------------

INTO OUTFILE 'pizza_place_sales.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY ','
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';