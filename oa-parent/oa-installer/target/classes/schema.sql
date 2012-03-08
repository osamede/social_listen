-- MySQL dump 10.13  Distrib 5.1.30, for apple-darwin9.5.2 (i386)
--
-- Host: localhost    Database: openapplicant
-- ------------------------------------------------------
-- Server version	5.1.30
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_creation_token`
--

DROP TABLE IF EXISTS `account_creation_token`;

CREATE TABLE `account_creation_token` (
  `id` bigint(20) NOT NULL,
  `city` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `contact_name` varchar(255) DEFAULT NULL,
  `contact_phone` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `zip_code` varchar(255) DEFAULT NULL,
  `company` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK98EF4CEBF8A52930` (`company`),
  KEY `FK98EF4CEB2899FC56` (`id`),
  CONSTRAINT `FK98EF4CEB2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FK98EF4CEBF8A52930` FOREIGN KEY (`company`) REFERENCES `company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `account_creation_token`
--

LOCK TABLES `account_creation_token` WRITE;
/*!40000 ALTER TABLE `account_creation_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_creation_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attachment_indexable`
--

DROP TABLE IF EXISTS `attachment_indexable`;


CREATE TABLE `attachment_indexable` (
  `attachment_id` bigint(20) NOT NULL,
  `string_content` longtext,
  PRIMARY KEY (`attachment_id`),
  FULLTEXT KEY `idx_attachment_fulltext` (`string_content`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


--
-- Dumping data for table `attachment_indexable`
--

LOCK TABLES `attachment_indexable` WRITE;
/*!40000 ALTER TABLE `attachment_indexable` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachment_indexable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate`
--

DROP TABLE IF EXISTS `candidate`;


