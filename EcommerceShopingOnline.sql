-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: ecommerce
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `quantity` int NOT NULL,
  `total_price` decimal(38,2) DEFAULT NULL,
  `unit_price` decimal(38,2) DEFAULT NULL,
  `card_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKstjbkkh1eftd036p0v219glxw` (`product_id`),
  KEY `FKlrsi58tlat4nmj7opa2pjje0h` (`card_id`),
  CONSTRAINT `FK1re40cjegsfvw58xrkdp6bac6` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `FKlrsi58tlat4nmj7opa2pjje0h` FOREIGN KEY (`card_id`) REFERENCES `carts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `number_of_products` int DEFAULT NULL,
  `total_money` decimal(38,2) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK64t7ox312pqal3p7fg9o503c2` (`user_id`),
  CONSTRAINT `FKb5o626f86h46m4s7ms6ginnop` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'2024-12-13 14:43:32.773822','2024-12-19 09:50:48.842036','ƒêi·ªán tho·∫°i',_binary '\0'),(2,'2024-12-13 14:43:32.791593','2024-12-13 14:43:32.791593','Laptop',_binary ''),(3,'2024-12-18 21:58:55.000604','2024-12-18 21:59:01.182059','Computer',_binary '');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_us`
--

DROP TABLE IF EXISTS `contact_us`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_us` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `email_or_phone` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_us`
--

LOCK TABLES `contact_us` WRITE;
/*!40000 ALTER TABLE `contact_us` DISABLE KEYS */;
INSERT INTO `contact_us` VALUES (1,'2024-12-13 16:02:32.016766','2024-12-13 16:02:32.016766','ch·∫•t l∆∞·ª£ng t·ªët',NULL,'html'),(2,'2024-12-13 16:02:49.215461','2024-12-13 16:02:49.215461','ch∆∞a th·∫•y g·ª≠i h√†ng',NULL,'nguyen ha'),(4,'2024-12-14 16:15:24.354358','2024-12-14 16:15:24.354358','ƒë∆∞·ª£c r·ªìi','0865172698','duc duc');
/*!40000 ALTER TABLE `contact_us` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `discount_type` tinyint DEFAULT NULL,
  `discount_value` decimal(38,2) DEFAULT NULL,
  `end_date` varbinary(255) DEFAULT NULL,
  `max_discount` decimal(38,2) DEFAULT NULL,
  `min_order_value` decimal(38,2) DEFAULT NULL,
  `start_date` varbinary(255) DEFAULT NULL,
  `usage_limit` int NOT NULL,
  `used_count` int NOT NULL,
  `user_restriction` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount`
--

