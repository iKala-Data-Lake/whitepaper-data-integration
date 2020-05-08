-- MySQL dump 10.13  Distrib 8.0.19, for Linux (x86_64)
--
-- Host: localhost    Database: example
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP DATABASE IF EXISTS example;
CREATE DATABASE IF NOT EXISTS example;

USE example;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL,
  `total_item` int DEFAULT NULL,
  `shipping_fee` int DEFAULT NULL,
  `tax` float DEFAULT NULL,
  `total_cost` float DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `ship_name` varchar(250) DEFAULT NULL,
  `ship_address` varchar(250) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `delivery_status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1000,4,7,0.0925,50.02,'2018-10-17','2018-10-20','Anna Addison','1325 Candy Rd, San Francisco, CA 96123','ZW60001 ',1),(1001,5,8,0.06,62.45,'2018-10-15','2018-10-18','Carol Campbell','1931 Brown St, Gainesville, FL 85321','AB61001 ',0),(1002,7,10,0.087,40.33,'2018-10-14','2018-10-17','Julia Jones ','1622 Seaside St, Seattle, WA 32569 ','CD62001 ',1),(1003,9,20,0.0625,70.98,'2018-10-12','2018-10-15','Irene Everly ','1756 East Dr, Houston, TX 28562','KB63001 ',0),(1004,6,7,0.0625,30.45,'2018-10-16','2018-10-19','Rachel Rose','1465 River Dr, Boston, MA 43625 ','IK64001 ',1),(1005,5,8,0.0625,100.2,'2018-10-13','2018-10-16','Sophie Sutton','1896 West Dr, Portland, OR 65842','OP65001 ',0),(1006,3,5,0.1025,58.52,'2018-10-21','2018-10-24','Wendy West','1252 Vine St, Chicago, IL 73215','XH66001 ',1);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_has_products`
--

DROP TABLE IF EXISTS `orders_has_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_has_products` (
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `option_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orders_has_products_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `orders_has_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_has_products`
--

LOCK TABLES `orders_has_products` WRITE;
/*!40000 ALTER TABLE `orders_has_products` DISABLE KEYS */;
INSERT INTO `orders_has_products` VALUES (1000,1200,1201,2),(1000,1200,1202,1),(1000,1300,1301,3),(1000,1300,1302,2),(1001,1400,1401,1),(1001,1400,1402,1),(1001,1500,1501,2),(1001,1500,1502,3),(1002,1600,1601,2),(1002,1600,1602,1),(1002,1700,1701,1),(1002,1700,1702,3),(1003,1800,1801,1),(1003,1800,1802,2),(1003,1900,1901,1),(1003,1900,1902,2),(1004,2000,2001,2),(1004,2000,2002,3),(1004,2100,2101,1),(1004,2100,2102,3),(1004,2200,2201,2),(1004,2200,2202,3),(1005,2300,2301,1),(1005,2300,2302,1),(1005,2400,2401,3),(1006,2400,2402,2),(1006,2500,2501,3),(1006,2500,2502,1),(1006,2600,2601,2),(1006,2600,2602,1);
/*!40000 ALTER TABLE `orders_has_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_placed_user`
--

DROP TABLE IF EXISTS `orders_placed_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_placed_user` (
  `user_id` int DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  KEY `user_id` (`user_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `orders_placed_user_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `orders_placed_user_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_placed_user`
--

LOCK TABLES `orders_placed_user` WRITE;
/*!40000 ALTER TABLE `orders_placed_user` DISABLE KEYS */;
INSERT INTO `orders_placed_user` VALUES (100,1000),(101,1001),(102,1002),(103,1003),(104,1004),(105,1005),(106,1006);
/*!40000 ALTER TABLE `orders_placed_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `username` varchar(150) DEFAULT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `address` varchar(250) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `phone` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (100,'anna0','Anna Addison','1325 Candy Rd, San Francisco, CA 96123','anna.addison@yahoo.com','3841019535'),(101,'carol1','Carol Campbell','1931 Brown St, Gainesville, FL 85321','carol.campbell@aol.com ','2548952651'),(102,'julia2','Julia Jones','1622 Seaside St, Seattle, WA 32569','jolie.jones@msn.com','3651469235'),(103,'irene3','Irene Everly','1756 East Dr, Houston, TX 28562','irene.everly@gmail.com','9859423698'),(104,'rachel4','Rachel Rose','1465 River Dr, Boston, MA 43625','rachel.rose@hotmail.com','2945632543'),(105,'sophie5','Sophie Sutton','1896 West Dr, Portland, OR 65842','sophie.sutton@yahoo.com','5169525614'),(106,'wendy6','Wendy West','1252 Vine St, Chicago, IL 73215','wendy.west@gmail.com','6645936156');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-04-14 15:38:11
