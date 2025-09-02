-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: radiologica_mysql
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.24.04.1

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

--
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `id_appointment` bigint NOT NULL AUTO_INCREMENT,
  `appo_patient_id` bigint NOT NULL,
  `appo_date` date NOT NULL,
  `appo_time` time NOT NULL,
  `appo_status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_appointment`),
  KEY `appo_patient_id` (`appo_patient_id`),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`appo_patient_id`) REFERENCES `patient` (`id_patient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `id_doctor` bigint NOT NULL AUTO_INCREMENT,
  `doct_first_name` varchar(100) NOT NULL,
  `doct_last_name` varchar(100) NOT NULL,
  `doct_specialty` varchar(100) DEFAULT NULL,
  `doct_phone` varchar(20) DEFAULT NULL,
  `doct_email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_doctor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipment` (
  `id_equipment` bigint NOT NULL AUTO_INCREMENT,
  `equi_name` varchar(100) NOT NULL,
  `equi_brand` varchar(50) DEFAULT NULL,
  `equi_model` varchar(50) DEFAULT NULL,
  `equi_location` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_equipment`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
  `id_image` bigint NOT NULL AUTO_INCREMENT,
  `imag_study_id` bigint NOT NULL,
  `imag_file_path` varchar(200) NOT NULL,
  `imag_format` varchar(10) DEFAULT NULL,
  `imag_capture_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id_image`),
  KEY `imag_study_id` (`imag_study_id`),
  CONSTRAINT `image_ibfk_1` FOREIGN KEY (`imag_study_id`) REFERENCES `study` (`id_study`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image`
--

LOCK TABLES `image` WRITE;
/*!40000 ALTER TABLE `image` DISABLE KEYS */;
/*!40000 ALTER TABLE `image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modality`
--

DROP TABLE IF EXISTS `modality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modality` (
  `id_modality` bigint NOT NULL AUTO_INCREMENT,
  `moda_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id_modality`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modality`
--

LOCK TABLES `modality` WRITE;
/*!40000 ALTER TABLE `modality` DISABLE KEYS */;
/*!40000 ALTER TABLE `modality` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `id_patient` bigint NOT NULL AUTO_INCREMENT,
  `pati_first_name` varchar(30) NOT NULL,
  `pati_last_name` varchar(30) NOT NULL,
  `pati_birth_date` date NOT NULL,
  `pati_gender` char(1) DEFAULT NULL,
  `pati_address` varchar(100) DEFAULT NULL,
  `pati_phone` varchar(13) DEFAULT NULL,
  `pati_email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_patient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id_payment` bigint NOT NULL AUTO_INCREMENT,
  `paym_patient_id` bigint NOT NULL,
  `paym_study_id` bigint NOT NULL,
  `paym_amount` decimal(10,2) NOT NULL,
  `paym_date` datetime NOT NULL,
  `paym_method` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_payment`),
  KEY `paym_patient_id` (`paym_patient_id`),
  KEY `paym_study_id` (`paym_study_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`paym_patient_id`) REFERENCES `patient` (`id_patient`),
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`paym_study_id`) REFERENCES `study` (`id_study`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `id_report` bigint NOT NULL,
  `repo_description` text,
  `repo_diagnosis` text,
  `repo_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id_report`),
  CONSTRAINT `report_ibfk_1` FOREIGN KEY (`id_report`) REFERENCES `study` (`id_study`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study`
--

DROP TABLE IF EXISTS `study`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study` (
  `id_study` bigint NOT NULL AUTO_INCREMENT,
  `stud_patient_id` bigint NOT NULL,
  `stud_modality_id` bigint NOT NULL,
  `stud_equipment_id` bigint DEFAULT NULL,
  `stud_doctor_id` bigint DEFAULT NULL,
  `stud_technologist_id` bigint DEFAULT NULL,
  `stud_appointment_id` bigint DEFAULT NULL,
  `stud_date` datetime NOT NULL,
  `stud_status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_study`),
  KEY `stud_patient_id` (`stud_patient_id`),
  KEY `stud_modality_id` (`stud_modality_id`),
  KEY `stud_equipment_id` (`stud_equipment_id`),
  KEY `stud_doctor_id` (`stud_doctor_id`),
  KEY `stud_technologist_id` (`stud_technologist_id`),
  KEY `stud_appointment_id` (`stud_appointment_id`),
  CONSTRAINT `study_ibfk_1` FOREIGN KEY (`stud_patient_id`) REFERENCES `patient` (`id_patient`),
  CONSTRAINT `study_ibfk_2` FOREIGN KEY (`stud_modality_id`) REFERENCES `modality` (`id_modality`),
  CONSTRAINT `study_ibfk_3` FOREIGN KEY (`stud_equipment_id`) REFERENCES `equipment` (`id_equipment`),
  CONSTRAINT `study_ibfk_4` FOREIGN KEY (`stud_doctor_id`) REFERENCES `doctor` (`id_doctor`),
  CONSTRAINT `study_ibfk_5` FOREIGN KEY (`stud_technologist_id`) REFERENCES `technologist` (`id_technologist`),
  CONSTRAINT `study_ibfk_6` FOREIGN KEY (`stud_appointment_id`) REFERENCES `appointment` (`id_appointment`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study`
--

LOCK TABLES `study` WRITE;
/*!40000 ALTER TABLE `study` DISABLE KEYS */;
/*!40000 ALTER TABLE `study` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_tag`
--

DROP TABLE IF EXISTS `study_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_tag` (
  `stta_study_id` bigint NOT NULL,
  `stta_tag_id` bigint NOT NULL,
  PRIMARY KEY (`stta_study_id`,`stta_tag_id`),
  KEY `stta_tag_id` (`stta_tag_id`),
  CONSTRAINT `study_tag_ibfk_1` FOREIGN KEY (`stta_study_id`) REFERENCES `study` (`id_study`),
  CONSTRAINT `study_tag_ibfk_2` FOREIGN KEY (`stta_tag_id`) REFERENCES `tag` (`id_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_tag`
--

LOCK TABLES `study_tag` WRITE;
/*!40000 ALTER TABLE `study_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `study_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `id_tag` bigint NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technologist`
--

DROP TABLE IF EXISTS `technologist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technologist` (
  `id_technologist` bigint NOT NULL AUTO_INCREMENT,
  `tech_first_name` varchar(100) NOT NULL,
  `tech_last_name` varchar(100) NOT NULL,
  `tech_phone` varchar(20) DEFAULT NULL,
  `tech_email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_technologist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technologist`
--

LOCK TABLES `technologist` WRITE;
/*!40000 ALTER TABLE `technologist` DISABLE KEYS */;
/*!40000 ALTER TABLE `technologist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-01 20:08:00