LOCK TABLES `discount` WRITE;
/*!40000 ALTER TABLE `discount` DISABLE KEYS */;
/*!40000 ALTER TABLE `discount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invalidated_token`
--

DROP TABLE IF EXISTS `invalidated_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invalidated_token` (
  `id` varchar(255) NOT NULL,
  `expiry_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invalidated_token`
--

LOCK TABLES `invalidated_token` WRITE;
/*!40000 ALTER TABLE `invalidated_token` DISABLE KEYS */;
INSERT INTO `invalidated_token` VALUES ('0dcb242b-fc54-48ed-ba9c-f490558173f3','2024-12-16 09:43:09.000000'),('868ee0e2-ab76-4f22-b3e6-353d87d147aa','2024-12-13 16:05:04.000000'),('9381dd95-fa6b-416a-b1bb-68fa75e3b2f0','2024-12-19 08:53:56.000000'),('a39955fe-ff98-49e9-91b6-386f75947e63','2024-12-19 09:00:41.000000'),('acc21077-79e4-48e4-8bf1-c69f2c0cca20','2024-12-15 09:41:20.000000'),('c0b33d04-3457-4989-8a8f-dfcfa317d7f8','2024-12-19 10:00:29.000000'),('c813b0b1-ed4c-41d9-b0ed-d829797b9325','2024-12-15 09:26:49.000000'),('db599d02-44f9-4935-8090-620c79d5a55c','2024-12-19 09:53:35.000000'),('e65039cc-e07a-4c37-8a48-102e9be92334','2024-12-13 15:53:40.000000');
/*!40000 ALTER TABLE `invalidated_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `order_id` binary(16) NOT NULL,
  `product_id` bigint NOT NULL,
  `price` decimal(38,2) NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`order_id`,`product_id`),
  KEY `FK4q98utpd73imf4yhttm3w0eax` (`product_id`),
  CONSTRAINT `FK4q98utpd73imf4yhttm3w0eax` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `FKjyu2qbqt8gnvno9oe9j2s2ldk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (_binary '¥ﬂ∏>\…Jxò2\ÁêS)˜5',2,3102585.00,1),(_binary 'íQh!§K°ïfÅå–®©ë',1,2528891.00,1),(_binary 'Ú≠&¿íF∆áYå\”]',1,2528891.00,1),(_binary 'jã¨8∫Oã¢Ç~Òa\Z˘',2,3102585.00,2),(_binary 'jã¨8∫Oã¢Ç~Òa\Z˘',3,1943772.00,1),(_binary 'jã¨8∫Oã¢Ç~Òa\Z˘',4,3718878.00,1),(_binary '\ZiE\‚T´CùØëzYâ\Î',2,3102585.00,1),(_binary ' \Áj§¢ãH»áw\€\„\Ÿi\ÿ\€',1,2528891.00,1),(_binary '4\0∂0ﬂíDä˜¥\"ãâl',1,2528891.00,1),(_binary '=¿Øp£+M{â`\"\'2\Î5',7,1482326.00,4),(_binary 'BA7gGA\'ù˝Ü\Ÿàé',2,3102585.00,1),(_binary 'Cü;O`C\Èì\Zx\‡W¡\À',1,2528891.00,1),(_binary 'J(\‰üSºG∞πYp\‚Ù\‡≠Ú',1,2528891.00,1),(_binary 'R\√#LIQÜ\·A\…M\'',3,1943772.00,2),(_binary 'r	)>û\nIß´©\0æﬁøÙ≥',1,2528891.00,1),(_binary '}ù9\∆#PN±™ÚødøˆŸ¶',3,1943772.00,1),(_binary 'Ö¶…¨)7HŸ¢`˜z,•g\”',1,2528891.00,1),(_binary 'ê?~ Ç\ÔJˆë?\‹g#π\rM',8,2002750.00,1),(_binary 'ôã≥˘∫qLe≠îƒºà†\ÿ/',2,3102585.00,1),(_binary 'ôã≥˘∫qLe≠îƒºà†\ÿ/',3,1943772.00,1),(_binary 'ôã≥˘∫qLe≠îƒºà†\ÿ/',4,3718878.00,1),(_binary 'õ|≠LH?AäÄIˆW#\’o',20,1080380.00,1),(_binary 'úﬂ†\0≥Kò∏ù6 èLˇ_',2,3102585.00,1),(_binary 'úﬂ†\0≥Kò∏ù6 èLˇ_',3,1943772.00,2),(_binary 'û3¿S¢´H|±óÖ∫oÇG¡',2,3102585.00,4),(_binary 'ß±îXW\’C“ê\‰¨í\√',2,3102585.00,1),(_binary '™∞oÇ|N¯æΩˆ¯õDy',1,2528891.00,1),(_binary '±â;\‘îNﬁã]nπ-',3,1943772.00,1),(_binary '\ƒ\÷ \◊x£A	è\\[π\Ó‹µ',3,1943772.00,1),(_binary '\‘˜Y‹âKëØΩh∞zçˆ',2,3102585.00,1),(_binary '’øN\Ôn@Í•ñe\Îÿ∫7ó',2,3102585.00,1),(_binary '\·\Ÿ\Î•\„{M∑ç\n5U&Ò\Œ',2,3102585.00,1),(_binary '\·\Ÿ\Î•\„{M∑ç\n5U&Ò\Œ',3,1943772.00,1),(_binary '\„^ïë±ôD\"ßm˝˝Ö>L',1,2528891.00,1),(_binary '\Â2ﬁ∑\ŒA∞•ˆ\ÎË≥øg',1,2528891.00,1),(_binary 'Óåìû\Õ\‰A‹ß|õOöI\Ÿ',2,3102585.00,1),(_binary 'ˆÑK\ Ú\’J ∫√ßÚı¸\∆',2,3102585.00,2),(_binary '¸ï\√>Ñ^@ñû´éê\…\Œ%',1,2528891.00,1);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_discount`
--

DROP TABLE IF EXISTS `order_discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_discount` (
  `discount_amount` decimal(38,2) DEFAULT NULL,
  `discount_id` bigint NOT NULL,
  `order_id` binary(16) DEFAULT NULL,
  PRIMARY KEY (`discount_id`),
  KEY `FKuavxqbi3h98bdxxwgm4cw51y` (`order_id`),
  CONSTRAINT `FKc8k78pwub3wbsnsgb0ccqdrw8` FOREIGN KEY (`discount_id`) REFERENCES `discount` (`id`),
  CONSTRAINT `FKuavxqbi3h98bdxxwgm4cw51y` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_discount`
--

LOCK TABLES `order_discount` WRITE;
/*!40000 ALTER TABLE `order_discount` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_discount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` binary(16) NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `buyer_email` varchar(100) DEFAULT NULL,
  `note` varchar(100) DEFAULT NULL,
  `order_date` datetime(6) DEFAULT NULL,
  `receiver_full_name` varchar(100) DEFAULT NULL,
  `receiver_phone_number` varchar(100) NOT NULL,
  `shipping_address` varchar(255) DEFAULT NULL,
  `shipping_date` date DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `tracking_number` varchar(255) DEFAULT NULL,
  `discount_id` bigint DEFAULT NULL,
  `shipment_id` int DEFAULT NULL,
  `user_place_order_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKamtusgufffs4hfdactxb5wdu2` (`discount_id`),
  KEY `FK999el1skih1flvmhtej496ouh` (`shipment_id`),
  KEY `FKoh4wi4xvv4m89n7va7wxkgpdx` (`user_place_order_id`),
  CONSTRAINT `FK999el1skih1flvmhtej496ouh` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`),
  CONSTRAINT `FKh2ovofcsgndl8cvlmjq48vv9f` FOREIGN KEY (`discount_id`) REFERENCES `order_discount` (`discount_id`),
  CONSTRAINT `FKoh4wi4xvv4m89n7va7wxkgpdx` FOREIGN KEY (`user_place_order_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (_binary '¥ﬂ∏>\…Jxò2\ÁêS)˜5',_binary '','ducyhoo543@gmail.com',NULL,'2024-12-16 16:19:24.954243','Duy ƒê·ª©c','ducyhoo543@gmail.com','45fdgfdg, gdfgdf, 565 dfdsufsd','2024-12-19','pending',NULL,NULL,2,5),(_binary 'íQh!§K°ïfÅå–®©ë',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 16:05:38.507338','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-19','pending',NULL,NULL,2,2),(_binary 'Ú≠&¿íF∆áYå\”]',_binary '','ducyhoo543@gmail.com',NULL,'2024-12-16 16:18:53.055667','Duy ƒê·ª©c','ducyhoo543@gmail.com','45fdgfdg, gdfgdf, 565 dfdsufsd','2024-12-19','pending',NULL,NULL,2,5),(_binary 'jã¨8∫Oã¢Ç~Òa\Z˘',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-13 21:28:09.678898','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-16','pending',NULL,NULL,2,2),(_binary '\ZiE\‚T´CùØëzYâ\Î',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 16:27:16.792001','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-19','pending',NULL,NULL,2,2),(_binary ' \Áj§¢ãH»áw\€\„\Ÿi\ÿ\€',_binary '','ducyhoo543@gmail.com',NULL,'2024-12-16 16:09:38.427273','Duy ƒê·ª©c','ducyhoo543@gmail.com','45fdgfdg, gdfgdf, 565 dfdsufsd','2024-12-19','pending',NULL,NULL,2,5),(_binary '4\0∂0ﬂíDä˜¥\"ãâl',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-13 15:41:47.563787','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-15','pending',NULL,NULL,3,2),(_binary '=¿Øp£+M{â`\"\'2\Î5',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 08:16:19.852537','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-20','pending',NULL,NULL,1,2),(_binary 'BA7gGA\'ù˝Ü\Ÿàé',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-19 09:40:14.230887','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-22','delivered',NULL,NULL,2,2),(_binary 'Cü;O`C\Èì\Zx\‡W¡\À',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 08:06:18.422876','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-19','pending',NULL,NULL,2,2),(_binary 'J(\‰üSºG∞πYp\‚Ù\‡≠Ú',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-13 15:49:51.845231','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-16','cancelled',NULL,NULL,2,2),(_binary 'R\√#LIQÜ\·A\…M\'',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-15 22:52:08.616468','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-19','pending',NULL,NULL,1,2),(_binary 'T\»3\‰YHE[¥Rw3g Y',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 08:01:03.801924','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-18','cancelled',NULL,NULL,3,2),(_binary 'r	)>û\nIß´©\0æﬁøÙ≥',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-13 15:37:56.907532','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-16','processing',NULL,NULL,2,2),(_binary '}ù9\∆#PN±™ÚødøˆŸ¶',_binary '','duc0004867@huce.edu.vn',NULL,'2024-07-16 16:04:50.684007','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-19','delivered',NULL,NULL,2,2),(_binary 'Ö¶…¨)7HŸ¢`˜z,•g\”',_binary '','duc0004867@huce.edu.vn',NULL,'2024-07-16 15:22:07.150000','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-20','delivered',NULL,NULL,1,2),(_binary 'ê?~ Ç\ÔJˆë?\‹g#π\rM',_binary '','duc0004867@huce.edu.vn',NULL,'2024-07-13 15:36:42.003000','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-16','delivered',NULL,NULL,2,2),(_binary 'ôã≥˘∫qLe≠îƒºà†\ÿ/',_binary '','duc0004867@huce.edu.vn',NULL,'2024-07-13 15:38:16.414000','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-16','delivered',NULL,NULL,2,2),(_binary 'õ|≠LH?AäÄIˆW#\’o',_binary '','duc0004867@huce.edu.vn',NULL,'2024-07-13 15:37:08.579000','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-15','delivered',NULL,NULL,3,2),(_binary 'úﬂ†\0≥Kò∏ù6 èLˇ_',_binary '','duc0004867@huce.edu.vn',NULL,'2024-07-17 10:02:15.717000','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-20','delivered',NULL,NULL,2,2),(_binary 'û3¿S¢´H|±óÖ∫oÇG¡',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-15 22:54:14.477839','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-18','delivered',NULL,NULL,2,2),(_binary 'ß±îXW\’C“ê\‰¨í\√',_binary '','ducyhoo543@gmail.com',NULL,'2024-12-16 16:20:34.003364','Duy ƒê·ª©c','ducyhoo543@gmail.com','45fdgfdg, gdfgdf, 565 dfdsufsd','2024-12-19','pending',NULL,NULL,2,5),(_binary '™∞oÇ|N¯æΩˆ¯õDy',_binary '','ducyhoo543@gmail.com',NULL,'2024-12-16 16:08:21.947603','Duy ƒê·ª©c','ducyhoo543@gmail.com','45fdgfdg, gdfgdf, 565 dfdsufsd','2024-12-19','pending',NULL,NULL,2,5),(_binary '±â;\‘îNﬁã]nπ-',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-13 15:25:35.209038','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-16','delivered',NULL,NULL,2,2),(_binary '\ƒ\÷ \◊x£A	è\\[π\Ó‹µ',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 07:58:54.584614','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-19','pending',NULL,NULL,2,2),(_binary '\‘˜Y‹âKëØΩh∞zçˆ',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-19 08:53:55.823123','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-22','delivered',NULL,NULL,2,2),(_binary '’øN\Ôn@Í•ñe\Îÿ∫7ó',_binary '','ducyhoo543@gmail.com',NULL,'2024-12-16 16:22:16.635068','Duy ƒê·ª©c','ducyhoo543@gmail.com','45fdgfdg, gdfgdf, 565 dfdsufsd','2024-12-19','pending',NULL,NULL,2,5),(_binary '\·\Ÿ\Î•\„{M∑ç\n5U&Ò\Œ',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-13 15:34:27.474822','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-16','delivered',NULL,NULL,2,2),(_binary '\„^ïë±ôD\"ßm˝˝Ö>L',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 07:56:16.814075','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-18','pending',NULL,NULL,3,2),(_binary '\Â2ﬁ∑\ŒA∞•ˆ\ÎË≥øg',_binary '','ducyhoo543@gmail.com',NULL,'2024-12-16 16:24:11.095147','Duy ƒê·ª©c','ducyhoo543@gmail.com','45fdgfdg, gdfgdf, 565 dfdsufsd','2024-12-19','pending',NULL,NULL,2,5),(_binary 'Óåìû\Õ\‰A‹ß|õOöI\Ÿ',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 16:27:04.180962','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-19','pending',NULL,NULL,2,2),(_binary 'ˆÑK\ Ú\’J ∫√ßÚı¸\∆',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-15 22:53:26.593417','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-18','pending',NULL,NULL,2,2),(_binary '¸ï\√>Ñ^@ñû´éê\…\Œ%',_binary '','duc0004867@huce.edu.vn',NULL,'2024-12-16 15:14:07.126261','ƒê√†o Duy ƒê·ª©c - 67IT2','duc0004867@huce.edu.vn','Th∆∞·ªùng T√≠n, H√† N·ªôi ','2024-12-18','pending',NULL,NULL,3,2);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_details`
--

DROP TABLE IF EXISTS `payment_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `amount` decimal(38,0) DEFAULT NULL,
  `paid` bit(1) NOT NULL,
  `provider` tinyint DEFAULT NULL,
  `order_id` binary(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKof2hvjrt3h42uja5aibie81tp` (`order_id`),
  CONSTRAINT `FK34yjcjptgtt05syk6x0t8s35b` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_details`
--

LOCK TABLES `payment_details` WRITE;
/*!40000 ALTER TABLE `payment_details` DISABLE KEYS */;
INSERT INTO `payment_details` VALUES (1,'2024-12-13 15:25:35.210043','2024-12-13 15:25:35.231046',1943792,_binary '\0',0,_binary '±â;\‘îNﬁã]nπ-'),(2,'2024-12-13 15:34:27.474822','2024-12-13 15:35:42.908940',5046377,_binary '',1,_binary '\·\Ÿ\Î•\„{M∑ç\n5U&Ò\Œ'),(3,'2024-12-13 15:36:42.003353','2024-12-13 15:36:42.009358',2002770,_binary '\0',0,_binary 'ê?~ Ç\ÔJˆë?\‹g#π\rM'),(4,'2024-12-13 15:37:08.579510','2024-12-13 15:37:08.585514',1080410,_binary '',0,_binary 'õ|≠LH?AäÄIˆW#\’o'),(5,'2024-12-13 15:37:56.907532','2024-12-13 15:37:56.913493',2528911,_binary '\0',0,_binary 'r	)>û\nIß´©\0æﬁøÙ≥'),(6,'2024-12-13 15:38:16.414733','2024-12-13 15:38:16.423731',8765255,_binary '\0',0,_binary 'ôã≥˘∫qLe≠îƒºà†\ÿ/'),(7,'2024-12-13 15:41:47.564794','2024-12-13 15:41:47.601731',2528921,_binary '\0',1,_binary '4\0∂0ﬂíDä˜¥\"ãâl'),(8,'2024-12-13 15:49:51.845231','2024-12-13 15:49:51.848242',2528911,_binary '\0',0,_binary 'J(\‰üSºG∞πYp\‚Ù\‡≠Ú'),(9,'2024-12-13 21:28:09.679976','2024-12-13 21:28:09.739134',11867840,_binary '\0',0,_binary 'jã¨8∫Oã¢Ç~Òa\Z˘'),(10,'2024-12-15 22:52:08.618977','2024-12-15 22:52:08.722560',3887554,_binary '\0',1,_binary 'R\√#LIQÜ\·A\…M\''),(11,'2024-12-15 22:53:26.593417','2024-12-15 22:53:26.597759',6205190,_binary '\0',1,_binary 'ˆÑK\ Ú\’J ∫√ßÚı¸\∆'),(12,'2024-12-15 22:54:14.477839','2024-12-15 22:55:41.187529',12410360,_binary '',1,_binary 'û3¿S¢´H|±óÖ∫oÇG¡'),(13,'2024-12-16 07:56:16.815800','2024-12-16 07:56:16.867883',2528921,_binary '\0',1,_binary '\„^ïë±ôD\"ßm˝˝Ö>L'),(14,'2024-12-16 07:58:54.584614','2024-12-16 07:58:54.590455',1943792,_binary '\0',1,_binary '\ƒ\÷ \◊x£A	è\\[π\Ó‹µ'),(15,'2024-12-16 08:01:03.801924','2024-12-16 08:01:03.805437',30,_binary '\0',1,_binary 'T\»3\‰YHE[¥Rw3g Y'),(16,'2024-12-16 08:06:18.422876','2024-12-16 08:07:09.089511',2528911,_binary '',1,_binary 'Cü;O`C\Èì\Zx\‡W¡\À'),(17,'2024-12-16 08:16:19.852537','2024-12-16 08:17:23.287397',5929314,_binary '',1,_binary '=¿Øp£+M{â`\"\'2\Î5'),(18,'2024-12-16 15:14:07.127260','2024-12-16 15:18:00.155481',2528921,_binary '',1,_binary '¸ï\√>Ñ^@ñû´éê\…\Œ%'),(19,'2024-12-16 15:22:07.150161','2024-12-16 15:22:07.165882',2538891,_binary '',1,_binary 'Ö¶…¨)7HŸ¢`˜z,•g\”'),(20,'2024-12-16 16:04:50.684007','2024-12-16 16:04:50.691200',1943792,_binary '',1,_binary '}ù9\∆#PN±™ÚødøˆŸ¶'),(21,'2024-12-16 16:05:38.507338','2024-12-16 16:05:38.511785',2528911,_binary '\0',1,_binary 'íQh!§K°ïfÅå–®©ë'),(22,'2024-12-16 16:08:21.947603','2024-12-16 16:08:21.963601',2528911,_binary '\0',1,_binary '™∞oÇ|N¯æΩˆ¯õDy'),(23,'2024-12-16 16:09:38.427273','2024-12-16 16:10:20.698248',2528911,_binary '',1,_binary ' \Áj§¢ãH»áw\€\„\Ÿi\ÿ\€'),(24,'2024-12-16 16:18:53.055667','2024-12-16 16:20:06.681608',2528911,_binary '',1,_binary 'Ú≠&¿íF∆áYå\”]'),(25,'2024-12-16 16:19:24.954243','2024-12-16 16:19:24.957241',3102605,_binary '\0',0,_binary '¥ﬂ∏>\…Jxò2\ÁêS)˜5'),(26,'2024-12-16 16:20:34.003364','2024-12-16 16:20:34.007288',3102605,_binary '\0',1,_binary 'ß±îXW\’C“ê\‰¨í\√'),(27,'2024-12-16 16:22:16.635068','2024-12-16 16:22:16.638063',3102605,_binary '\0',1,_binary '’øN\Ôn@Í•ñe\Îÿ∫7ó'),(28,'2024-12-16 16:24:11.095147','2024-12-16 16:24:11.099197',2528911,_binary '\0',1,_binary '\Â2ﬁ∑\ŒA∞•ˆ\ÎË≥øg'),(29,'2024-12-16 16:27:04.181960','2024-12-16 16:27:04.199305',3102605,_binary '',0,_binary 'Óåìû\Õ\‰A‹ß|õOöI\Ÿ'),(30,'2024-12-16 16:27:16.792001','2024-12-16 16:27:16.793999',3102605,_binary '\0',1,_binary '\ZiE\‚T´CùØëzYâ\Î'),(31,'2024-12-17 10:02:15.720002','2024-12-17 10:02:15.822602',7010129,_binary '\0',0,_binary 'úﬂ†\0≥Kò∏ù6 èLˇ_'),(32,'2024-12-19 08:53:55.828125','2024-12-19 08:54:55.767425',3122585,_binary '',1,_binary '\‘˜Y‹âKëØΩh∞zçˆ'),(33,'2024-12-19 09:40:14.230887','2024-12-19 09:46:35.269203',3122585,_binary '',1,_binary 'BA7gGA\'ù˝Ü\Ÿàé');
/*!40000 ALTER TABLE `payment_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_attribute_values`
--

DROP TABLE IF EXISTS `product_attribute_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_attribute_values` (
  `value_id` int NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  `product_id` bigint NOT NULL,
  `attribute_id` int NOT NULL,
  PRIMARY KEY (`value_id`),
  KEY `FK9cv255c78bptiixa9axev9act` (`product_id`),
  KEY `FK1oveqdcusmrm22vlr6m0u2hnn` (`attribute_id`),
  CONSTRAINT `FK1oveqdcusmrm22vlr6m0u2hnn` FOREIGN KEY (`attribute_id`) REFERENCES `product_attributes` (`attribute_id`),
  CONSTRAINT `FK9cv255c78bptiixa9axev9act` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=486 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_attribute_values`
--

LOCK TABLES `product_attribute_values` WRITE;
/*!40000 ALTER TABLE `product_attribute_values` DISABLE KEYS */;
INSERT INTO `product_attribute_values` VALUES (1,'0',1,1),(2,'143',1,2),(3,'OLED',1,4),(4,'Intel Core i5',1,3),(5,'7.3',1,5),(6,'120',1,6),(7,'4053',1,7),(8,'blue',1,8),(9,'Harum repellendus ut quaerat in blanditiis sunt.',1,9),(10,'IOS',1,10),(11,'Roob LLC',1,11),(12,'8',1,12),(13,'0',2,1),(14,'101',2,2),(15,'OLED',2,4),(16,'Apple M1',2,3),(17,'9.6',2,5),(18,'60',2,6),(19,'4665',2,7),(20,'maroon',2,8),(21,'Nihil possimus est.',2,9),(22,'IOS',2,10),(23,'Stark, Flatley and Ledner',2,11),(24,'3',2,12),(25,'7',3,1),(26,'192',3,2),(27,'IPS',3,4),(28,'Apple M1',3,3),(29,'5.4',3,5),(30,'120',3,6),(31,'4821',3,7),(32,'violet',3,8),(33,'Facilis nihil reprehenderit sed ea minima quasi similique.',3,9),(34,'Android',3,10),(35,'Okuneva and Sons',3,11),(36,'11',3,12),(37,'7',4,1),(38,'215',4,2),(39,'IPS',4,4),(40,'Intel Core i7',4,3),(41,'6.3',4,5),(42,'90',4,6),(43,'4336',4,7),(44,'maroon',4,8),(45,'Molestiae cum impedit nulla nihil dolore exercitationem consequuntur.',4,9),(46,'Android',4,10),(47,'Murphy Inc',4,11),(48,'6',4,12),(49,'0',5,1),(50,'78',5,2),(51,'OLED',5,4),(52,'Apple M1',5,3),(53,'9.0',5,5),(54,'120',5,6),(55,'4907',5,7),(56,'olive',5,8),(57,'Doloribus delectus sequi atque qui voluptatem voluptas autem.',5,9),(58,'Windows 11',5,10),(59,'Howell, Harvey and Hilll',5,11),(60,'4',5,12),(61,'5',6,1),(62,'86',6,2),(63,'OLED',6,4),(64,'Apple M1',6,3),(65,'7.7',6,5),(66,'90',6,6),(67,'4059',6,7),(68,'turquoise',6,8),(69,'Nesciunt rem non voluptas asperiores quia.',6,9),(70,'Android',6,10),(71,'Russel-Krajcik',6,11),(72,'5',6,12),(73,'13',7,13),(74,'477',7,14),(75,'AMD Ryzen 7',7,15),(76,'5.6',7,16),(77,'120',7,17),(78,'7289',7,18),(79,'silver',7,19),(80,'Eos facere eos.',7,20),(81,'Windows 11',7,21),(82,'Bayer-Mills',7,22),(83,'5',7,23),(84,'7',8,1),(85,'190',8,2),(86,'IPS',8,4),(87,'Intel Core i7',8,3),(88,'9.2',8,5),(89,'120',8,6),(90,'4103',8,7),(91,'green',8,8),(92,'Eos velit qui quia ut illo maxime aut.',8,9),(93,'Windows 10',8,10),(94,'Howell-Rodriguez',8,11),(95,'6',8,12),(96,'7',9,1),(97,'174',9,2),(98,'IPS',9,4),(99,'Intel Core i7',9,3),(100,'5.7',9,5),(101,'90',9,6),(102,'4881',9,7),(103,'yellow',9,8),(104,'Quisquam eaque sint et reiciendis.',9,9),(105,'IOS',9,10),(106,'Lebsack, Lehner and Prohaska',9,11),(107,'12',9,12),(108,'8',10,13),(109,'296',10,14),(110,'Apple M1',10,15),(111,'9.9',10,16),(112,'90',10,17),(113,'5014',10,18),(114,'blue',10,19),(115,'Soluta culpa quas ipsa ab.',10,20),(116,'Windows 11',10,21),(117,'Stracke LLC',10,22),(118,'1',10,23),(119,'2',11,13),(120,'305',11,14),(121,'AMD Ryzen 7',11,15),(122,'7.2',11,16),(123,'60',11,17),(124,'5921',11,18),(125,'red',11,19),(126,'Numquam provident est consequatur provident dolorem maiores nihil.',11,20),(127,'Windows 10',11,21),(128,'Beatty, Fritsch and Mante',11,22),(129,'2',11,23),(130,'4',12,1),(131,'6',12,2),(132,'IPS',12,4),(133,'Intel Core i5',12,3),(134,'8.4',12,5),(135,'120',12,6),(136,'4557',12,7),(137,'maroon',12,8),(138,'Excepturi sunt minus libero.',12,9),(139,'Android',12,10),(140,'Homenick, Murray and Pouros',12,11),(141,'2',12,12),(142,'7',13,1),(143,'141',13,2),(144,'IPS',13,4),(145,'Intel Core i7',13,3),(146,'8.5',13,5),(147,'120',13,6),(148,'4495',13,7),(149,'orange',13,8),(150,'Rerum commodi velit.',13,9),(151,'Windows 10',13,10),(152,'Stiedemann, Tromp and Bauch',13,11),(153,'3',13,12),(154,'3',14,1),(155,'0',14,2),(156,'OLED',14,4),(157,'Apple M1',14,3),(158,'9.6',14,5),(159,'90',14,6),(160,'4031',14,7),(161,'purple',14,8),(162,'Inventore dolorum qui sequi maxime iure.',14,9),(163,'Windows 11',14,10),(164,'Wyman-Stamm',14,11),(165,'2',14,12),(166,'14',15,13),(167,'506',15,14),(168,'Apple M1',15,15),(169,'7.3',15,16),(170,'60',15,17),(171,'7444',15,18),(172,'ivory',15,19),(173,'Impedit a molestiae laudantium voluptatem est fugiat.',15,20),(174,'Windows 11',15,21),(175,'Reichert-Heller',15,22),(176,'2',15,23),(177,'7',16,1),(178,'127',16,2),(179,'OLED',16,4),(180,'Intel Core i7',16,3),(181,'9.2',16,5),(182,'60',16,6),(183,'4604',16,7),(184,'silver',16,8),(185,'Maxime quia consequatur ratione incidunt.',16,9),(186,'Windows 10',16,10),(187,'Bins Inc',16,11),(188,'5',16,12),(189,'2',17,13),(190,'301',17,14),(191,'Apple M1',17,15),(192,'7.8',17,16),(193,'90',17,17),(194,'5400',17,18),(195,'black',17,19),(196,'Perspiciatis quidem molestias.',17,20),(197,'Android',17,21),(198,'Barton-Hayes',17,22),(199,'6',17,23),(200,'2',18,1),(201,'99',18,2),(202,'OLED',18,4),(203,'Intel Core i5',18,3),(204,'9.7',18,5),(205,'120',18,6),(206,'4471',18,7),(207,'fuchsia',18,8),(208,'Autem ex fugit eveniet consectetur magnam dolor ea.',18,9),(209,'Windows 10',18,10),(210,'Daniel-Littel',18,11),(211,'4',18,12),(212,'7',19,13),(213,'144',19,14),(214,'Apple M1',19,15),(215,'6.5',19,16),(216,'90',19,17),(217,'6691',19,18),(218,'blue',19,19),(219,'Qui deserunt quas.',19,20),(220,'Windows 10',19,21),(221,'Wunsch, Hagenes and Runolfsson',19,22),(222,'9',19,23),(223,'7',20,1),(224,'128',20,2),(225,'OLED',20,4),(226,'Intel Core i5',20,3),(227,'6.3',20,5),(228,'60',20,6),(229,'4997',20,7),(230,'silver',20,8),(231,'Sint est vero.',20,9),(232,'Windows 11',20,10),(233,'Shanahan and Sons',20,11),(234,'2',20,12),(235,'4',21,1),(236,'0',21,2),(237,'IPS',21,4),(238,'Apple M1',21,3),(239,'9.7',21,5),(240,'90',21,6),(241,'4771',21,7),(242,'salmon',21,8),(243,'Ut rerum quia deserunt libero et.',21,9),(244,'IOS',21,10),(245,'Hirthe Inc',21,11),(246,'2',21,12),(247,'5',22,1),(248,'97',22,2),(249,'IPS',22,4),(250,'Intel Core i7',22,3),(251,'7.0',22,5),(252,'120',22,6),(253,'4699',22,7),(254,'indigo',22,8),(255,'Minima dolorem recusandae non harum exercitationem ut.',22,9),(256,'Android',22,10),(257,'Hoeger-Hermiston',22,11),(258,'1',22,12),(259,'2',23,1),(260,'40',23,2),(261,'OLED',23,4),(262,'Intel Core i5',23,3),(263,'6.1',23,5),(264,'120',23,6),(265,'4958',23,7),(266,'black',23,8),(267,'Qui qui consequatur veritatis voluptate sed qui.',23,9),(268,'Android',23,10),(269,'Erdman and Sons',23,11),(270,'10',23,12),(271,'4',24,1),(272,'182',24,2),(273,'OLED',24,4),(274,'AMD Ryzen 7',24,3),(275,'5.0',24,5),(276,'120',24,6),(277,'4800',24,7),(278,'sky blue',24,8),(279,'Vel est neque sit consequatur enim beatae.',24,9),(280,'Windows 11',24,10),(281,'Johns-Brekke',24,11),(282,'5',24,12),(283,'15',25,13),(284,'358',25,14),(285,'Intel Core i5',25,15),(286,'6.3',25,16),(287,'60',25,17),(288,'7290',25,18),(289,'violet',25,19),(290,'Consequatur aut dolor autem nihil.',25,20),(291,'Windows 10',25,21),(292,'Gutkowski Inc',25,22),(293,'3',25,23),(294,'11',26,13),(295,'239',26,14),(296,'Apple M1',26,15),(297,'7.9',26,16),(298,'60',26,17),(299,'7616',26,18),(300,'ivory',26,19),(301,'Et ut natus voluptatum temporibus eligendi ea praesentium.',26,20),(302,'Windows 10',26,21),(303,'Rau and Sons',26,22),(304,'5',26,23),(305,'5',27,1),(306,'183',27,2),(307,'OLED',27,4),(308,'Intel Core i5',27,3),(309,'9.1',27,5),(310,'120',27,6),(311,'4128',27,7),(312,'blue',27,8),(313,'Repudiandae sit harum mollitia distinctio voluptas.',27,9),(314,'Android',27,10),(315,'Stehr-Tillman',27,11),(316,'2',27,12),(317,'3',28,1),(318,'244',28,2),(319,'OLED',28,4),(320,'Intel Core i7',28,3),(321,'7.2',28,5),(322,'120',28,6),(323,'4305',28,7),(324,'ivory',28,8),(325,'Soluta nostrum qui earum cupiditate quis consequatur ea.',28,9),(326,'IOS',28,10),(327,'Douglas-Davis',28,11),(328,'12',28,12),(329,'15',29,13),(330,'75',29,14),(331,'Intel Core i5',29,15),(332,'8.9',29,16),(333,'120',29,17),(334,'7203',29,18),(335,'olive',29,19),(336,'Cum esse magnam maxime et sunt eaque non.',29,20),(337,'Windows 10',29,21),(338,'Sawayn-Wolf',29,22),(339,'3',29,23),(340,'15',30,13),(341,'443',30,14),(342,'Apple M1',30,15),(343,'8.6',30,16),(344,'120',30,17),(345,'6882',30,18),(346,'ivory',30,19),(347,'Id doloribus error maiores reiciendis sint.',30,20),(348,'Windows 10',30,21),(349,'Upton-Cruickshank',30,22),(350,'6',30,23),(351,'0',31,13),(352,'392',31,14),(353,'Apple M1',31,15),(354,'9.1',31,16),(355,'60',31,17),(356,'7692',31,18),(357,'orchid',31,19),(358,'Quia nihil ut blanditiis aut officia.',31,20),(359,'Windows 10',31,21),(360,'Ankunding, McLaughlin and Ruecker',31,22),(361,'4',31,23),(362,'14',32,13),(363,'42',32,14),(364,'Intel Core i5',32,15),(365,'7.0',32,16),(366,'120',32,17),(367,'7428',32,18),(368,'gold',32,19),(369,'Ex iste quia aliquam quasi.',32,20),(370,'Android',32,21),(371,'Klein Inc',32,22),(372,'7',32,23),(373,'7',33,13),(374,'395',33,14),(375,'Intel Core i7',33,15),(376,'6.8',33,16),(377,'60',33,17),(378,'5784',33,18),(379,'plum',33,19),(380,'Fuga voluptatum magnam.',33,20),(381,'IOS',33,21),(382,'Gaylord-Frami',33,22),(383,'1',33,23),(384,'9',34,13),(385,'507',34,14),(386,'Apple M1',34,15),(387,'5.5',34,16),(388,'120',34,17),(389,'5649',34,18),(390,'gold',34,19),(391,'Provident quibusdam sint voluptas unde labore numquam.',34,20),(392,'Android',34,21),(393,'Herzog and Sons',34,22),(394,'6',34,23),(395,'14',35,13),(396,'376',35,14),(397,'AMD Ryzen 7',35,15),(398,'6.4',35,16),(399,'60',35,17),(400,'7354',35,18),(401,'sky blue',35,19),(402,'Quasi et illo dignissimos.',35,20),(403,'Windows 11',35,21),(404,'Von, Kihn and Mraz',35,22),(405,'8',35,23),(406,'0',36,13),(407,'303',36,14),(408,'AMD Ryzen 7',36,15),(409,'8.5',36,16),(410,'90',36,17),(411,'5512',36,18),(412,'violet',36,19),(413,'Eaque ut blanditiis aspernatur facere rerum.',36,20),(414,'IOS',36,21),(415,'Streich, Doyle and Dickinson',36,22),(416,'6',36,23),(417,'9',37,13),(418,'385',37,14),(419,'Intel Core i7',37,15),(420,'9.9',37,16),(421,'90',37,17),(422,'7293',37,18),(423,'fuchsia',37,19),(424,'Pariatur sunt voluptatem et.',37,20),(425,'Windows 10',37,21),(426,'Stamm-Witting',37,22),(427,'11',37,23),(428,'3',38,13),(429,'463',38,14),(430,'AMD Ryzen 7',38,15),(431,'9.5',38,16),(432,'90',38,17),(433,'7332',38,18),(434,'salmon',38,19),(435,'Magnam sunt ut quis inventore est reprehenderit perferendis.',38,20),(436,'IOS',38,21),(437,'Berge-Graham',38,22),(438,'12',38,23),(439,'2',39,13),(440,'441',39,14),(441,'AMD Ryzen 7',39,15),(442,'6.8',39,16),(443,'120',39,17),(444,'6825',39,18),(445,'turquoise',39,19),(446,'Dolor ducimus harum id repudiandae.',39,20),(447,'Windows 11',39,21),(448,'Wilderman, Breitenberg and Heller',39,22),(449,'9',39,23),(450,'8',40,13),(451,'511',40,14),(452,'AMD Ryzen 7',40,15),(453,'8.4',40,16),(454,'90',40,17),(455,'6098',40,18),(456,'turquoise',40,19),(457,'Id amet expedita.',40,20),(458,'IOS',40,21),(459,'Batz LLC',40,22),(460,'8',40,23),(461,'12',41,1),(462,'11',42,1),(463,'10',43,1),(464,'100',44,2),(465,'1',45,1),(466,'1',46,1),(467,'1',47,1),(468,'1',48,1),(469,'1',49,1),(470,'1',50,1),(471,'1',51,1),(472,'1',52,1),(473,'1',53,1),(474,'1',54,1),(475,'1',55,1),(476,'1',56,1),(477,'1',57,1),(478,'1',58,1),(479,'1',59,1),(480,'1',60,2),(481,'1',61,1),(482,'1',62,1),(483,'1',63,1),(484,'1',64,1),(485,'12',65,1);
/*!40000 ALTER TABLE `product_attribute_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_attributes`
--

DROP TABLE IF EXISTS `product_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_attributes` (
  `attribute_id` int NOT NULL AUTO_INCREMENT,
  `active` bit(1) DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`attribute_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_attributes`
--

LOCK TABLES `product_attributes` WRITE;
/*!40000 ALTER TABLE `product_attributes` DISABLE KEYS */;
INSERT INTO `product_attributes` VALUES (1,_binary '','mobile_ram'),(2,_binary '','mobile_storage'),(3,_binary '','mobile_cpu'),(4,_binary '','mobile_screen_type'),(5,_binary '','mobile_screen_size'),(6,_binary '','mobile_screen_refresh_rate'),(7,_binary '','mobile_battery_capacity'),(8,_binary '','mobile_color'),(9,_binary '','mobile_design_description'),(10,_binary '','mobile_os'),(11,_binary '','mobile_manufacturer'),(12,_binary '','mobile_guarantee_month'),(13,_binary '','laptop_ram'),(14,_binary '','laptop_storage'),(15,_binary '','laptop_cpu'),(16,_binary '','laptop_screen_size'),(17,_binary '','laptop_screen_refresh_rate'),(18,_binary '','laptop_battery_capacity'),(19,_binary '','laptop_color'),(20,_binary '','laptop_design_description'),(21,_binary '','laptop_os'),(22,_binary '','laptop_manufacturer'),(23,_binary '','laptop_guarantee_month'),(24,_binary '','mobile_hot'),(25,_binary '','laptop_hot');
/*!40000 ALTER TABLE `product_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image_url` varchar(300) DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKqnq71xsohugpqwf3c9gxmsuy` (`product_id`),
  CONSTRAINT `FKqnq71xsohugpqwf3c9gxmsuy` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (1,'cecfbd83-9e07-4558-873e-9cdfa6702439_237033462364600.png',1),(2,'f66568e7-2362-4229-b950-df78c3836034_237048278218100.png',2),(3,'4ec15359-8caf-4433-89d7-340bd31b4751_237071988168500.png',3),(4,'9a02a41c-8d4f-451f-93e0-a8eacb90ce3e_237078811914300.png',4),(5,'6d4263fd-da24-47a1-ab19-ee1297a58141_237086498290200.png',5),(6,'a75bbec6-6c35-4661-a919-23d2a1907d20_237095949374200.png',6),(7,'71b99163-5f86-4fc3-a997-211554f2bbbe_237104194377000.png',7),(8,'bfd9a902-d603-4ff5-8e72-e1959a6870b9_237108314552900.png',8),(9,'d0c437d8-8fa7-4e28-8951-8994cc2b88ca_237219633173000.png',1),(10,'c650208e-82fb-4004-a574-7a96f9f73411_237258715742900.png',4),(11,'c2ec945b-b021-4850-8df1-fe2866450088_237262812729400.png',4),(12,'9ba71abb-9c79-4fc0-8492-f0a38fba6b39_237436188699300.png',9),(13,'455b9cab-2526-45fb-b70d-75d2225836ce_237457143405200.png',14),(14,'e35d56fe-2c0e-45cc-9954-8d913e8d78cf_237459859649600.png',18),(15,'d305e96b-5741-4d37-9c1b-2360548a5626_237464829710000.png',21),(16,'fb1eb547-41d6-4585-8445-4d0d897a507e_237479306499300.png',23),(17,'e79928f9-2afa-4bce-9458-0fa69e37bd7a_237514263158900.png',12),(18,'039f1cd7-64f9-4c20-9141-1f1f70643262_237517259284300.png',13),(19,'e2204b9d-15e2-424c-8452-9fad929cf142_237519977335500.png',16),(20,'9fb8b886-a5ae-4ce5-b41c-321a6320956f_237523581945500.png',20),(21,'e527c332-d1b6-45e9-9771-6f527dabe371_237676847140800.webp',7),(22,'47cbaa2a-2617-45a2-ab37-79c8bb479c81_237689885148800.webp',10),(23,'1e930ac7-a726-4f6d-90f0-a7d21c8853c7_237692217795700.webp',11),(24,'4713d6a7-3c87-40b8-a9f6-a07e92b1553a_237695182826400.webp',19),(25,'e2c63647-3243-445a-b1ba-232c92d88d62_237700489955600.webp',25),(26,'3970d962-dd2c-42c9-89d4-bedde3adb2da_237716652863200.webp',31),(27,'827a2f52-b0d1-496d-864a-5be3292988ab_237719573700500.webp',32),(28,'4f4462c9-3d20-4ecf-98aa-02030b280810_237721918579700.webp',33),(29,'f8e3acac-3339-4ebd-8726-6733b082b94d_237755238119000.webp',7),(30,'0144cb1c-b495-4b2b-89b7-83a73122a486_237755943120200.webp',7),(31,'fb60519b-960a-49a8-803b-6ce6adb10ce6_237756591796900.webp',7),(32,'def3f52e-2b87-47dd-9c80-f1f64f6c8652_237868912689500.png',2),(33,'49959245-a975-4799-b9f1-808eb0d6d1c6_237924497944800.webp',17),(34,'751ed7ea-0d49-48b5-bb5b-3e9f9fc78c54_237938961389600.webp',15),(35,'5cfe31ee-1f41-4ba6-b5f4-4e037996d14f_444796256835700.png',56),(36,'5aafa747-813c-477c-851c-7bc7c2256ef7_445146826928200.png',57),(37,'f62b1a70-49c2-4ad5-b13e-735286465ea6_445291636266300.gif',58),(38,'6cdd3778-2e21-43e0-bc3e-11a8e0946bef_445537733413300.png',59),(39,'8266c195-06dd-4a5d-9be6-8090bb4a64b3_445955644234800.png',60),(40,'bc831370-09cf-45b3-becb-dfcab901cbac_446359174049400.png',61),(41,'f720a989-16fe-4e71-9dca-1be9bb753482_446505798608500.png',62),(42,'79d598b7-01b8-4f51-b837-f208779524f5_446581080266500.png',63),(43,'e9d4c60d-7ec1-4f3a-8d14-1e62121024de_446770350350900.png',64),(44,'4190ec54-6e49-44ef-bc84-7f55ab8afa16_3671791700200.png',2),(45,'8107d482-9297-4bcd-b6ab-22e39e83ef06_3717123444400.png',2),(46,'aec5250c-77b7-4c71-86fd-b693e11943c1_3742755089800.png',2),(47,'87a130c9-0138-4a93-8757-fe21b4ab8e31_3756905857600.png',2),(48,'8af5a798-912d-4e23-b09c-e861a468f46e_5065998355200.png',1),(49,'cc74991d-005d-40ae-93d8-f8915ad5c7f7_5152812500700.png',1),(50,'a21151bd-3f50-44d9-a80f-1fae5ee81be5_5171334538200.png',1),(51,'293f8e17-e697-466c-a5a2-492eaf4d0d07_5188407507200.png',3),(52,'1c4a4f28-5e86-4a11-878e-a3a32c873a29_5203330950300.png',9),(53,'9e24bbde-0b02-44fa-8328-1fd545ae1807_5291673751100.png',3),(54,'5eff9fa4-3d26-464c-9d01-d45dbd71870f_5304022773700.png',9),(55,'43ac3941-dcad-4061-a7dd-fd8241c81096_5352970934500.png',65);
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_hot` bit(1) DEFAULT NULL,
  `name` varchar(350) NOT NULL,
  `price` decimal(38,0) DEFAULT NULL,
  `quantity` bigint DEFAULT NULL,
  `thumbnail` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'2024-12-13 14:43:33.135706','2024-12-19 08:23:23.113846',_binary '','Nobis consequuntur reiciendis dolores qui labore.',_binary '\0','Samsung Galaxy A52',2528891,10,'a21151bd-3f50-44d9-a80f-1fae5ee81be5_5171334538200.png'),(2,'2024-12-13 14:43:33.194942','2024-12-19 09:40:14.259711',_binary '','Quo molestias et molestias saepe rerum numquam quia.',_binary '','Samsung Galaxy Z Fold 3',3102585,3,'87a130c9-0138-4a93-8757-fe21b4ab8e31_3756905857600.png'),(3,'2024-12-13 14:43:33.259008','2024-12-19 08:25:23.446302',_binary '\0','Aut sunt aut iure qui dolor laudantium.',_binary '','iPhone X',1943772,12,'9e24bbde-0b02-44fa-8328-1fd545ae1807_5291673751100.png'),(4,'2024-12-13 14:43:33.294745','2024-12-16 14:41:28.992490',_binary '','Repudiandae delectus saepe vitae excepturi labore.',_binary '\0','iPhone 8 Plus',3718878,0,'9a02a41c-8d4f-451f-93e0-a8eacb90ce3e_237078811914300.png'),(5,'2024-12-13 14:43:33.322611','2024-12-16 14:41:36.675212',_binary '','Et officiis reprehenderit quos dolores maxime.',_binary '','Samsung Galaxy Z Flip',1447671,1,'6d4263fd-da24-47a1-ab19-ee1297a58141_237086498290200.png'),(6,'2024-12-13 14:43:33.351829','2024-12-16 14:41:46.126376',_binary '','Voluptas itaque porro commodi.',_binary '','iPhone SE',1677419,5,'a75bbec6-6c35-4661-a919-23d2a1907d20_237095949374200.png'),(7,'2024-12-13 14:43:33.406193','2024-12-19 08:25:02.475600',_binary '','Sit nesciunt magni laborum ut sequi omnis.',_binary '','Lenovo IdeaPad Gaming 3',1482326,15,'e527c332-d1b6-45e9-9771-6f527dabe371_237676847140800.webp'),(8,'2024-12-13 14:43:33.451234','2024-12-16 14:41:58.509180',_binary '','Ut et quasi.',_binary '','Samsung Galaxy S10',2002750,9,'bfd9a902-d603-4ff5-8e72-e1959a6870b9_237108314552900.png'),(9,'2024-12-13 14:43:33.487259','2024-12-19 08:25:35.794984',_binary '','Voluptatem quaerat ut quia voluptate sapiente.',_binary '\0','iPhone 15',2104169,10,'5eff9fa4-3d26-464c-9d01-d45dbd71870f_5304022773700.png'),(10,'2024-12-13 14:43:33.511153','2024-12-16 14:51:40.077670',_binary '','Reiciendis molestiae voluptatem atque voluptate aspernatur rerum.',_binary '\0','Lenovo ThinkPad X1 Carbon',3613640,2,'47cbaa2a-2617-45a2-ab37-79c8bb479c81_237689885148800.webp'),(11,'2024-12-13 14:43:33.535120','2024-12-16 14:51:42.401756',_binary '','Ut vel atque et voluptas.',_binary '','Lenovo Yoga 9i',3808449,4,'1e930ac7-a726-4f6d-90f0-a7d21c8853c7_237692217795700.webp'),(12,'2024-12-13 14:43:33.564826','2024-12-16 14:48:44.446667',_binary '','Veritatis voluptatem distinctio provident harum.',_binary '','Samsung Galaxy S20',2012223,9,'e79928f9-2afa-4bce-9458-0fa69e37bd7a_237514263158900.png'),(13,'2024-12-13 14:43:33.603828','2024-12-16 14:48:47.432865',_binary '','Et eum incidunt enim accusantium optio numquam.',_binary '\0','Samsung Galaxy Note 20',3671206,8,'039f1cd7-64f9-4c20-9141-1f1f70643262_237517259284300.png'),(14,'2024-12-13 14:43:33.640826','2024-12-16 14:47:47.318326',_binary '','Facilis deleniti ut natus.',_binary '\0','iPhone 11 Pro',3830149,8,'455b9cab-2526-45fb-b70d-75d2225836ce_237457143405200.png'),(15,'2024-12-13 14:43:33.679825','2024-12-16 14:55:49.154378',_binary '','Voluptas nostrum qui unde.',_binary '','Asus VivoBook S15',2362659,7,'751ed7ea-0d49-48b5-bb5b-3e9f9fc78c54_237938961389600.webp'),(16,'2024-12-13 14:43:33.704827','2024-12-16 14:48:50.152396',_binary '','Velit mollitia aliquid consequatur animi.',_binary '\0','Samsung Galaxy A50',2535025,8,'e2204b9d-15e2-424c-8452-9fad929cf142_237519977335500.png'),(17,'2024-12-13 14:43:33.726826','2024-12-16 14:55:34.672202',_binary '','Nemo illo ut.',_binary '','Asus VivoBook Flip 14',2114047,6,'49959245-a975-4799-b9f1-808eb0d6d1c6_237924497944800.webp'),(18,'2024-12-13 14:43:33.750732','2024-12-16 14:47:50.033258',_binary '','Impedit qui officiis eum ut.',_binary '','iPhone 13',3045577,0,'e35d56fe-2c0e-45cc-9954-8d913e8d78cf_237459859649600.png'),(19,'2024-12-13 14:43:33.814145','2024-12-16 14:51:45.381819',_binary '','Doloribus consequatur ut.',_binary '','Lenovo Legion 5 Pro',3102466,2,'4713d6a7-3c87-40b8-a9f6-a07e92b1553a_237695182826400.webp'),(20,'2024-12-13 14:43:33.849949','2024-12-16 14:48:53.760072',_binary '','Ipsum autem repellat ea eos qui rem.',_binary '\0','Samsung Galaxy S22 Ultra',1080380,8,'9fb8b886-a5ae-4ce5-b41c-321a6320956f_237523581945500.png'),(21,'2024-12-13 14:43:33.880094','2024-12-16 14:47:55.009864',_binary '','Architecto dolores et deserunt.',_binary '','iPhone 12 Mini',3747008,8,'d305e96b-5741-4d37-9c1b-2360548a5626_237464829710000.png'),(22,'2024-12-13 14:43:33.904630','2024-12-13 14:43:33.904630',_binary '','Quas minus voluptatem iusto nisi.',_binary '\0','Samsung Galaxy S21',1310462,4,NULL),(23,'2024-12-13 14:43:33.923327','2024-12-16 14:48:09.496341',_binary '','Sit illo accusantium quod.',_binary '\0','iPhone XR',2531480,7,'fb1eb547-41d6-4585-8445-4d0d897a507e_237479306499300.png'),(24,'2024-12-13 14:43:33.944944','2024-12-13 14:43:33.944944',_binary '','Dicta aperiam nesciunt dolorem culpa ipsam.',_binary '','Samsung Galaxy A72',3193058,6,NULL),(25,'2024-12-13 14:43:33.981351','2024-12-16 14:51:50.738163',_binary '','Est necessitatibus repudiandae repellat qui.',_binary '','Lenovo IdeaPad 3',2920821,4,'e2c63647-3243-445a-b1ba-232c92d88d62_237700489955600.webp'),(26,'2024-12-13 14:43:34.015866','2024-12-13 14:43:34.015866',_binary '','Eaque nisi dicta aut rerum.',_binary '\0','Asus ProArt StudioBook',2994723,0,NULL),(27,'2024-12-13 14:43:34.048986','2024-12-13 14:43:34.048986',_binary '','Consequatur quod qui.',_binary '\0','iPhone 15 Pro Max',3450618,2,NULL),(28,'2024-12-13 14:43:34.082247','2024-12-13 14:43:34.082247',_binary '','Odio odio autem laudantium ab qui dignissimos nemo.',_binary '','iPhone 14',3320316,0,NULL),(29,'2024-12-13 14:43:34.106392','2024-12-13 14:43:34.107247',_binary '','Omnis nihil voluptas est laudantium.',_binary '\0','Asus TUF Gaming A15',1152431,8,NULL),(30,'2024-12-13 14:43:34.124257','2024-12-13 14:43:34.124257',_binary '','Reiciendis quisquam deleniti aperiam.',_binary '\0','Asus ZenBook 14',3439016,5,NULL),(31,'2024-12-13 14:43:34.142022','2024-12-16 14:52:06.839040',_binary '','Magni dolorem nobis omnis qui eligendi tempore.',_binary '','Lenovo ThinkBook 15',2131666,3,'3970d962-dd2c-42c9-89d4-bedde3adb2da_237716652863200.webp'),(32,'2024-12-13 14:43:34.156781','2024-12-16 14:52:09.785233',_binary '','Quasi unde est iusto deserunt nemo.',_binary '\0','Lenovo ThinkPad T14',3857243,6,'827a2f52-b0d1-496d-864a-5be3292988ab_237719573700500.webp'),(33,'2024-12-13 14:43:34.177143','2024-12-16 14:52:12.123215',_binary '','Architecto voluptatibus culpa.',_binary '','Lenovo ThinkPad P1',3466635,2,'4f4462c9-3d20-4ecf-98aa-02030b280810_237721918579700.webp'),(34,'2024-12-13 14:43:34.206060','2024-12-13 14:43:34.206060',_binary '','Perspiciatis fugiat velit.',_binary '\0','Asus ZenBook Pro Duo',3892891,2,NULL),(35,'2024-12-13 14:43:34.228316','2024-12-13 14:43:34.228316',_binary '','Fuga laborum iste in.',_binary '','Lenovo Yoga Slim 7',3778595,7,NULL),(36,'2024-12-13 14:43:34.252673','2024-12-13 14:43:34.252673',_binary '','Qui voluptates eos voluptatem sint consequatur.',_binary '\0','Lenovo Legion Y740',3112498,0,NULL),(37,'2024-12-13 14:43:34.287070','2024-12-13 14:43:34.287070',_binary '','Autem totam eum dolor nesciunt.',_binary '\0','Asus ROG Strix G15',3656460,8,NULL),(38,'2024-12-13 14:43:34.301740','2024-12-13 14:43:34.302732',_binary '','Quibusdam sapiente saepe sunt unde at.',_binary '','Asus TUF Dash F15',3675846,8,NULL),(39,'2024-12-13 14:43:34.315805','2024-12-13 14:43:34.315805',_binary '','Dolorem beatae ut iure consequatur quia tempora quae.',_binary '','Asus ROG Zephyrus G14',1669908,5,NULL),(40,'2024-12-13 14:43:34.332451','2024-12-13 14:43:34.332451',_binary '','Enim et eveniet voluptas id unde.',_binary '','Asus ExpertBook B9',1395717,1,NULL),(41,'2024-12-18 23:13:09.842064','2024-12-18 23:13:53.051034',_binary '','dfsdfds',_binary '\0','sp1',43000000,33,'anh-dong-cute-de-thuong-nhat_105545173.gif'),(42,'2024-12-18 23:22:57.546270','2024-12-18 23:22:57.546270',_binary '','dsvfdsfds',_binary '\0','sp2',45000000,43,'1200px-LOGO_DHXD.png'),(43,'2024-12-18 23:31:21.910540','2024-12-18 23:31:21.910540',_binary '','dfgsdfd',_binary '\0','sp3',1000000,55,'z4297662279550_de83e5cffc8a47bf025ce7c1d24c2108.jpg'),(44,'2024-12-18 23:35:18.987973','2024-12-18 23:35:18.987973',_binary '','dfdsfd',_binary '\0','sp4',345555,22,'793.jpg'),(45,'2024-12-18 23:41:06.085261','2024-12-18 23:41:06.086258',_binary '','dgfdsfd',_binary '\0','sp6',45000000,22,NULL),(46,'2024-12-18 23:43:02.808372','2024-12-18 23:43:02.808372',_binary '','fdsfsdf',_binary '\0','sp7',454354354,2,NULL),(47,'2024-12-18 23:44:34.876223','2024-12-18 23:44:34.876223',_binary '','dfsdfds',_binary '\0','sp10',4500000,21,NULL),(48,'2024-12-18 23:49:39.768487','2024-12-18 23:49:39.768487',_binary '','dfdsfd',_binary '\0','sp14',3432432432,20,NULL),(49,'2024-12-18 23:52:57.524346','2024-12-18 23:52:57.524346',_binary '','dfgsdfds',_binary '\0','sp15',150000000,22,NULL),(50,'2024-12-19 00:07:07.205626','2024-12-19 00:07:07.205626',_binary '','dfds',_binary '\0','sp20',3344444,36,NULL),(51,'2024-12-19 00:08:29.774366','2024-12-19 00:08:29.774366',_binary '','dfsdfs',_binary '\0','sp23',3432432432,32,NULL),(52,'2024-12-19 00:12:12.720923','2024-12-19 00:12:12.720923',_binary '','sfsadsa',_binary '\0','sp30',43543543,31,NULL),(53,'2024-12-19 00:16:28.962947','2024-12-19 00:16:28.962947',_binary '','dfdsfds',_binary '\0','sp31',45345435,54,NULL),(54,'2024-12-19 00:20:44.752018','2024-12-19 00:20:44.752018',_binary '','dfsdfd',_binary '\0','sp34',34354354,33,'1200px-LOGO_DHXD.png'),(55,'2024-12-19 00:21:13.257704','2024-12-19 00:21:13.257704',_binary '','dfsdfd',_binary '\0','sp35',34354354,33,'1200px-LOGO_DHXD.png'),(56,'2024-12-19 00:23:03.021423','2024-12-19 00:23:03.021423',_binary '','dfgdsfd',_binary '\0','sp36',43534454,543,'1200px-LOGO_DHXD.png'),(57,'2024-12-19 00:28:53.550495','2024-12-19 00:28:53.550495',_binary '','gfdgdfg',_binary '\0','sp40',4534543543,33,'1200px-LOGO_DHXD.png'),(58,'2024-12-19 00:31:18.421548','2024-12-19 00:31:18.421548',_binary '','gfdgdfg',_binary '\0','sp41',4534543543,33,'429a890a39e70d522d52c7e52bce8535.gif'),(59,'2024-12-19 00:35:22.545848','2024-12-19 00:35:22.545848',_binary '','dfsdfdsf',_binary '\0','sp42',454354,44,'airpod2.png'),(60,'2024-12-19 00:42:22.376128','2024-12-19 00:42:22.376128',_binary '','dfdsfds',_binary '\0','sp50',4534543534534,44,''),(61,'2024-12-19 00:49:05.379965','2024-12-19 00:49:05.379965',_binary '','dfsdfdsf',_binary '\0','sp60',454353453453,31,''),(62,'2024-12-19 00:51:32.657633','2024-12-19 00:51:32.657633',_binary '','gfdgfd',_binary '\0','sp70',4534543,45,''),(63,'2024-12-19 00:52:47.986379','2024-12-19 00:52:47.986379',_binary '','fdsfds',_binary '\0','sp80',43534543,45,''),(64,'2024-12-19 00:55:57.292749','2024-12-19 00:55:58.418097',_binary '','rtfdgfd',_binary '\0','sp90',453454154,45,'e9d4c60d-7ec1-4f3a-8d14-1e62121024de_446770350350900.png'),(65,'2024-12-19 08:26:23.614007','2024-12-19 08:26:24.756532',_binary '','fgfdgfdgdf',_binary '\0','sp100',4353454543543,33,'43ac3941-dcad-4061-a7dd-fd8241c81096_5352970934500.png');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_subcategory`
--

DROP TABLE IF EXISTS `products_subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products_subcategory` (
  `product_id` bigint NOT NULL,
  `subcategory_id` bigint NOT NULL,
  KEY `FKlny3kevnhm9a4oaahua7ofabd` (`subcategory_id`),
  KEY `FKbu8cny8p1lf3frbo127lve5eo` (`product_id`),
  CONSTRAINT `FKbu8cny8p1lf3frbo127lve5eo` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `FKlny3kevnhm9a4oaahua7ofabd` FOREIGN KEY (`subcategory_id`) REFERENCES `sub_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_subcategory`
--

LOCK TABLES `products_subcategory` WRITE;
/*!40000 ALTER TABLE `products_subcategory` DISABLE KEYS */;
INSERT INTO `products_subcategory` VALUES (4,1),(5,2),(6,1),(8,2),(10,3),(11,3),(12,2),(13,2),(14,1),(15,4),(16,2),(17,4),(18,1),(19,3),(20,2),(21,1),(22,2),(23,1),(24,2),(25,3),(26,4),(27,1),(28,1),(29,4),(30,4),(31,3),(32,3),(33,3),(34,4),(35,3),(36,3),(37,4),(38,4),(39,4),(40,4),(41,1),(41,2),(42,1),(42,2),(43,1),(43,2),(44,1),(44,2),(45,1),(45,2),(46,1),(47,1),(48,1),(49,1),(50,1),(51,1),(52,1),(53,1),(54,1),(55,1),(56,1),(57,1),(58,1),(59,1),(60,1),(61,1),(62,1),(63,1),(64,1),(2,2),(1,2),(7,3),(3,1),(9,1),(65,1);
/*!40000 ALTER TABLE `products_subcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating`
--

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rating` (
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `rate` int NOT NULL,
  `product_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`product_id`,`user_id`),
  KEY `FKf68lgbsbxl310n0jifwpfqgfh` (`user_id`),
  CONSTRAINT `FK4odf7rh1jmwmew4dnowoc73cf` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `FKf68lgbsbxl310n0jifwpfqgfh` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating`
--

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
INSERT INTO `rating` VALUES ('2024-12-13 16:03:57.924067','2024-12-13 16:03:57.924067','H√†ng ƒë·∫πp m√™',4,1,2),('2024-12-13 16:05:16.041832','2024-12-13 16:05:16.041832','r·∫•t l√† ƒë·∫πp',4,2,2),('2024-12-13 16:04:09.866870','2024-12-13 16:04:09.866870','ƒë∆∞·ª£c',5,3,2),('2024-12-13 16:04:23.536198','2024-12-13 16:04:23.536198','ƒë·∫πp l·∫Øm',4,4,2);
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reset_password_tokens`
--

DROP TABLE IF EXISTS `reset_password_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reset_password_tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `expiry_date` datetime(6) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKiexewvuohcc9orva35toh9st9` (`user_id`),
  CONSTRAINT `FKnwk79win0k7k6tlb6imjninfu` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reset_password_tokens`
--

LOCK TABLES `reset_password_tokens` WRITE;
/*!40000 ALTER TABLE `reset_password_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `reset_password_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ADMIN'),(2,'USER');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipments`
--

DROP TABLE IF EXISTS `shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `active` bit(1) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `estimated_day` int DEFAULT NULL,
  `price` decimal(32,0) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipments`
--

LOCK TABLES `shipments` WRITE;
/*!40000 ALTER TABLE `shipments` DISABLE KEYS */;
INSERT INTO `shipments` VALUES (1,'2024-12-13 15:22:48.258999','2024-12-16 14:33:51.565648',_binary '','c·∫•p 1',4,10000,'free'),(2,'2024-12-13 15:23:24.377789','2024-12-19 09:52:36.466954',_binary '\0','c·∫•p 2',3,20000,'Standard'),(3,'2024-12-13 15:23:45.945665','2024-12-17 09:36:51.340569',_binary '','c·∫•p 3',2,30000,'Premium');
/*!40000 ALTER TABLE `shipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_categories`
--

DROP TABLE IF EXISTS `sub_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sub_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `category_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKjwy7imy3rf6r99x48ydq45otw` (`category_id`),
  CONSTRAINT `FKjwy7imy3rf6r99x48ydq45otw` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_categories`
--

LOCK TABLES `sub_categories` WRITE;
/*!40000 ALTER TABLE `sub_categories` DISABLE KEYS */;
INSERT INTO `sub_categories` VALUES (1,'2024-12-13 14:43:32.814145','2024-12-13 14:43:32.828770','Iphone',1),(2,'2024-12-13 14:43:32.846067','2024-12-13 14:43:32.855065','Samsung',1),(3,'2024-12-13 14:43:32.866997','2024-12-13 14:43:32.875119','Lenovo',2),(4,'2024-12-13 14:43:32.885353','2024-12-13 14:43:32.892354','Asus',2);
/*!40000 ALTER TABLE `sub_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `date_of_birth` datetime(6) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `phone_number` varchar(10) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `provider` enum('facebook','github','google','local') DEFAULT NULL,
  `provider_id` varchar(255) DEFAULT NULL,
  `role_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKp56c1712k691lhsyewcssf40f` (`role_id`),
  CONSTRAINT `FKp56c1712k691lhsyewcssf40f` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'2024-12-13 14:43:32.749231','2024-12-16 15:44:13.185243',_binary '',NULL,NULL,'admin@gmail.com','admin','$2a$12$NN.hmaHr.BCspZdpneO.CeP/NC.2MgPj.FgsH7TdWfOESVbWaypHu','admin12345','7fc87937-2ca6-4bc3-aabe-fd86a5e96ebf_128485095978900.png',NULL,NULL,1),(2,'2024-12-13 14:44:32.923854','2024-12-18 20:52:26.836200',_binary '','Th∆∞·ªùng T√≠n, H√† N·ªôi ',NULL,'duc0004867@huce.edu.vn','ƒê√†o Duy ƒê·ª©c - 67IT2','$2a$10$DLtJuvpVUWfo81QJTixaKe7W8MtEoA1MyaRDjxArLJUmC5YYT0/J.','0865172698','https://lh3.googleusercontent.com/a/ACg8ocLFq2xFeDhgXtzCUOsv9imKINtmqNusDlCgOs2N6jXGeFHdB3M=s96-c','google','115391856849081530375',2),(4,'2024-12-13 15:22:03.201711','2024-12-13 15:22:03.201711',_binary '',NULL,NULL,'admin',NULL,'$2a$10$xskgSXhX1LDrQXldkntpB.L9WrORu2.G6Q2UPh0ANSAb8Zc7pu/vu','admin',NULL,NULL,NULL,1),(5,'2024-12-14 21:35:09.704051','2024-12-16 15:44:37.770422',_binary '','45fdgfdg, gdfgdf, 565 dfdsufsd',NULL,'ducyhoo543@gmail.com','Duy ƒê·ª©c','$2a$10$wowWlIBsZmJqCfHlRxR/B.jv9kuDJCpWhFezzp6lQ2lhhOmKW3cT6','0865172699','5711cc99-077d-44ae-83eb-b7fcd7033374_215674915283500.png',NULL,NULL,2),(6,'2024-12-19 09:00:13.529594','2024-12-19 09:00:13.529594',_binary '','45fdgfdg, gdfgdf, 565 dfdsufsd',NULL,'adfasd@dfgdf.com','Duy ƒê·ª©c','$2a$10$fRvIHNcOlMf7bFyOyfOzuOOZidg.H36YrPkRNa6umLOCg3vonvfkS','5634554345',NULL,NULL,NULL,2);
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

-- Dump completed on 2024-12-21  7:57:51
