/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: james_bond
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `activity_news`
--

DROP TABLE IF EXISTS `activity_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_news` (
  `activity_news_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `summary` text DEFAULT NULL,
  `image_url` varchar(255) NOT NULL,
  `release_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`activity_news_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_news`
--

LOCK TABLES `activity_news` WRITE;
/*!40000 ALTER TABLE `activity_news` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `activity_news` VALUES
(1,'Panen Raya Jagung Kuartal I 2026','Kepala BPS Kabupaten Bondowoso didampingi oleh ketua Tim Pertanian blablabla','activity_news/sapi_lagi.png','2026-02-06','2026-02-06 06:49:23','2026-02-06 06:49:46'),
(2,'Rapat Koordinasi Sapi Cantik BPS Kabupaten Bondowoso','Sehubungan dengan pelaksanaan program pembinaan sapi cantik','activity_news/sapi_2024.png','2025-12-08','2026-02-06 06:49:23','2026-02-06 06:49:46'),
(3,'Hey You','idk, you just beautiful','activity_news/cantikku.png','2025-11-21','2026-02-06 06:49:23','2026-02-06 06:49:46'),
(4,'Hey You','Ill see you on the darkside of the moon','activity_news/cantikku.png','2025-11-21','2026-02-06 06:51:16','2026-02-06 06:51:16');
/*!40000 ALTER TABLE `activity_news` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `categories` VALUES
(1,'Utama','Publikasi statistik utama dan rilis resmi Badan Pusat Statistik','2026-02-01 04:40:12','2026-02-01 04:40:12'),
(2,'Ekonomi','Publikasi statistik di bidang ekonomi seperti PDRB, inflasi, dan perdagangan','2026-02-01 04:40:12','2026-02-01 04:40:12'),
(3,'Sosial','Publikasi statistik di bidang sosial meliputi pendidikan, kesehatan, dan kesejahteraan','2026-02-01 04:40:12','2026-02-01 04:40:12'),
(4,'Pertanian','Publikasi statistik sektor pertanian, perkebunan, dan ketahanan pangan','2026-02-01 04:40:12','2026-02-01 04:40:12'),
(5,'Lingkungan','Publikasi statistik terkait lingkungan hidup dan sumber daya alam','2026-02-01 04:40:12','2026-02-01 04:40:12'),
(6,'Kependudukan','Publikasi statistik terkait penduduk, demografi, dan ketenagakerjaan','2026-02-01 04:40:12','2026-02-01 04:40:12');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `feedbacks`
--

DROP TABLE IF EXISTS `feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedbacks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `rating` tinyint(4) NOT NULL,
  `job` varchar(50) DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `message` text DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedbacks`
--

LOCK TABLES `feedbacks` WRITE;
/*!40000 ALTER TABLE `feedbacks` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `feedbacks` VALUES
(1,5,'Mahasiswa','[\"Tampilan\",\"Performa Akses\"]','Aplikasinya bagus dan ringan','curl/8.14.1','127.0.0.1','2026-02-06 10:34:33','2026-02-06 10:34:33'),
(2,5,'Wiraswasta','[\"Tampilan\"]','mantappp','Dart/3.10 (dart:io)','192.168.1.5','2026-02-06 10:38:51','2026-02-06 10:38:51'),
(3,5,'Pelajar / Mahasiswa','[\"Tampilan\"]','maknyuusss','Dart/3.10 (dart:io)','192.168.1.5','2026-02-06 10:59:56','2026-02-06 10:59:56'),
(4,5,'Swasta','[\"Kelengkapan Data\"]','adfadf','Dart/3.10 (dart:io)','192.168.1.5','2026-02-06 11:05:39','2026-02-06 11:05:39'),
(5,5,'Pelajar / Mahasiswa','[\"Metadata\"]','mantap anwar','Dart/3.10 (dart:io)','192.168.0.105','2026-02-08 02:45:56','2026-02-08 02:45:56'),
(6,5,'ASN','[\"Metadata\",\"Fitur\"]','nicee','Dart/3.10 (dart:io)','192.168.0.105','2026-02-08 09:07:52','2026-02-08 09:07:52'),
(7,5,'Lainnya','[\"Fitur\"]','Nice Anwar','Dart/3.10 (dart:io)','192.168.0.110','2026-02-08 09:44:12','2026-02-08 09:44:12'),
(8,3,'ASN','[\"Tampilan\",\"Fitur\"]','askaksjs','Dart/3.10 (dart:io)','172.20.10.13','2026-02-09 00:12:29','2026-02-09 00:12:29'),
(9,5,'Swasta','[\"Tampilan\"]','mantap','Dart/3.10 (dart:io)','172.20.10.13','2026-02-09 00:30:51','2026-02-09 00:30:51');
/*!40000 ALTER TABLE `feedbacks` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `infographics`
--

DROP TABLE IF EXISTS `infographics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `infographics` (
  `infographic_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`infographic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `infographics`
--

LOCK TABLES `infographics` WRITE;
/*!40000 ALTER TABLE `infographics` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `infographics` VALUES
(1,'Data Pemotongan Ternak Sapi 2024','Infografis ini menyajikan data jumlah pemotongan ternak sapi di Kabupaten Bondowoso tahun 2024 berdasarkan triwulan dan bulan.','infographics/sapi_2024.png',NULL,NULL),
(2,'Infografis Kependudukan Bondowoso','Infografis dummy tentang gambaran umum kependudukan Kabupaten Bondowoso.','infographics/cantikku.png','2026-02-03 15:33:42',NULL),
(3,'Infografis Pendidikan Kabupaten Bondowoso','Infografis dummy mengenai kondisi pendidikan di Kabupaten Bondowoso.','infographics/cantikku.png','2026-02-03 15:33:42',NULL),
(4,'Infografis Kesehatan Masyarakat','Infografis dummy yang menampilkan indikator kesehatan masyarakat.','infographics/cantikku.png','2026-02-03 15:33:42',NULL),
(5,'Infografis Ekonomi Daerah','Infografis dummy terkait perkembangan ekonomi Kabupaten Bondowoso.','infographics/cantikku.png','2026-02-03 15:33:42',NULL),
(6,'Infografis Sosial dan Budaya','Infografis dummy mengenai kondisi sosial dan budaya masyarakat Bondowoso.','infographics/cantikku.png','2026-02-03 15:33:42',NULL);
/*!40000 ALTER TABLE `infographics` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `migrations` VALUES
(1,'2025_11_22_104155_create_personal_access_tokens_table',1),
(2,'2026_01_28_033020_create_statistic_subjects_table',1),
(3,'2026_01_28_033031_create_statistic_subsubjects_table',1),
(4,'2026_01_28_042655_create_statistic_data_table',1),
(5,'2026_01_28_043230_create_statistic_indicators_table',1),
(6,'2026_01_29_041241_create_news_table',1),
(7,'2026_01_29_041532_create_infographics_table',1),
(8,'2026_01_29_041723_create_categories_table',1),
(9,'2026_01_29_042208_create_publications_table',1),
(10,'2026_01_29_042719_create_statistic_data_table',1),
(11,'2026_02_01_043347_create_cache_table',2),
(12,'2026_02_01_051516_create_statistic_tables_table',3),
(13,'2026_02_01_051605_create_statistic_table_columns_table',3),
(14,'2026_02_01_051624_create_statistic_table_rows_table',3),
(15,'2026_02_06_020134_create_activity_news_table',4);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `news_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `summary` varchar(255) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `release_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`news_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `news` VALUES
(1,'BPS Rilis Data Kependudukan Kabupaten Bondowoso 2024','BPS Kabupaten Bondowoso merilis data kependudukan terbaru tahun 2024 yang mencakup jumlah dan persebaran penduduk.','covers/cantikku.png','2024-01-15','2026-02-01 04:42:13','2026-02-01 04:42:13'),
(2,'Pertumbuhan Ekonomi Bondowoso Triwulan IV 2023 Meningkat','Pertumbuhan ekonomi Kabupaten Bondowoso pada triwulan IV 2023 meningkat seiring membaiknya sektor pertanian dan perdagangan.','covers/cantikku.png','2024-02-10','2026-02-01 04:42:13','2026-02-01 04:42:13'),
(3,'Indeks Pembangunan Manusia Bondowoso Tahun 2023','Indeks Pembangunan Manusia Kabupaten Bondowoso tahun 2023 mengalami peningkatan terutama pada sektor pendidikan dan kesehatan.','covers/cantikku.png','2024-03-05','2026-02-01 04:42:13','2026-02-01 04:42:13'),
(4,'Produksi Padi Kabupaten Bondowoso Tahun 2023','Produksi padi Kabupaten Bondowoso tahun 2023 mengalami peningkatan dibandingkan tahun sebelumnya.','covers/cantikku.png','2024-03-20','2026-02-01 04:42:13','2026-02-01 04:42:13'),
(5,'Tingkat Pengangguran Terbuka Kabupaten Bondowoso 2023','Tingkat Pengangguran Terbuka Kabupaten Bondowoso tahun 2023 menunjukkan penurunan dibandingkan tahun sebelumnya.','covers/cantikku.png','2024-04-02','2026-02-01 04:42:13','2026-02-01 04:42:13');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `publications`
--

DROP TABLE IF EXISTS `publications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `publications` (
  `publication_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `release_date` date DEFAULT NULL,
  `pdf_file` varchar(255) DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `cover_url` varchar(255) DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `publication_category` bigint(20) unsigned DEFAULT NULL,
  `catalog_number` int(11) DEFAULT NULL,
  `publication_number` varchar(255) DEFAULT NULL,
  `isbn` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `download_count` int(11) DEFAULT 0,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`publication_id`),
  KEY `publications_publication_category_foreign` (`publication_category`),
  CONSTRAINT `publications_publication_category_foreign` FOREIGN KEY (`publication_category`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publications`
--

LOCK TABLES `publications` WRITE;
/*!40000 ALTER TABLE `publications` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `publications` VALUES
(1,'Kabupaten Bondowoso Dalam Angka 2024','2024-02-20',NULL,'publications/publikasi1.pdf','covers/cantikku.png','Publikasi tahunan yang menyajikan indikator statistik utama Kabupaten Bondowoso.','Publikasi ini memuat data lintas sektor seperti kependudukan, ekonomi, sosial, dan lingkungan hidup.',1,1102001,'BDA-2024','978-602-1234-56-7','2026-02-01 04:44:26','2026-02-09 00:27:04',20,0),
(2,'Statistik Kesejahteraan Rakyat Kabupaten Bondowoso 2023','2023-12-10',NULL,'publications/publikasi1.pdf','covers/cantikku.png','Publikasi statistik yang membahas kondisi kesejahteraan masyarakat.','Menyajikan data pendidikan, kesehatan, dan perumahan masyarakat Bondowoso.',2,1102002,'KESRA-2023','978-602-1234-78-9','2026-02-01 04:44:26','2026-02-09 00:07:20',1,0),
(3,'Produk Domestik Regional Bruto Kabupaten Bondowoso Menurut Lapangan Usaha 2019–2023','2024-01-05',NULL,'publications/publikasi1.pdf','covers/cantikku.png','Publikasi PDRB Kabupaten Bondowoso berdasarkan lapangan usaha.','Menyajikan data PDRB seri 2019–2023 sebagai dasar analisis ekonomi daerah.',1,1102003,'PDRB-2023','978-602-2234-11-2','2026-02-01 04:44:26','2026-02-06 13:02:53',51,0),
(4,'Statistik Pendidikan Kabupaten Bondowoso 2023','2023-10-20',NULL,'publications/publikasi1.pdf','covers/cantikku.png','Publikasi statistik sektor pendidikan di Kabupaten Bondowoso.','Menyajikan data partisipasi sekolah, tingkat pendidikan, dan fasilitas pendidikan.',1,1102004,'PEND-2023','978-602-2234-33-4','2026-02-01 04:44:26','2026-02-01 04:44:26',0,0),
(5,'Statistik Kesehatan Kabupaten Bondowoso 2023','2023-09-18',NULL,'publications/publikasi1.pdf','covers/cantikku.png','Publikasi statistik yang membahas kondisi kesehatan masyarakat.','Berisi data fasilitas kesehatan, tenaga medis, dan indikator kesehatan utama.',1,1102005,'KES-2023','978-602-2234-44-5','2026-02-01 04:44:26','2026-02-08 02:41:47',1,0);
/*!40000 ALTER TABLE `publications` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `release_plans`
--

DROP TABLE IF EXISTS `release_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `release_plans` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `type` enum('publikasi','brs') NOT NULL,
  `planned_date` date NOT NULL,
  `released_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `target_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `release_plans`
--

LOCK TABLES `release_plans` WRITE;
/*!40000 ALTER TABLE `release_plans` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `release_plans` VALUES
(1,'Kabupaten Bondowoso Dalam Angka 2026','publikasi','2026-02-27',NULL,'2026-02-04 09:41:25','2026-02-04 09:41:25',NULL),
(2,'Indikator Kesejahteraan Rakyat 2025','publikasi','2026-03-15','2026-03-15','2026-02-04 09:41:25','2026-02-04 09:41:25',1),
(3,'Perkembangan Inflasi Januari 2026','brs','2026-01-10','2026-01-10','2026-02-04 09:41:25','2026-02-04 09:41:25',1),
(4,'Pertumbuhan Ekonomi Kabupaten Bondowoso','brs','2026-02-05','2026-02-05','2026-02-04 09:41:25','2026-02-04 09:41:25',NULL);
/*!40000 ALTER TABLE `release_plans` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `statistic_data`
--

DROP TABLE IF EXISTS `statistic_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistic_data` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `indicator_id` bigint(20) unsigned NOT NULL,
  `year` int(11) NOT NULL,
  `region` varchar(255) NOT NULL,
  `value` decimal(15,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `statistic_data_indicator_id_foreign` (`indicator_id`),
  CONSTRAINT `statistic_data_indicator_id_foreign` FOREIGN KEY (`indicator_id`) REFERENCES `statistic_indicators` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_data`
--

LOCK TABLES `statistic_data` WRITE;
/*!40000 ALTER TABLE `statistic_data` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `statistic_data` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `statistic_indicators`
--

DROP TABLE IF EXISTS `statistic_indicators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistic_indicators` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `subsubject_id` bigint(20) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `statistic_indicators_subsubject_id_foreign` (`subsubject_id`),
  CONSTRAINT `statistic_indicators_subsubject_id_foreign` FOREIGN KEY (`subsubject_id`) REFERENCES `statistic_subsubjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_indicators`
--

LOCK TABLES `statistic_indicators` WRITE;
/*!40000 ALTER TABLE `statistic_indicators` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `statistic_indicators` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `statistic_subjects`
--

DROP TABLE IF EXISTS `statistic_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistic_subjects` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `statistic_subjects_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_subjects`
--

LOCK TABLES `statistic_subjects` WRITE;
/*!40000 ALTER TABLE `statistic_subjects` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `statistic_subjects` VALUES
(1,'Statistik Demografi dan Sosial','demografi-sosial','2026-01-31 22:28:42','2026-01-31 22:28:42'),
(2,'Statistik Ekonomi','statistik-ekonomi','2026-02-02 15:15:43','2026-02-02 15:15:43'),
(3,'Statistik Lingkungan Hidup dan Multi-domain','statistik-lingkungan-hidup-dan-multi-domain','2026-02-02 15:15:43','2026-02-02 15:15:43');
/*!40000 ALTER TABLE `statistic_subjects` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `statistic_subsubjects`
--

DROP TABLE IF EXISTS `statistic_subsubjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistic_subsubjects` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `statistic_subsubjects_subject_id_foreign` (`subject_id`),
  CONSTRAINT `statistic_subsubjects_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `statistic_subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_subsubjects`
--

LOCK TABLES `statistic_subsubjects` WRITE;
/*!40000 ALTER TABLE `statistic_subsubjects` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `statistic_subsubjects` VALUES
(1,1,'Kependudukan dan Migrasi','kependudukan-dan-migrasi','2026-01-31 22:28:42','2026-01-31 22:28:42'),
(2,1,'Tenaga Kerja','tenaga-kerja','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(3,1,'Pendidikan','pendidikan','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(4,1,'Kesehatan','kesehatan','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(5,1,'Konsumsi dan Pendapatan','konsumsi-dan-pendapatan','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(6,1,'Perlindungan Sosial','perlindungan-sosial','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(7,1,'Pemukiman dan Perumahan','pemukiman-dan-perumahan','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(8,1,'Hukum dan Kriminal','hukum-dan-kriminal','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(9,1,'Budaya','budaya','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(10,1,'Aktivitas Politik dan Komunitas Lainnya','aktivitas-politik-dan-komunitas-lainnya','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(11,1,'Penggunaan Waktu','penggunaan-waktu','2026-02-02 15:22:20','2026-02-02 15:22:20'),
(12,2,'Statistik Makroekonomi','statistik-makroekonomi','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(13,2,'Neraca Ekonomi','neraca-ekonomi','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(14,2,'Statistik Bisnis','statistik-bisnis','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(15,2,'Statistik Sektoral','statistik-sektoral','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(16,2,'Keuangan Pemerintah, Fiskal dan Statistik Sektor Publik','keuangan-pemerintah-fiskal-dan-statistik-sektor-publik','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(17,2,'Perdagangan Internasional dan Neraca Pembayaran','perdagangan-internasional-dan-neraca-pembayaran','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(18,2,'Harga-Harga','harga-harga','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(19,2,'Biaya Tenaga Kerja','biaya-tenaga-kerja','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(20,2,'Ilmu Pengetahuan, Teknologi, dan Inovasi','ilmu-pengetahuan-teknologi-dan-inovasi','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(21,2,'Pertanian, Kehutanan, Perikanan','pertanian-kehutanan-perikanan','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(22,2,'Energi','energi','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(23,2,'Pertambangan, Manufaktur, Konstruksi','pertambangan-manufaktur-konstruksi','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(24,2,'Transportasi','transportasi','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(25,2,'Pariwisata','pariwisata','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(26,2,'Perbankan, Asuransi dan Finansial','perbankan-asuransi-dan-finansial','2026-02-02 15:26:43','2026-02-02 15:26:43'),
(27,3,'Lingkungan','lingkungan','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(28,3,'Statistik Regional dan Statistik Area Kecil','statistik-regional-dan-statistik-area-kecil','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(29,3,'Statistik dan Indikator Multi-domain','statistik-dan-indikator-multi-domain','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(30,3,'Buku Tahunan dan Ringkasan Sejenis','buku-tahunan-dan-ringkasan-sejenis','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(31,3,'Kondisi Tempat Tinggal, Kemiskinan, dan Permasalahan Sosial Lintas Sektor','kondisi-tempat-tinggal-kemiskinan-dan-permasalahan-sosial-lintas-sektor','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(32,3,'Gender dan Kelompok Populasi Khusus','gender-dan-kelompok-populasi-khusus','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(33,3,'Masyarakat Informasi','masyarakat-informasi','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(34,3,'Globalisasi','globalisasi','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(35,3,'Indikator Milenium Development Goals (MDGs)','indikator-millenium-development-goals-mdgs','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(36,3,'Perkembangan Berkelanjutan','perkembangan-berkelanjutan','2026-02-02 15:26:58','2026-02-02 15:26:58'),
(37,3,'Kewiraswastaan','kewiraswastaan','2026-02-02 15:26:58','2026-02-02 15:26:58');
/*!40000 ALTER TABLE `statistic_subsubjects` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `statistic_table_columns`
--

DROP TABLE IF EXISTS `statistic_table_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistic_table_columns` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `table_id` bigint(20) unsigned NOT NULL,
  `key_name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `order_index` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `statistic_table_columns_table_id_key_name_unique` (`table_id`,`key_name`),
  CONSTRAINT `statistic_table_columns_table_id_foreign` FOREIGN KEY (`table_id`) REFERENCES `statistic_tables` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_table_columns`
--

LOCK TABLES `statistic_table_columns` WRITE;
/*!40000 ALTER TABLE `statistic_table_columns` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `statistic_table_columns` VALUES
(4,3,'male','Laki-laki','jiwa',1,'2026-02-02 15:33:38','2026-02-02 15:33:38'),
(5,3,'female','Perempuan','jiwa',2,'2026-02-02 15:33:38','2026-02-02 15:33:38'),
(6,3,'total','Laki + Perempuan','jiwa',3,'2026-02-02 15:33:38','2026-02-02 15:33:38'),
(11,1,'age_group','Kelompok Umur','',1,NULL,NULL),
(12,1,'penduduk_male','Penduduk (Laki-Laki)','Ribu',2,NULL,NULL),
(13,1,'penduduk_female','Penduduk (Perempuan)','Ribu',3,NULL,NULL),
(14,1,'penduduk_total','Penduduk (Laki-Laki + Perempuan)','Ribu',4,NULL,NULL),
(15,2,'bulan','Bulan / Month','bulan',1,NULL,NULL);
/*!40000 ALTER TABLE `statistic_table_columns` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `statistic_table_rows`
--

DROP TABLE IF EXISTS `statistic_table_rows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistic_table_rows` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `table_id` bigint(20) unsigned NOT NULL,
  `row_label` varchar(255) NOT NULL,
  `row_order` int(11) NOT NULL DEFAULT 0,
  `data` longtext CHARACTER SET utf8mb4,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `statistic_table_rows_table_id_foreign` (`table_id`),
  CONSTRAINT `statistic_table_rows_table_id_foreign` FOREIGN KEY (`table_id`) REFERENCES `statistic_tables` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_table_rows`
--

LOCK TABLES `statistic_table_rows` WRITE;
/*!40000 ALTER TABLE `statistic_table_rows` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `statistic_table_rows` VALUES
(6,3,'Kabupaten Bondowoso',1,'{\"male\":382226,\"female\":393925,\"total\":776151}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(7,3,'Maesan',2,'{\"male\":23858,\"female\":24218,\"total\":48076}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(8,3,'Grujugan',3,'{\"male\":18438,\"female\":18676,\"total\":37114}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(9,3,'Tamanan',4,'{\"male\":19015,\"female\":19399,\"total\":38414}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(10,3,'Jambesari DS',5,'{\"male\":17884,\"female\":18202,\"total\":36086}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(11,3,'Pujer',6,'{\"male\":19672,\"female\":20554,\"total\":40226}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(12,3,'Tlogosari',7,'{\"male\":22642,\"female\":23062,\"total\":45704}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(13,3,'Sukosari',8,'{\"male\":7560,\"female\":7967,\"total\":15527}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(14,3,'Sumber Wringin',9,'{\"male\":16856,\"female\":17375,\"total\":34231}','2026-02-02 15:34:33','2026-02-02 15:34:33'),
(17,1,'0-4',1,'{\"age_group\":\"0-4\",\"penduduk_male\":29.4, \"penduduk_female\":28.2, \"penduduk_total\":57.6}',NULL,NULL),
(18,1,'5-9',2,'{\"age_group\":\"5-9\",\"penduduk_male\":26.2, \"penduduk_female\":25.5, \"penduduk_total\":51.8}',NULL,NULL),
(19,1,'5-9',2,'{\"age_group\":\"5-9\",\"penduduk_male\":26.2, \"penduduk_female\":25.5, \"penduduk_total\":51.8}',NULL,NULL),
(20,1,'10-14',3,'{\"age_group\":\"10-14\",\"penduduk_male\":25.7, \"penduduk_female\":25.0, \"penduduk_total\":50.7}',NULL,NULL),
(21,1,'15-19',3,'{\"age_group\":\"15-19\",\"penduduk_male\":27.4, \"penduduk_female\":26.1, \"penduduk_total\":53.5}',NULL,NULL),
(22,1,'20-24',3,'{\"age_group\":\"20-24\",\"penduduk_male\":29.3, \"penduduk_female\":28.7, \"penduduk_total\":58.0}',NULL,NULL),
(23,1,'25-29',3,'{\"age_group\":\"25-29\",\"penduduk_male\":29.3, \"penduduk_female\":28.8, \"penduduk_total\":58.1}',NULL,NULL),
(24,1,'30-34',3,'{\"age_group\":\"30-34\",\"penduduk_male\":28.3, \"penduduk_female\":29.4, \"penduduk_total\":57.7}',NULL,NULL),
(25,1,'35-39',3,'{\"age_group\":\"35-39\",\"penduduk_male\":28.0, \"penduduk_female\":28.5, \"penduduk_total\":56.5}',NULL,NULL),
(26,1,'40-44',3,'{\"age_group\":\"40-44\",\"penduduk_male\":27.3, \"penduduk_female\":28.1, \"penduduk_total\":55.4}',NULL,NULL),
(27,1,'45-49',3,'{\"age_group\":\"45-49\",\"penduduk_male\":27.8, \"penduduk_female\":29.1, \"penduduk_total\":56.9}',NULL,NULL),
(28,1,'50-54',3,'{\"age_group\":\"50-54\",\"penduduk_male\":26.4, \"penduduk_female\":26.9, \"penduduk_total\":53.3}',NULL,NULL),
(29,1,'55-59',3,'{\"age_group\":\"55-59\",\"penduduk_male\":24.7, \"penduduk_female\":25.6, \"penduduk_total\":50.3}',NULL,NULL),
(30,1,'60-64',3,'{\"age_group\":\"60-64\",\"penduduk_male\":20.8, \"penduduk_female\":20.9, \"penduduk_total\":41.7}',NULL,NULL),
(31,1,'65-69',3,'{\"age_group\":\"65-69\",\"penduduk_male\":16.8, \"penduduk_female\":18.4, \"penduduk_total\":35.2}',NULL,NULL),
(32,1,'70-74',3,'{\"age_group\":\"70-74\",\"penduduk_male\":11.5, \"penduduk_female\":13.6, \"penduduk_total\":25.1}',NULL,NULL),
(33,1,'75+',3,'{\"age_group\":\"75+\",\"penduduk_male\":11.6, \"penduduk_female\":18.9, \"penduduk_total\":30.5}',NULL,NULL),
(34,1,'Jumlah/ Total',3,'{\"age_group\":\"Jumlah/ Total\",\"penduduk_male\":390.6, \"penduduk_female\":401.7, \"penduduk_total\":792.3}',NULL,NULL);
/*!40000 ALTER TABLE `statistic_table_rows` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `statistic_tables`
--

DROP TABLE IF EXISTS `statistic_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `statistic_tables` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `subsubject_id` bigint(20) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `last_updated` date DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `statistic_tables_subsubject_id_foreign` (`subsubject_id`),
  CONSTRAINT `statistic_tables_subsubject_id_foreign` FOREIGN KEY (`subsubject_id`) REFERENCES `statistic_subsubjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_tables`
--

LOCK TABLES `statistic_tables` WRITE;
/*!40000 ALTER TABLE `statistic_tables` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `statistic_tables` VALUES
(1,1,'Jumlah Penduduk Menurut Kelompok Umur dan Jenis Kelamin di Kabupaten Bondowoso, 2021','Tabel ini menyajikan jumlah penduduk menurut kelompok umur dan jenis kelamin.','2021-12-31','BPS Kabupaten Bondowoso','2026-01-31 22:28:42','2026-01-31 22:28:42'),
(2,1,'Faktor Penyebab Perceraian menurut Bulan di Kabupaten Bondowoso, 2018','Data faktor penyebab perceraian per bulan','2018-12-31','BPS Kabupaten Bondowoso','2026-02-02 15:19:52','2026-02-02 15:19:52'),
(3,1,'Hasil Sensus Penduduk 2020 per Kecamatan (Jiwa)','Hasil sensus penduduk per kecamatan','2020-12-31','BPS Kabupaten Bondowoso','2026-02-02 15:19:52','2026-02-02 15:19:52'),
(4,1,'Hasil Sensus Penduduk Kabupaten Bondowoso','Ringkasan hasil sensus penduduk','2020-12-31','BPS Kabupaten Bondowoso','2026-02-02 15:19:52','2026-02-02 15:19:52'),
(5,1,'Jumlah Nikah dan Rujuk di Kabupaten Bondowoso, 2018','Data nikah dan rujuk','2018-12-31','BPS Kabupaten Bondowoso','2026-02-02 15:19:52','2026-02-02 15:19:52');
/*!40000 ALTER TABLE `statistic_tables` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-02-09 16:28:24
