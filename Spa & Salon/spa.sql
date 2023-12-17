SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE `stylists` (
  `sid` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `stylist_name` varchar(50) NOT NULL,
  `service_offered` varchar(100) NOT NULL,
  INDEX idx_stylists_email (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `stylists` (`sid`, `email`, `stylist_name`, `service_offered`) VALUES
(1, 'spa1@gmail.com', 'Provider1', 'Massage Therapy'),
(2, 'spa2@gmail.com', 'Provider2', 'Facial Treatment'),
(3, 'salon1@gmail.com', 'Stylist1', 'Haircut'),
(4, 'salon2@gmail.com', 'Stylist2', 'Nail Art');

CREATE TABLE `customers` (
  `cid` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `slot` varchar(50) NOT NULL,
  `service` varchar(100) NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL,
  `department` varchar(50) NOT NULL,
  `number` varchar(12) NOT NULL,
  INDEX idx_customers_email (`email`),
  INDEX idx_customers_name (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Adding indexes on email and name columns


INSERT INTO `customers` (`cid`, `email`, `name`, `gender`, `slot`, `service`, `time`, `date`, `department`, `number`) VALUES
(2, 'customer1@gmail.com', 'Customer1', 'Male', 'evening', 'Massage Therapy', '21:20:00', '2020-02-02', 'Spa', '9874561110'),
(5, 'customer@gmail.com', 'Customer', 'Male', 'morning', 'Facial Treatment', '18:06:00', '2020-11-18', 'Spa', '9874563210'),
(7, 'customer@gmail.com', 'Customer', 'Male', 'evening', 'Haircut', '22:18:00', '2020-11-05', 'Salon', '9874563210'),
(8, 'customer@gmail.com', 'Customer', 'Male', 'evening', 'Haircut', '22:18:00', '2020-11-05', 'Salon', '9874563210'),
(9, 'customer2@gmail.com', 'Customer2', 'Male', 'morning', 'Massage Therapy', '17:27:00', '2020-11-26', 'Spa', '9874563210'),
(10, 'customer@gmail.com', 'Customer', 'Male', 'evening', 'Facial Treatment', '16:25:00', '2020-12-09', 'Spa', '9874589654'),
(15, 'customer3@gmail.com', 'Customer3', 'Female', 'morning', 'Nail Art', '20:42:00', '2021-01-23', 'Salon', '9874563210'),
(16, 'customer3@gmail.com', 'Customer3', 'Female', 'evening', 'Facial Treatment', '15:46:00', '2021-01-31', 'Spa', '9874587496'),
(17, 'customer2@gmail.com', 'Customer2', 'Female', 'evening', 'Facial Treatment', '15:48:00', '2021-01-23', 'Spa', '9874563210');

DELIMITER $$
CREATE TRIGGER `CustomerDelete` BEFORE DELETE ON `customers` FOR EACH ROW INSERT INTO trigr VALUES(null,OLD.cid,OLD.email,OLD.name,'CUSTOMER DELETED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `CustomerUpdate` AFTER UPDATE ON `customers` FOR EACH ROW INSERT INTO trigr VALUES(null,NEW.cid,NEW.email,NEW.name,'CUSTOMER UPDATED',NOW())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `customerinsertion` AFTER INSERT ON `customers` FOR EACH ROW INSERT INTO trigr VALUES(null,NEW.cid,NEW.email,NEW.name,'CUSTOMER INSERTED',NOW())
$$
DELIMITER ;

CREATE TABLE `test` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `email` varchar(20) NOT NULL,
  INDEX idx_test_email (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Adding index on email column
 


INSERT INTO `test` (`id`, `name`, `email`) VALUES
(1, 'ANEES', 'ARK@GMAIL.COM'),
(2, 'test', 'test@gmail.com');

CREATE TABLE `trigr` (
  `tid` int(11) NOT NULL,
  `cid` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` datetime NOT NULL,
  INDEX idx_trigr_cid (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

 -- Adding index on cid column



INSERT INTO `trigr` (`tid`, `cid`, `email`, `name`, `action`, `timestamp`) VALUES
(1, 12, 'anees@gmail.com', 'ANEES', 'CUSTOMER INSERTED', '2020-12-02 16:35:10'),
(2, 11, 'anees@gmail.com', 'anees', 'CUSTOMER INSERTED', '2020-12-02 16:37:34'),
(3, 10, 'anees@gmail.com', 'anees', 'CUSTOMER UPDATED', '2020-12-02 16:38:27'),
(4, 11, 'anees@gmail.com', 'anees', 'CUSTOMER UPDATED', '2020-12-02 16:38:33'),
(5, 12, 'anees@gmail.com', 'ANEES', 'Customer Deleted', '2020-12-02 16:40:40'),
(6, 11, 'anees@gmail.com', 'anees', 'CUSTOMER DELETED', '2020-12-02 16:41:10'),
(7, 13, 'testing@gmail.com', 'testing', 'CUSTOMER INSERTED', '2020-12-02 16:50:21'),
(8, 13, 'testing@gmail.com', 'testing', 'CUSTOMER UPDATED', '2020-12-02 16:50:32'),
(9, 13, 'testing@gmail.com', 'testing', 'CUSTOMER DELETED', '2020-12-02 16:50:57'),
(10, 14, 'aneeqah@gmail.com', 'aneeqah', 'CUSTOMER INSERTED', '2021-01-22 15:18:09'),
(11, 14, 'aneeqah@gmail.com', 'aneeqah', 'CUSTOMER UPDATED', '2021-01-22 15:18:29'),
(12, 14, 'aneeqah@gmail.com', 'aneeqah', 'CUSTOMER DELETED', '2021-01-22 15:41:48'),
(13, 15, 'khushi@gmail.com', 'khushi', 'CUSTOMER INSERTED', '2021-01-22 15:43:02'),
(14, 15, 'khushi@gmail.com', 'khushi', 'CUSTOMER UPDATED', '2021-01-22 15:43:11'),
(15, 16, 'khushi@gmail.com', 'khushi', 'CUSTOMER INSERTED', '2021-01-22 15:43:37'),
(16, 16, 'khushi@gmail.com', 'khushi', 'CUSTOMER UPDATED', '2021-01-22 15:43:49'),
(17, 17, 'aneeqah@gmail.com', 'aneeqah', 'CUSTOMER INSERTED', '2021-01-22 15:44:41'),
(18, 17, 'aneeqah@gmail.com', 'aneeqah', 'CUSTOMER UPDATED', '2021-01-22 15:44:52'),
(19, 17, 'aneeqah@gmail.com', 'aneeqah', 'CUSTOMER UPDATED', '2021-01-22 15:44:59');

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `usertype` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(1000) NOT NULL,
  INDEX idx_user_email (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `services_list` (
  `service_id` int(11) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert some example services
INSERT INTO `services_list` (`service_id`, `service_name`) VALUES
(1, 'Massage Therapy'),
(2, 'Facial Treatment'),
(3, 'Haircut'),
(4, 'Nail Art');

UPDATE `stylists` s
JOIN `services_list` sv ON s.`service_offered` = sv.`service_name`
SET s.`service_id` = sv.`service_id`;

UPDATE `customers` c
JOIN `services_list` sv ON c.`service` = sv.`service_name`
SET c.`service_id` = sv.`service_id`;

------------------------------------------------------- HASHING -------------------------------------------
------------------Password hashing is essential to protect user passwords in case of a data breach.--------
-------------------However, for other non-sensitive information, hashing is typically not applied----------

INSERT INTO `user` (`id`, `username`, `usertype`, `email`, `password`) VALUES
(13, 'anees', 'Stylist', 'anees@gmail.com', 'pbkdf2:sha256:150000$xAKZCiJG$4c7a7e704708f86659d730565ff92e8327b01be5c49a6b1ef8afdf1c531fa5c3'),
(14, 'aneeqah', 'Customer', 'aneeqah@gmail.com', 'pbkdf2:sha256:150000$Yf51ilDC$028cff81a536ed9d477f9e45efcd9e53a9717d0ab5171d75334c397716d581b8'),
(15, 'khushi', 'Customer', 'khushi@gmail.com', 'pbkdf2:sha256:150000$BeSHeRKV$a8b27379ce9b2499d4caef21d9d387260b3e4ba9f7311168b6e180a00db91f22');


----------------------------------------------------- PRIMARY KEYS ---------------------------------------------

ALTER TABLE `stylists`
  ADD PRIMARY KEY (`sid`);

ALTER TABLE `customers`
  ADD PRIMARY KEY (`cid`);

ALTER TABLE `test`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `trigr`
  ADD PRIMARY KEY (`tid`);

ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `stylists`
  MODIFY `sid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

ALTER TABLE `customers`
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

ALTER TABLE `test`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

ALTER TABLE `trigr`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

  ----------------------------------------------- FOREIGN KEYS ----------------------------------------------------
-------------------foreign key relationships will enforce referential integrity between the tables--------------------
ALTER TABLE `stylists`
  ADD CONSTRAINT `fk_stylist_user_email`
  FOREIGN KEY (`email`) 
  REFERENCES `user` (`email`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `customers`
  ADD CONSTRAINT `fk_customer_user_email`
  FOREIGN KEY (`email`) 
  REFERENCES `user` (`email`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `trigr`
  ADD CONSTRAINT `fk_trigr_customers_cid`
  FOREIGN KEY (`cid`) 
  REFERENCES `customers` (`cid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `test`
  ADD CONSTRAINT `fk_test_user_email`
  FOREIGN KEY (`email`) 
  REFERENCES `user` (`email`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `stylists`
  ADD COLUMN `service_id` int(11) NOT NULL,
  ADD CONSTRAINT `fk_stylist_service`
  FOREIGN KEY (`service_id`) 
  REFERENCES `services_list` (`service_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `customers`
  ADD COLUMN `service_id` int(11) NOT NULL,
  ADD CONSTRAINT `fk_customer_service`
  FOREIGN KEY (`service_id`) 
  REFERENCES `services-list` (`service_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