CREATE TABLE `candidate` (
  `id` bigint(20) NOT NULL,
  `address` text,
  `email` varchar(255) DEFAULT NULL,
  `last_active_status` int(11) DEFAULT NULL,
  `match_score` decimal(19,2) DEFAULT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `middlename` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `company` bigint(20) NOT NULL,
  `cover_letter` bigint(20) DEFAULT NULL,
  `last_sitting` bigint(20) DEFAULT NULL,
  `resume` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`,`company`),
  KEY `FK1E519583A3E4D525` (`last_sitting`),
  KEY `FK1E519583CC9CA5A1` (`cover_letter`),
  KEY `FK1E519583F8A52930` (`company`),
  KEY `FK1E5195837C330164` (`resume`),
  KEY `FK1E5195832899FC56` (`id`),
  CONSTRAINT `FK1E5195832899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FK1E5195837C330164` FOREIGN KEY (`resume`) REFERENCES `file_attachment` (`id`),
  CONSTRAINT `FK1E519583A3E4D525` FOREIGN KEY (`last_sitting`) REFERENCES `sitting` (`id`),
  CONSTRAINT `FK1E519583CC9CA5A1` FOREIGN KEY (`cover_letter`) REFERENCES `file_attachment` (`id`),
  CONSTRAINT `FK1E519583F8A52930` FOREIGN KEY (`company`) REFERENCES `company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `candidate`
--

LOCK TABLES `candidate` WRITE;
/*!40000 ALTER TABLE `candidate` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_note`
--

DROP TABLE IF EXISTS `candidate_note`;


CREATE TABLE `candidate_note` (
  `candidate` bigint(20) NOT NULL,
  `note_id` bigint(20) NOT NULL,
  UNIQUE KEY `note_id` (`note_id`),
  KEY `FK535CCD2E490EA5BC` (`candidate`),
  KEY `FK535CCD2E97114004` (`note_id`),
  CONSTRAINT `FK535CCD2E97114004` FOREIGN KEY (`note_id`) REFERENCES `note` (`id`),
  CONSTRAINT `FK535CCD2E490EA5BC` FOREIGN KEY (`candidate`) REFERENCES `candidate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `candidate_note`
--

LOCK TABLES `candidate_note` WRITE;
/*!40000 ALTER TABLE `candidate_note` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_note` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_phone_numbers`
--

DROP TABLE IF EXISTS `candidate_phone_numbers`;


CREATE TABLE `candidate_phone_numbers` (
  `candidate` bigint(20) NOT NULL,
  `number` varchar(255) NOT NULL,
  `mapkey` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`candidate`,`mapkey`),
  KEY `FK52862ABD490EA5BC` (`candidate`),
  CONSTRAINT `FK52862ABD490EA5BC` FOREIGN KEY (`candidate`) REFERENCES `candidate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `candidate_phone_numbers`
--

LOCK TABLES `candidate_phone_numbers` WRITE;
/*!40000 ALTER TABLE `candidate_phone_numbers` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_phone_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_search`
--

DROP TABLE IF EXISTS `candidate_search`;


CREATE TABLE `candidate_search` (
  `type` varchar(31) NOT NULL,
  `id` bigint(20) NOT NULL,
  `search_string` varchar(255) DEFAULT NULL,
  `dates_string` varchar(255) DEFAULT NULL,
  `name_string` varchar(255) DEFAULT NULL,
  `skills_string` varchar(255) DEFAULT NULL,
  `user` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKF75123E418620320` (`user`),
  KEY `FKF75123E42899FC56` (`id`),
  CONSTRAINT `FKF75123E42899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FKF75123E418620320` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `candidate_search`
--

LOCK TABLES `candidate_search` WRITE;
/*!40000 ALTER TABLE `candidate_search` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_search` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_work_flow_event`
--

DROP TABLE IF EXISTS `candidate_work_flow_event`;


CREATE TABLE `candidate_work_flow_event` (
  `type` varchar(31) NOT NULL,
  `id` bigint(20) NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  `sitting_score` decimal(19,2) DEFAULT NULL,
  `candidate` bigint(20) DEFAULT NULL,
  `user` bigint(20) DEFAULT NULL,
  `exam_link` bigint(20) DEFAULT NULL,
  `note` bigint(20) DEFAULT NULL,
  `cover_letter` bigint(20) DEFAULT NULL,
  `resume` bigint(20) DEFAULT NULL,
  `sitting` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKC4E26B7B18620320` (`user`),
  KEY `FKC4E26B7B490EA5BC` (`candidate`),
  KEY `FKC4E26B7B81BB91CE` (`sitting`),
  KEY `FKC4E26B7BCC9CA5A1` (`cover_letter`),
  KEY `FKC4E26B7BD9421F4C` (`exam_link`),
  KEY `FKC4E26B7B6368A03D` (`exam_link`),
  KEY `FKC4E26B7B185B8B6E` (`note`),
  KEY `FKC4E26B7B7C330164` (`resume`),
  KEY `FKC4E26B7B2899FC56` (`id`),
  CONSTRAINT `FKC4E26B7B2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FKC4E26B7B185B8B6E` FOREIGN KEY (`note`) REFERENCES `note` (`id`),
  CONSTRAINT `FKC4E26B7B18620320` FOREIGN KEY (`user`) REFERENCES `user` (`id`),
  CONSTRAINT `FKC4E26B7B490EA5BC` FOREIGN KEY (`candidate`) REFERENCES `candidate` (`id`),
  CONSTRAINT `FKC4E26B7B6368A03D` FOREIGN KEY (`exam_link`) REFERENCES `exam_link` (`id`),
  CONSTRAINT `FKC4E26B7B7C330164` FOREIGN KEY (`resume`) REFERENCES `file_attachment` (`id`),
  CONSTRAINT `FKC4E26B7B81BB91CE` FOREIGN KEY (`sitting`) REFERENCES `sitting` (`id`),
  CONSTRAINT `FKC4E26B7BCC9CA5A1` FOREIGN KEY (`cover_letter`) REFERENCES `file_attachment` (`id`),
  CONSTRAINT `FKC4E26B7BD9421F4C` FOREIGN KEY (`exam_link`) REFERENCES `exam_link` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `candidate_work_flow_event`
--

LOCK TABLES `candidate_work_flow_event` WRITE;
/*!40000 ALTER TABLE `candidate_work_flow_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate_work_flow_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;


CREATE TABLE `company` (
  `id` bigint(20) NOT NULL,
  `completion_text` longtext NOT NULL,
  `email_alias` varchar(255) NOT NULL,
  `host_name` varchar(255) NOT NULL,
  `host_port` int(11) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `proxy_name` varchar(255) NOT NULL,
  `proxy_port` int(11) NOT NULL,
  `welcome_text` longtext NOT NULL,
  `auto_invite_email_template` bigint(20) NOT NULL,
  `exam_invite_email_template` bigint(20) NOT NULL,
  `link_to_all_exams` bigint(20) NOT NULL,
  `profile` bigint(20) NOT NULL,
  `reject_candidate_email_template` bigint(20) NOT NULL,
  `request_resume_email_template` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_alias` (`email_alias`),
  UNIQUE KEY `host_name` (`host_name`),
  UNIQUE KEY `proxy_name` (`proxy_name`),
  UNIQUE KEY `auto_invite_email_template` (`auto_invite_email_template`),
  UNIQUE KEY `exam_invite_email_template` (`exam_invite_email_template`),
  UNIQUE KEY `reject_candidate_email_template` (`reject_candidate_email_template`),
  UNIQUE KEY `link_to_all_exams` (`link_to_all_exams`),
  UNIQUE KEY `request_resume_email_template` (`request_resume_email_template`),
  UNIQUE KEY `profile` (`profile`),
  KEY `FK38A73C7DEF6CA9A7` (`reject_candidate_email_template`),
  KEY `FK38A73C7DBE910A75` (`request_resume_email_template`),
  KEY `FK38A73C7D2824CB9A` (`link_to_all_exams`),
  KEY `FK38A73C7D6273C388` (`profile`),
  KEY `FK38A73C7D64BC8C05` (`auto_invite_email_template`),
  KEY `FK38A73C7DADEBA205` (`exam_invite_email_template`),
  KEY `FK38A73C7D2899FC56` (`id`),
  CONSTRAINT `FK38A73C7D2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FK38A73C7D2824CB9A` FOREIGN KEY (`link_to_all_exams`) REFERENCES `exam_link` (`id`),
  CONSTRAINT `FK38A73C7D6273C388` FOREIGN KEY (`profile`) REFERENCES `profile` (`id`),
  CONSTRAINT `FK38A73C7D64BC8C05` FOREIGN KEY (`auto_invite_email_template`) REFERENCES `email_template` (`id`),
  CONSTRAINT `FK38A73C7DADEBA205` FOREIGN KEY (`exam_invite_email_template`) REFERENCES `email_template` (`id`),
  CONSTRAINT `FK38A73C7DBE910A75` FOREIGN KEY (`request_resume_email_template`) REFERENCES `email_template` (`id`),
  CONSTRAINT `FK38A73C7DEF6CA9A7` FOREIGN KEY (`reject_candidate_email_template`) REFERENCES `email_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'Thank you for taking the exam.\nIt usually takes a us few days to process the results, then we will get back to you.','resumes','localhost',8080,NULL,'Test','localhost',8080,'The following exam will present you with a series of questions designed to measure your problem solving abilities. Not all of the questions are timed, but that does not mean you can google around for the answers. Be sure to watch the timer in the upper-right corner.\n\nGet a pencil, scratch paper, glass of water, and click \'start\' when you are ready to begin. The whole exam should take somewhere between 20 and 60 minutes. Good luck!',2,3,4,6,7,8);
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_template`
--

DROP TABLE IF EXISTS `email_template`;


CREATE TABLE `email_template` (
  `type` varchar(31) NOT NULL,
  `id` bigint(20) NOT NULL,
  `body` longtext,
  `from_address` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6C0301BD2899FC56` (`id`),
  CONSTRAINT `FK6C0301BD2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `email_template`
--

LOCK TABLES `email_template` WRITE;
/*!40000 ALTER TABLE `email_template` DISABLE KEYS */;
INSERT INTO `email_template` VALUES ('AutoInviteEmailTemplate',2,'Dear <<First Name>>,\n\nThank you for taking the time to submit your resume with <<Company Name>> which is the first step in the employment process.\n\nThe next step in the process is to complete an online assessment, which can be accessed at the following link:\n\n<<Exam Link>>\n\nFollowing your completion of the assessment, we will notify you and outline the remaining steps in the employment process.\n\nSincerely,\n\n<<Company Name>>','noreply@beta.openapplicant.org','Open Applicant Exam Invitation'),('ExamInviteEmailTemplate',3,'Dear <<First Name>>,\n\nThank you for taking the time to submit your resume with <<Company Name>> which is the first step in the employment process.\n\nThe next step in the process is to complete an online assessment.  We have prepared the assessment which can be accessed at the following link:\n\n<<Exam Link>>\n\nFollowing your completion of the assessment, we will notify you and outline the remaining steps in the employment process.\n\nSincerely,\n\n<<Company Name>>','noreply@beta.openapplicant.org','Open Applicant Exam Invitation'),('RejectCandidateEmailTemplate',7,'Dear <<First Name>>,\n\nThank you for taking the time to submit your resume with <<Company Name>>.\n\nWe regret to inform you that at this time you will not be moving forward in the candidate selection process.\n\nWe encourage you to check back frequently for new positions as our job postings get updated regularly.\n\nSincerely,\n\n<<Company Name>>','noreply@beta.openapplicant.org','Open Applicant Resume Submission'),('RequestResumeEmailTemplate',8,'Dear <<First Name>>,\n\nThank you for taking the time to submit your resume with <<Company Name>> which is the first step in the employment process.\n\nTo continue the employment process, please submit your resume for review.  You can do so by replying directly to this email and attaching a resume and cover letter (optional).\n\nSincerely,\n\n<<Company Name>>','noreply@beta.openapplicant.org','Open Applicant Resume Request');
/*!40000 ALTER TABLE `email_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entity_info`
--

DROP TABLE IF EXISTS `entity_info`;


CREATE TABLE `entity_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guid` varchar(36) NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;


--
-- Dumping data for table `entity_info`
--

LOCK TABLES `entity_info` WRITE;
/*!40000 ALTER TABLE `entity_info` DISABLE KEYS */;
INSERT INTO `entity_info` VALUES (1,'ab0a9930-91f3-441d-b786-19ed9c6242c2','2009-04-19 22:42:04'),(2,'5698a64e-e5d7-47b9-8608-7b17559040f4','2009-04-19 22:42:04'),(3,'bc77c328-28e0-4f33-8b08-d8c42b8fe8b8','2009-04-19 22:42:04'),(4,'ddd45abe-339d-4472-852d-5f48c43b478c','2009-04-19 22:42:04'),(5,'96645d16-ede4-4e06-afa0-4a2ebdede537','2009-04-19 22:42:04'),(6,'ea8855df-f5bd-4966-8d83-3b56f47f9748','2009-04-19 22:42:04'),(7,'0d33fd44-f2b3-4225-be61-ec006c52ab76','2009-04-19 22:42:04'),(8,'043c6709-55fa-4e7f-b42d-52484abd7c6d','2009-04-19 22:42:04'),(9,'ec5811bc-8954-45ea-bc67-18f227e48ca2','2009-04-19 22:42:04'),(10,'f3eb8a64-1c28-4ce6-8667-a52b0866bd5b','2009-04-19 22:42:04'),(11,'35c7665e-eb9c-41d6-b9af-ecbfff7e5f56','2009-04-19 22:42:04'),(12,'dd50594a-cb19-43e5-ab7b-2843b2a241bb','2009-04-19 22:42:04'),(13,'71bd8891-fba2-48db-840e-db0a0dc8f2d5','2009-04-19 22:42:04'),(14,'b7f5f71e-b99b-4a40-8b9f-8fa9c3bbddd9','2009-04-19 22:42:04'),(15,'7f8055ea-81ec-4e2a-9513-08f896bbdbe3','2009-04-19 22:42:04'),(16,'5608ef23-9ac5-45ed-9ba5-119c02ba72da','2009-04-19 22:42:04'),(17,'de7e1620-33ae-4b31-a5ce-fab2d3166474','2009-04-19 22:42:04'),(18,'c99686be-f0dc-485c-a727-fc348aaef4f1','2009-04-19 22:42:04'),(19,'1230ff73-b3ac-4cd1-8cdf-c6d8ba406582','2009-04-19 22:42:04'),(20,'da3de3d7-a4ef-4d14-9f9f-c38204a3ed46','2009-04-19 22:42:04'),(21,'189ee933-beb1-48fd-b00d-c26ee36822bf','2009-04-19 22:42:04');
/*!40000 ALTER TABLE `entity_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam`
--

DROP TABLE IF EXISTS `exam`;


CREATE TABLE `exam` (
  `id` bigint(20) NOT NULL,
  `active` bit(1) NOT NULL DEFAULT '',
  `artifact_id` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `facilitate_email` bit(1) NOT NULL DEFAULT '\0',
  `frozen` bit(1) NOT NULL,
  `genre` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `company` bigint(20) NOT NULL,
  `next_version` bigint(20) DEFAULT NULL,
  `previous_version` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2FB81FF8A52930` (`company`),
  KEY `FK2FB81F71697B39` (`previous_version`),
  KEY `FK2FB81F77A78F35` (`next_version`),
  KEY `FK2FB81F2899FC56` (`id`),
  CONSTRAINT `FK2FB81F2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FK2FB81F71697B39` FOREIGN KEY (`previous_version`) REFERENCES `exam` (`id`),
  CONSTRAINT `FK2FB81F77A78F35` FOREIGN KEY (`next_version`) REFERENCES `exam` (`id`),
  CONSTRAINT `FK2FB81FF8A52930` FOREIGN KEY (`company`) REFERENCES `company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `exam`
--

LOCK TABLES `exam` WRITE;
/*!40000 ALTER TABLE `exam` DISABLE KEYS */;
INSERT INTO `exam` VALUES (10,'','f8ab4f2b-c466-4b47-b61f-ffab0851c538','java test','\0','\0','java','Every Type of Question',1,NULL,NULL),(14,'','7a5bca1b-3d07-4c5e-9f09-b1fa4445fa6f','Basic Programming Test','\0','\0','Programming','Programming',1,NULL,NULL);
/*!40000 ALTER TABLE `exam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_link`
--

DROP TABLE IF EXISTS `exam_link`;


CREATE TABLE `exam_link` (
  `kind` varchar(31) NOT NULL,
  `id` bigint(20) NOT NULL,
  `description` varchar(255) NOT NULL,
  `multi_use` bit(1) NOT NULL DEFAULT '\0',
  `used` bit(1) NOT NULL DEFAULT '\0',
  `company` bigint(20) DEFAULT NULL,
  `exams_strategy` bigint(20) NOT NULL,
  `candidate` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `exams_strategy` (`exams_strategy`),
  KEY `FKFB36EC1A490EA5BC` (`candidate`),
  KEY `FKFB36EC1AD0FDF5BB` (`exams_strategy`),
  KEY `FKFB36EC1AF8A52930` (`company`),
  KEY `FKFB36EC1A2899FC56` (`id`),
  CONSTRAINT `FKFB36EC1A2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FKFB36EC1A490EA5BC` FOREIGN KEY (`candidate`) REFERENCES `candidate` (`id`),
  CONSTRAINT `FKFB36EC1AD0FDF5BB` FOREIGN KEY (`exams_strategy`) REFERENCES `exams_strategy` (`id`),
  CONSTRAINT `FKFB36EC1AF8A52930` FOREIGN KEY (`company`) REFERENCES `company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `exam_link`
--

LOCK TABLES `exam_link` WRITE;
/*!40000 ALTER TABLE `exam_link` DISABLE KEYS */;
INSERT INTO `exam_link` VALUES ('OpenExamLink',4,'','','\0',1,5,NULL);
/*!40000 ALTER TABLE `exam_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_questions`
--

DROP TABLE IF EXISTS `exam_questions`;


CREATE TABLE `exam_questions` (
  `exam` bigint(20) NOT NULL,
  `questions` bigint(20) NOT NULL,
  `ordinal` int(11) NOT NULL,
  PRIMARY KEY (`exam`,`ordinal`),
  KEY `FK76A1992DE36DBF31` (`questions`),
  KEY `FK76A1992D18539BC8` (`exam`),
  CONSTRAINT `FK76A1992D18539BC8` FOREIGN KEY (`exam`) REFERENCES `exam` (`id`),
  CONSTRAINT `FK76A1992DE36DBF31` FOREIGN KEY (`questions`) REFERENCES `question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `exam_questions`
--

LOCK TABLES `exam_questions` WRITE;
/*!40000 ALTER TABLE `exam_questions` DISABLE KEYS */;
INSERT INTO `exam_questions` VALUES (10,11,1),(10,12,2),(10,13,3),(14,15,1),(14,16,2),(14,17,3),(14,18,4),(14,19,5),(14,20,6),(14,21,7);
/*!40000 ALTER TABLE `exam_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exams_strategy`
--

DROP TABLE IF EXISTS `exams_strategy`;


CREATE TABLE `exams_strategy` (
  `kind` varchar(31) NOT NULL,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK668E031E2899FC56` (`id`),
  CONSTRAINT `FK668E031E2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `exams_strategy`
--

LOCK TABLES `exams_strategy` WRITE;
/*!40000 ALTER TABLE `exams_strategy` DISABLE KEYS */;
INSERT INTO `exams_strategy` VALUES ('DynamicExamsStrategy',5);
/*!40000 ALTER TABLE `exams_strategy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exams_strategy_exams`
--

DROP TABLE IF EXISTS `exams_strategy_exams`;


CREATE TABLE `exams_strategy_exams` (
  `exams_strategy` bigint(20) NOT NULL,
  `exam_id` bigint(20) NOT NULL,
  KEY `FK519E63D37E1AC16D` (`exams_strategy`),
  KEY `FK519E63D3C948B4E4` (`exam_id`),
  CONSTRAINT `FK519E63D3C948B4E4` FOREIGN KEY (`exam_id`) REFERENCES `exam` (`id`),
  CONSTRAINT `FK519E63D37E1AC16D` FOREIGN KEY (`exams_strategy`) REFERENCES `exams_strategy` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `exams_strategy_exams`
--

LOCK TABLES `exams_strategy_exams` WRITE;
/*!40000 ALTER TABLE `exams_strategy_exams` DISABLE KEYS */;
/*!40000 ALTER TABLE `exams_strategy_exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_attachment`
--

DROP TABLE IF EXISTS `file_attachment`;


CREATE TABLE `file_attachment` (
  `type` varchar(31) NOT NULL,
  `id` bigint(20) NOT NULL,
  `content` longblob NOT NULL,
  `file_type` varchar(255) NOT NULL,
  `string_content` longtext NOT NULL,
  `screening_score` decimal(19,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKE596B3C62899FC56` (`id`),
  CONSTRAINT `FKE596B3C62899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `file_attachment`
--

LOCK TABLES `file_attachment` WRITE;
/*!40000 ALTER TABLE `file_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_attachment` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@CHARACTER_SET_CLIENT */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger search_hack
after insert on file_attachment
for each row
  insert into attachment_indexable (attachment_id,string_content) values (NEW.id, NEW.string_content)
    on duplicate key update string_content=NEW.string_content */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@CHARACTER_SET_CLIENT */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger search_hack_update
after update on file_attachment
for each row
  insert into attachment_indexable (attachment_id,string_content) values (NEW.id, NEW.string_content)
    on duplicate key update string_content=NEW.string_content */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `grade`
--

DROP TABLE IF EXISTS `grade`;


CREATE TABLE `grade` (
  `id` bigint(20) NOT NULL,
  `score` decimal(19,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5E0BFD72899FC56` (`id`),
  CONSTRAINT `FK5E0BFD72899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `grade`
--

LOCK TABLES `grade` WRITE;
/*!40000 ALTER TABLE `grade` DISABLE KEYS */;
/*!40000 ALTER TABLE `grade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grade_scores`
--

DROP TABLE IF EXISTS `grade_scores`;


CREATE TABLE `grade_scores` (
  `grade` bigint(20) NOT NULL,
  `score` decimal(19,2) NOT NULL,
  `mapkey` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`grade`,`mapkey`),
  KEY `FK480BA189F252C564` (`grade`),
  CONSTRAINT `FK480BA189F252C564` FOREIGN KEY (`grade`) REFERENCES `grade` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `grade_scores`
--

LOCK TABLES `grade_scores` WRITE;
/*!40000 ALTER TABLE `grade_scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `grade_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_events`
--

DROP TABLE IF EXISTS `login_events`;


CREATE TABLE `login_events` (
  `user` bigint(20) DEFAULT NULL,
  `login_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `login_events`
--

LOCK TABLES `login_events` WRITE;
/*!40000 ALTER TABLE `login_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `note`
--

DROP TABLE IF EXISTS `note`;


CREATE TABLE `note` (
  `id` bigint(20) NOT NULL,
  `body` longtext NOT NULL,
  `author` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK33AFF2C45838E0` (`author`),
  KEY `FK33AFF22899FC56` (`id`),
  CONSTRAINT `FK33AFF22899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FK33AFF2C45838E0` FOREIGN KEY (`author`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `note`
--

LOCK TABLES `note` WRITE;
/*!40000 ALTER TABLE `note` DISABLE KEYS */;
/*!40000 ALTER TABLE `note` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_recovery_token`
--

DROP TABLE IF EXISTS `password_recovery_token`;


CREATE TABLE `password_recovery_token` (
  `id` bigint(20) NOT NULL,
  `user` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK973FA2F318620320` (`user`),
  KEY `FK973FA2F32899FC56` (`id`),
  CONSTRAINT `FK973FA2F32899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FK973FA2F318620320` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `password_recovery_token`
--

LOCK TABLES `password_recovery_token` WRITE;
/*!40000 ALTER TABLE `password_recovery_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_recovery_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;


CREATE TABLE `profile` (
  `id` bigint(20) NOT NULL,
  `accept_resumes_by_email` bit(1) NOT NULL DEFAULT '\0',
  `candidate_emails_recipient` varchar(255) DEFAULT NULL,
  `daily_reports_recipient` varchar(255) DEFAULT NULL,
  `forward_candidate_emails` bit(1) NOT NULL DEFAULT '\0',
  `forward_daily_reports` bit(1) NOT NULL DEFAULT '\0',
  `forward_job_board_emails` bit(1) NOT NULL DEFAULT '\0',
  `job_board_emails_recipient` varchar(255) DEFAULT NULL,
  `max_reject_score` int(11) DEFAULT NULL,
  `min_invite_score` int(11) DEFAULT NULL,
  `solicit_resumes` bit(1) NOT NULL DEFAULT '\0',
  PRIMARY KEY (`id`),
  KEY `FKED8E89A92899FC56` (`id`),
  CONSTRAINT `FKED8E89A92899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `profile`
--

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
INSERT INTO `profile` VALUES (6,'\0','137f196f-1303-41bd-a17d-79859c2c82a4@gmail.com','f276087e-7247-47a0-9dce-6644c5becb71@gmail.com','\0','','','ff8e4346-9dcc-48d2-9534-91ef9e7ff04a@gmail.com',20,80,'\0');
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_job_boards`
--

DROP TABLE IF EXISTS `profile_job_boards`;


CREATE TABLE `profile_job_boards` (
  `profile` bigint(20) NOT NULL,
  `element` varchar(255) DEFAULT NULL,
  KEY `FK979369656273C388` (`profile`),
  CONSTRAINT `FK979369656273C388` FOREIGN KEY (`profile`) REFERENCES `profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `profile_job_boards`
--

LOCK TABLES `profile_job_boards` WRITE;
/*!40000 ALTER TABLE `profile_job_boards` DISABLE KEYS */;
INSERT INTO `profile_job_boards` VALUES (6,'www.craigslist.org'),(6,'www.dice.com'),(6,'www.monster.com');
/*!40000 ALTER TABLE `profile_job_boards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_keywords`
--

DROP TABLE IF EXISTS `profile_keywords`;


CREATE TABLE `profile_keywords` (
  `profile` bigint(20) NOT NULL,
  `element` int(11) DEFAULT NULL,
  `mapkey` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`profile`,`mapkey`),
  KEY `FK28CB15806273C388` (`profile`),
  CONSTRAINT `FK28CB15806273C388` FOREIGN KEY (`profile`) REFERENCES `profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `profile_keywords`
--

LOCK TABLES `profile_keywords` WRITE;
/*!40000 ALTER TABLE `profile_keywords` DISABLE KEYS */;
INSERT INTO `profile_keywords` VALUES (6,0,'java');
/*!40000 ALTER TABLE `profile_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;


CREATE TABLE `question` (
  `kind` varchar(31) NOT NULL,
  `id` bigint(20) NOT NULL,
  `artifact_id` varchar(255) NOT NULL,
  `frozen` bit(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `prompt` longtext NOT NULL,
  `time_allowed` int(11) DEFAULT NULL,
  `answer` longtext,
  `answer_index` int(11) DEFAULT NULL,
  `next_version` bigint(20) DEFAULT NULL,
  `previous_version` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKBA823BE6A6EE1574` (`previous_version`),
  KEY `FKBA823BE6AD2C2970` (`next_version`),
  KEY `FKBA823BE62899FC56` (`id`),
  CONSTRAINT `FKBA823BE62899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FKBA823BE6A6EE1574` FOREIGN KEY (`previous_version`) REFERENCES `question` (`id`),
  CONSTRAINT `FKBA823BE6AD2C2970` FOREIGN KEY (`next_version`) REFERENCES `question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES ('EssayQuestion',11,'40039e2a-6b41-4d05-8890-6595d805a796','\0','Fibonacci - Read','What does the following C code do?:\n\n<pre>int w = 10, x = 0, z = 0;\nint y = x++;\n\nfor ( ; w >= 0; w-- )\n{\nz = x + y;\nprintf( \"%i, \", y = x );\nx = z;\n}</pre>',15,'foo!',NULL,NULL,NULL),('CodeQuestion',12,'136e2fd5-a375-480a-b328-7e0c8281e2ff','\0','Byte to String','Write a Java or C/C++ function that takes in a 1-byte character and returns it as a string.',30,'foo!',NULL,NULL,NULL),('MultipleChoiceQuestion',13,'8b7d74fc-e818-43b0-b01e-30f706ac448f','\0','O of BinarySearch','What is the worst-case time complexity of sorting a given set of N numbers by building a binary tree search?',NULL,NULL,2,NULL,NULL),('CodeQuestion',15,'9bc16928-85e6-4299-a5e7-a6b712df70d2','\0','Byte to String','Write a Java or C/C++ function that takes in a 1-byte character and returns it as a string.',NULL,'foo!',NULL,NULL,NULL),('CodeQuestion',16,'bca21b32-2084-43b9-b508-582e590e442b','\0','Integer Swap','In Java or C/C++, swap the value of two integer variables.',NULL,'foo!',NULL,NULL,NULL),('CodeQuestion',17,'4119f272-290f-4bf3-840c-f2da0422e9d0','\0','Remove Non-Letters','Write a Java or C/C++ function that takes a string parameter and returns a string with all non-letters removed.',NULL,'foo!',NULL,NULL,NULL),('CodeQuestion',18,'01d42f01-62c6-4246-8487-c001062c4394','\0','3-Minute Stack','In Java or C/C++, implement a stack for integers.',180,'foo!',NULL,NULL,NULL),('EssayQuestion',19,'766e595d-3ef6-48d1-a675-e070b3ca270e','\0','Fibonacci - Read','What does the following C code do?:\n\n<pre>int w = 10, x = 0, z = 0;\nint y = x++;\n\nfor ( ; w >= 0; w-- )\n{\nz = x + y;\nprintf( \"%i, \", y = x );\nx = z;\n}</pre>',NULL,'foo!',NULL,NULL,NULL),('CodeQuestion',20,'104b09ed-c586-4f73-b61c-9130e11f5a00','\0','Fibonacci - Write','In Java or C/C++, write a function to print out the first n integers of the Fibonacci sequence.',NULL,'foo!',NULL,NULL,NULL),('CodeQuestion',21,'370484d7-3ef2-47bc-b838-462d82c9edf3','\0','Interesting Code','Write 60 seconds of interesting code.',60,'foo!',NULL,NULL,NULL);
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_and_response`
--

DROP TABLE IF EXISTS `question_and_response`;


CREATE TABLE `question_and_response` (
  `id` bigint(20) NOT NULL,
  `question` bigint(20) NOT NULL,
  `response` bigint(20) DEFAULT NULL,
  `sitting` bigint(20) NOT NULL,
  `ordinal` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKB879216281BB91CE` (`sitting`),
  KEY `FKB879216282AB9CA` (`question`),
  KEY `FKB87921623AED7F0C` (`response`),
  KEY `FKB87921622899FC56` (`id`),
  CONSTRAINT `FKB87921622899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FKB87921623AED7F0C` FOREIGN KEY (`response`) REFERENCES `response` (`id`),
  CONSTRAINT `FKB879216281BB91CE` FOREIGN KEY (`sitting`) REFERENCES `sitting` (`id`),
  CONSTRAINT `FKB879216282AB9CA` FOREIGN KEY (`question`) REFERENCES `question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `question_and_response`
--

LOCK TABLES `question_and_response` WRITE;
/*!40000 ALTER TABLE `question_and_response` DISABLE KEYS */;
/*!40000 ALTER TABLE `question_and_response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_choices`
--

DROP TABLE IF EXISTS `question_choices`;


CREATE TABLE `question_choices` (
  `question` bigint(20) NOT NULL,
  `element` varchar(255) DEFAULT NULL,
  KEY `FKCCF0F3994A488C3B` (`question`),
  CONSTRAINT `FKCCF0F3994A488C3B` FOREIGN KEY (`question`) REFERENCES `question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `question_choices`
--

LOCK TABLES `question_choices` WRITE;
/*!40000 ALTER TABLE `question_choices` DISABLE KEYS */;
INSERT INTO `question_choices` VALUES (13,'O(logN)'),(13,'O(N)'),(13,'O(NlogN)'),(13,'O(N^2)');
/*!40000 ALTER TABLE `question_choices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `response`
--

DROP TABLE IF EXISTS `response`;


CREATE TABLE `response` (
  `id` bigint(20) NOT NULL,
  `away_time` bigint(20) NOT NULL,
  `browser_type` varchar(255) NOT NULL,
  `browser_version` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `cut_copy` bit(1) NOT NULL,
  `erase_chars` bigint(20) NOT NULL,
  `erase_presses` bigint(20) NOT NULL,
  `focus_changes` bigint(20) NOT NULL,
  `focus_events` text NOT NULL,
  `focus_time` bigint(20) NOT NULL,
  `hesitation_time` bigint(20) NOT NULL,
  `key_chars` bigint(20) NOT NULL,
  `key_presses` bigint(20) NOT NULL,
  `keypress_events` longtext NOT NULL,
  `line_count` bigint(20) NOT NULL,
  `lines_per_hour` double NOT NULL,
  `load_timestamp` bigint(20) NOT NULL,
  `paste_chars` bigint(20) NOT NULL,
  `paste_events` text NOT NULL,
  `paste_presses` bigint(20) NOT NULL,
  `reviewing_time` bigint(20) NOT NULL,
  `total_time` bigint(20) NOT NULL,
  `typing_time` bigint(20) NOT NULL,
  `word_count` bigint(20) NOT NULL,
  `words_per_minute` double NOT NULL,
  `grade` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `grade` (`grade`),
  KEY `FKEBB71441F252C564` (`grade`),
  KEY `FKEBB714412899FC56` (`id`),
  CONSTRAINT `FKEBB714412899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FKEBB71441F252C564` FOREIGN KEY (`grade`) REFERENCES `grade` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `response`
--

LOCK TABLES `response` WRITE;
/*!40000 ALTER TABLE `response` DISABLE KEYS */;
/*!40000 ALTER TABLE `response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitting`
--

DROP TABLE IF EXISTS `sitting`;


CREATE TABLE `sitting` (
  `id` bigint(20) NOT NULL,
  `next_question_index` int(11) NOT NULL,
  `away_time` bigint(20) NOT NULL DEFAULT '0',
  `browser_change` bit(1) NOT NULL,
  `browser_type` varchar(255) DEFAULT NULL,
  `browser_version` varchar(255) DEFAULT NULL,
  `erase_chars` bigint(20) NOT NULL DEFAULT '0',
  `erase_presses` bigint(20) NOT NULL DEFAULT '0',
  `focus_changes` bigint(20) NOT NULL DEFAULT '0',
  `focus_time` bigint(20) NOT NULL DEFAULT '0',
  `hesitation_time` bigint(20) NOT NULL DEFAULT '0',
  `key_chars` bigint(20) NOT NULL DEFAULT '0',
  `key_presses` bigint(20) NOT NULL DEFAULT '0',
  `line_count` bigint(20) NOT NULL DEFAULT '0',
  `lines_per_hour` double NOT NULL DEFAULT '0',
  `load_timestamp` bigint(20) NOT NULL,
  `paste_chars` bigint(20) NOT NULL DEFAULT '0',
  `paste_presses` bigint(20) NOT NULL DEFAULT '0',
  `reviewing_time` bigint(20) NOT NULL DEFAULT '0',
  `total_time` bigint(20) NOT NULL DEFAULT '0',
  `typing_time` bigint(20) NOT NULL DEFAULT '0',
  `word_count` bigint(20) NOT NULL DEFAULT '0',
  `words_per_minute` double NOT NULL DEFAULT '0',
  `score` decimal(19,2) NOT NULL,
  `candidate` bigint(20) NOT NULL,
  `exam` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7D3270CC490EA5BC` (`candidate`),
  KEY `FK7D3270CC18539BC8` (`exam`),
  KEY `FK7D3270CC2899FC56` (`id`),
  CONSTRAINT `FK7D3270CC2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FK7D3270CC18539BC8` FOREIGN KEY (`exam`) REFERENCES `exam` (`id`),
  CONSTRAINT `FK7D3270CC490EA5BC` FOREIGN KEY (`candidate`) REFERENCES `candidate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `sitting`
--

LOCK TABLES `sitting` WRITE;
/*!40000 ALTER TABLE `sitting` DISABLE KEYS */;
/*!40000 ALTER TABLE `sitting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;


CREATE TABLE `user` (
  `id` bigint(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `enabled` bit(1) NOT NULL DEFAULT '',
  `hashed_password` varchar(255) NOT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `middlename` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `company` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `FK36EBCBF8A52930` (`company`),
  KEY `FK36EBCB2899FC56` (`id`),
  CONSTRAINT `FK36EBCB2899FC56` FOREIGN KEY (`id`) REFERENCES `entity_info` (`id`),
  CONSTRAINT `FK36EBCBF8A52930` FOREIGN KEY (`company`) REFERENCES `company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (9,'osamede@163.com','','13Li/S5nouCWnh/DDkgnsw2huE3+sBIRg+FboA==',NULL,'Open','Applicant','','ROLE_ADMIN',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@CHARACTER_SET_CLIENT */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger last_login_log
after update on user
for each row
begin
  if (new.last_login_time != old.last_login_time) then
    insert into login_events (user,login_time) values (new.id,new.last_login_time);
  end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `v_question_candidate_stats`
--

DROP TABLE IF EXISTS `v_question_candidate_stats`;
/*!50001 DROP VIEW IF EXISTS `v_question_candidate_stats`*/;


/*!50001 CREATE TABLE `v_question_candidate_stats` (
  `question` bigint(20),
  `response` bigint(20),
  `sitting_id` bigint(20),
  `candidate_id` bigint(20),
  `status` varchar(11),
  `away_time` bigint(20),
  `cut_copy` bit(1),
  `erase_chars` bigint(20),
  `erase_presses` bigint(20),
  `focus_changes` bigint(20),
  `focus_time` bigint(20),
  `hesitation_time` bigint(20),
  `key_chars` bigint(20),
  `key_presses` bigint(20),
  `line_count` bigint(20),
  `load_timestamp` bigint(20),
  `paste_chars` bigint(20),
  `paste_presses` bigint(20),
  `reviewing_time` bigint(20),
  `total_time` bigint(20),
  `typing_time` bigint(20),
  `word_count` bigint(20),
  `score` decimal(19,2),
  `style` decimal(19,2),
  `correctness` decimal(19,2)
) ENGINE=MyISAM */;

alter table company add facilitator_pass varchar(255);
alter table company add protocol integer;
alter table company add facilitator_url varchar(255);
alter table company add facilitator_user varchar(255);
alter table company add smtp_pass varchar(255);
alter table company add smtp_port integer;
alter table company add smtp_url varchar(255);
alter table company add smtp_user varchar(255);

