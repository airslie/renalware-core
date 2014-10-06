-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: renalware
-- ------------------------------------------------------
-- Server version	5.5.38-0ubuntu0.14.04.1

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
-- Current Database: `renalware`
--

--
-- Table structure for table `accessclinics`
--

DROP TABLE IF EXISTS `accessclinics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accessclinics` (
  `accessclinic_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `accessclinzid` mediumint(6) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `accessclinuser` varchar(30) DEFAULT NULL,
  `accessclindate` date DEFAULT NULL,
  `surgeon` varchar(30) DEFAULT NULL,
  `decision` varchar(255) DEFAULT NULL,
  `ixrequests` varchar(255) DEFAULT NULL,
  `anaesth` char(2) DEFAULT NULL,
  `priority` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`accessclinic_id`),
  KEY `accessclinrid` (`accessclinzid`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `accessfxndata`
--

DROP TABLE IF EXISTS `accessfxndata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accessfxndata` (
  `accessfxndata_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `accessfxnzid` mediumint(6) DEFAULT NULL,
  `accessfxnuser` varchar(30) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `modalstamp` varchar(30) DEFAULT NULL,
  `assessmentdate` date DEFAULT NULL,
  `accesstype` varchar(100) DEFAULT NULL,
  `assessmentmethod` varchar(100) DEFAULT NULL,
  `flow_feedartery` varchar(30) DEFAULT NULL,
  `artstenosisflag` int(1) DEFAULT NULL,
  `artstenosistext` varchar(255) DEFAULT NULL,
  `venstenosisflag` tinyint(1) DEFAULT NULL,
  `venstenosistext` varchar(255) DEFAULT NULL,
  `rx_decision` varchar(255) DEFAULT NULL,
  `proceduredate` date DEFAULT NULL,
  `proced_type` varchar(100) DEFAULT NULL,
  `proced_outcome` varchar(255) DEFAULT NULL,
  `residualstenosisflag` tinyint(1) DEFAULT NULL,
  `surveillance` varchar(50) DEFAULT NULL,
  `assessmentoutcome` enum('Green','Amber','Red') DEFAULT NULL,
  PRIMARY KEY (`accessfxndata_id`),
  KEY `accessfxnzid` (`accessfxnzid`)
) ENGINE=InnoDB AUTO_INCREMENT=1994 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `accessprocdata`
--

DROP TABLE IF EXISTS `accessprocdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accessprocdata` (
  `accessprocdata_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `accessproczid` mediumint(6) DEFAULT NULL,
  `proced` varchar(255) DEFAULT NULL,
  `operator` varchar(30) DEFAULT NULL,
  `firstflag` tinyint(1) DEFAULT NULL,
  `outcome` varchar(255) DEFAULT NULL,
  `firstused_date` date DEFAULT NULL,
  `failuredate` date DEFAULT NULL,
  `proceduredate` date DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `accessprocuser` varchar(30) DEFAULT NULL,
  `cathetermake` varchar(30) DEFAULT NULL,
  `catheterlotno` varchar(15) DEFAULT NULL,
  `modifstamp` datetime DEFAULT NULL,
  PRIMARY KEY (`accessprocdata_id`),
  KEY `accessprocrid` (`accessproczid`)
) ENGINE=InnoDB AUTO_INCREMENT=11388 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `admissiondata`
--

DROP TABLE IF EXISTS `admissiondata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admissiondata` (
  `admission_id` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `admzid` mediumint(6) unsigned DEFAULT NULL,
  `admmodifstamp` datetime DEFAULT NULL,
  `admaddstamp` datetime DEFAULT '0000-00-00 00:00:00',
  `admittedflag` tinyint(1) DEFAULT '1',
  `admhospno1` char(7) DEFAULT NULL,
  `patlastfirst` varchar(50) DEFAULT NULL,
  `admmodal` varchar(20) DEFAULT NULL,
  `admdate` date DEFAULT NULL,
  `admdt` datetime DEFAULT NULL,
  `admward` varchar(20) DEFAULT NULL,
  `consultant` varchar(20) DEFAULT NULL,
  `admtype` varchar(20) DEFAULT NULL,
  `reason` varchar(60) DEFAULT NULL,
  `transferward` varchar(20) DEFAULT NULL,
  `transferdate` date DEFAULT NULL,
  `dischdate` date DEFAULT NULL,
  `dischdest` varchar(30) DEFAULT NULL,
  `deathflag` tinyint(1) DEFAULT NULL,
  `admstatus` enum('Admitted','Discharged','Died','Cancelled','Deleted') NOT NULL DEFAULT 'Admitted',
  `admdays` smallint(3) unsigned DEFAULT NULL,
  `currward` varchar(20) DEFAULT NULL,
  `outward` varchar(20) DEFAULT NULL,
  `category` varchar(20) DEFAULT NULL,
  `dischsummstatus` varchar(40) DEFAULT 'create',
  `dischsummdate` date DEFAULT NULL,
  `hl7msh_id` int(9) unsigned DEFAULT NULL,
  `servicecode` varchar(10) DEFAULT NULL,
  `eventcode` char(3) DEFAULT NULL,
  `dischsummflag` tinyint(1) NOT NULL DEFAULT '0',
  `pid_date` char(17) DEFAULT NULL,
  PRIMARY KEY (`admission_id`),
  KEY `admrid` (`admzid`),
  KEY `admittedflag` (`admittedflag`),
  KEY `admhospno1` (`admhospno1`),
  KEY `patlastfirst` (`patlastfirst`),
  KEY `admward` (`admward`),
  KEY `admdate` (`admdate`),
  KEY `dischsummstatus` (`dischsummstatus`),
  KEY `hl7admission_id` (`hl7msh_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33125 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `akidata`
--

DROP TABLE IF EXISTS `akidata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `akidata` (
  `aki_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `akistamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `akimodifdt` datetime DEFAULT NULL,
  `akiuid` smallint(4) unsigned DEFAULT NULL,
  `akiuser` varchar(20) DEFAULT NULL,
  `akizid` mediumint(7) unsigned DEFAULT NULL,
  `consultid` mediumint(7) unsigned DEFAULT NULL,
  `akiadddate` date DEFAULT NULL,
  `akimodifdate` date DEFAULT NULL,
  `episodedate` date DEFAULT NULL,
  `episodestatus` varchar(30) DEFAULT NULL,
  `referraldate` date DEFAULT NULL,
  `admissionmethod` varchar(60) DEFAULT NULL,
  `elderlyscore` tinyint(1) DEFAULT NULL,
  `existingckdscore` tinyint(1) DEFAULT NULL,
  `ckdstatus` varchar(12) DEFAULT NULL,
  `cardiacfailurescore` tinyint(1) DEFAULT NULL,
  `diabetesscore` tinyint(1) DEFAULT NULL,
  `liverdiseasescore` tinyint(1) DEFAULT NULL,
  `vasculardiseasescore` tinyint(1) DEFAULT NULL,
  `nephrotoxicmedscore` tinyint(1) DEFAULT NULL,
  `akiriskscore` tinyint(1) unsigned DEFAULT NULL,
  `cre_baseline` smallint(4) unsigned DEFAULT NULL,
  `cre_peak` smallint(4) unsigned DEFAULT NULL,
  `egfr_baseline` decimal(5,1) unsigned DEFAULT NULL,
  `urineoutput` varchar(30) DEFAULT NULL,
  `urineblood` varchar(6) DEFAULT NULL,
  `urineprotein` varchar(6) DEFAULT NULL,
  `akinstage` tinyint(1) DEFAULT NULL,
  `stopdiagnosis` varchar(60) DEFAULT NULL,
  `stopsubtype` varchar(60) DEFAULT NULL,
  `stopsubtypenotes` varchar(255) DEFAULT NULL,
  `akicode` char(1) DEFAULT NULL,
  `ituflag` char(1) DEFAULT NULL,
  `itudate` date DEFAULT NULL,
  `renalunitflag` char(1) DEFAULT NULL,
  `renalunitdate` date DEFAULT NULL,
  `itustepdownflag` char(1) DEFAULT NULL,
  `rrtflag` char(1) DEFAULT NULL,
  `rrttype` varchar(12) DEFAULT NULL,
  `rrtduration` varchar(12) DEFAULT NULL,
  `rrtnotes` varchar(100) DEFAULT NULL,
  `mgtnotes` text,
  `akioutcome` varchar(255) DEFAULT NULL,
  `ussflag` char(1) DEFAULT NULL,
  `ussdate` date DEFAULT NULL,
  `ussnotes` text,
  `biopsyflag` char(1) DEFAULT NULL,
  `biopsydate` date DEFAULT NULL,
  `biopsynotes` text,
  `otherix` text,
  `akinotes` text,
  PRIMARY KEY (`aki_id`),
  KEY `akizid` (`akizid`),
  KEY `akiuid` (`akiuid`),
  KEY `episodedate` (`episodedate`),
  KEY `consultid` (`consultid`)
) ENGINE=InnoDB AUTO_INCREMENT=660 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `apdrxdata`
--

DROP TABLE IF EXISTS `apdrxdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `apdrxdata` (
  `apdrx_id` mediumint(7) NOT NULL AUTO_INCREMENT,
  `apdrxzid` mediumint(7) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `adduser` varchar(30) DEFAULT NULL,
  `adduid` smallint(3) DEFAULT NULL,
  `adddate` date DEFAULT NULL,
  `therapytype` varchar(50) DEFAULT NULL,
  `totalvol` smallint(5) DEFAULT NULL,
  `dextrose` varchar(50) DEFAULT NULL,
  `therapytime` varchar(12) DEFAULT NULL,
  `fillvolume` smallint(5) DEFAULT NULL,
  `lastfill` varchar(12) DEFAULT NULL,
  `extraneal` char(3) DEFAULT NULL,
  `no_cycles` tinyint(2) unsigned DEFAULT NULL,
  `avgdwelltime` varchar(12) DEFAULT NULL,
  `initdrainalarm` smallint(5) DEFAULT NULL,
  `signature` varchar(30) DEFAULT NULL,
  `calcium` char(3) DEFAULT NULL,
  `ph` varchar(12) DEFAULT NULL,
  `optichoice` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`apdrx_id`),
  KEY `apdrxzid` (`apdrxzid`)
) ENGINE=InnoDB AUTO_INCREMENT=1816 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arc_eq5ddata`
--

DROP TABLE IF EXISTS `arc_eq5ddata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arc_eq5ddata` (
  `eq5d_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `eq5dstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `eq5duid` smallint(4) unsigned DEFAULT NULL,
  `eq5duser` varchar(20) DEFAULT NULL,
  `eq5dzid` mediumint(7) unsigned DEFAULT NULL,
  `eq5dadddate` date DEFAULT NULL,
  `eq5ddate` date DEFAULT NULL,
  `mobility` varchar(24) DEFAULT NULL,
  `selfcare` varchar(24) DEFAULT NULL,
  `activities` varchar(24) DEFAULT NULL,
  `pain_discomfort` varchar(24) DEFAULT NULL,
  `anxiety_depress` varchar(24) DEFAULT NULL,
  `healthstate` tinyint(3) unsigned DEFAULT NULL,
  `seriousillness_self` char(1) DEFAULT NULL,
  `seriousillness_family` char(1) DEFAULT NULL,
  `seriousillness_others` char(1) DEFAULT NULL,
  `currage` tinyint(3) unsigned DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `smoking` enum('current','ex-smoker','never') DEFAULT NULL,
  `healthsocialworker` char(1) DEFAULT NULL,
  `healthsocialworktype` varchar(70) DEFAULT NULL,
  `mainactivity` varchar(40) DEFAULT NULL,
  `mainactivity_other` varchar(70) DEFAULT NULL,
  `continuededuc` char(1) DEFAULT NULL,
  `degree_qualif` char(1) DEFAULT NULL,
  `postcode` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`eq5d_id`),
  KEY `eq5dzid` (`eq5dzid`),
  KEY `eq5duid` (`eq5duid`),
  KEY `eq5dadddate` (`eq5dadddate`)
) ENGINE=InnoDB AUTO_INCREMENT=4164 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arc_possdata2`
--

DROP TABLE IF EXISTS `arc_possdata2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arc_possdata2` (
  `poss_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `possstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `possuid` smallint(4) unsigned DEFAULT NULL,
  `possuser` varchar(20) DEFAULT NULL,
  `posszid` mediumint(7) unsigned DEFAULT NULL,
  `possadddate` date DEFAULT NULL,
  `possdate` date DEFAULT NULL,
  `pain` tinyint(1) DEFAULT NULL,
  `shortness_of_breath` tinyint(1) DEFAULT NULL,
  `weakness` tinyint(1) DEFAULT NULL,
  `nausea` tinyint(1) DEFAULT NULL,
  `vomiting` tinyint(1) DEFAULT NULL,
  `poor_appetite` tinyint(1) DEFAULT NULL,
  `constipation` tinyint(1) DEFAULT NULL,
  `mouth_problems` tinyint(1) DEFAULT NULL,
  `drowsiness` tinyint(1) DEFAULT NULL,
  `poor_mobility` tinyint(1) DEFAULT NULL,
  `itching` tinyint(1) DEFAULT NULL,
  `insomnia` tinyint(1) DEFAULT NULL,
  `restless_legs` tinyint(1) DEFAULT NULL,
  `anxiety` tinyint(1) DEFAULT NULL,
  `depression` tinyint(1) DEFAULT NULL,
  `skinchanges` tinyint(1) DEFAULT NULL,
  `diarrhoea` tinyint(1) DEFAULT NULL,
  `othersymptom1` varchar(50) DEFAULT NULL,
  `othersymptom2` varchar(50) DEFAULT NULL,
  `othersymptom3` varchar(50) DEFAULT NULL,
  `othersymptom1score` tinyint(1) DEFAULT NULL,
  `othersymptom2score` tinyint(1) DEFAULT NULL,
  `othersymptom3score` tinyint(1) DEFAULT NULL,
  `affected_most` varchar(50) DEFAULT NULL,
  `improved_most` varchar(50) DEFAULT NULL,
  `totalposs_score` smallint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`poss_id`),
  KEY `posszid` (`posszid`),
  KEY `possuid` (`possuid`),
  KEY `possadddate` (`possadddate`),
  KEY `possdate` (`possdate`)
) ENGINE=InnoDB AUTO_INCREMENT=4221 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arcdata`
--

DROP TABLE IF EXISTS `arcdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arcdata` (
  `arc_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `arcstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `arcmodifstamp` datetime DEFAULT NULL,
  `arcuid` smallint(4) unsigned DEFAULT NULL,
  `arcuser` varchar(20) DEFAULT NULL,
  `arczid` mediumint(7) unsigned DEFAULT NULL,
  `arcadddate` date DEFAULT NULL,
  `arcmodifdate` date DEFAULT NULL,
  `whereseen` varchar(30) DEFAULT NULL,
  `surpriseflag` char(1) DEFAULT NULL,
  `surprisedate` date DEFAULT NULL,
  `surveyconsentflag` char(1) DEFAULT NULL,
  `ihdflag` char(1) DEFAULT NULL,
  `pvdflag` char(1) DEFAULT NULL,
  `dementiaflag` char(1) DEFAULT NULL,
  `lowalbuminflag` char(1) DEFAULT NULL,
  `weightlossflag` char(1) DEFAULT NULL,
  `myeloma_cancerflag` char(1) DEFAULT NULL,
  `karnofskyscore` tinyint(3) unsigned DEFAULT NULL,
  `symptoms` text,
  `patientfamilylog` text,
  `healthproviderlog` text,
  `arcplanninglog` text,
  `placeofcareprefs` text,
  `counsellorrefflag` char(1) DEFAULT NULL,
  `counsellorrefdate` date DEFAULT NULL,
  `counsellorcomments` text,
  `socialworkerrefflag` char(1) DEFAULT NULL,
  `socialworkerrefdate` date DEFAULT NULL,
  `socialworkercomments` text,
  `hospicerefflag` char(1) DEFAULT NULL,
  `hospicerefdate` date DEFAULT NULL,
  `hospicename` varchar(70) DEFAULT NULL,
  `endoflifeplans` text,
  `deathdate` date DEFAULT NULL,
  `deathplace` varchar(200) DEFAULT NULL,
  `deathcause` varchar(255) DEFAULT NULL,
  `bereavementnotes` text,
  `questionnairesentflag` char(1) DEFAULT NULL,
  `questionnairedate` date DEFAULT NULL,
  `archistory` text,
  `arcdiagnosis` varchar(200) DEFAULT NULL,
  `goldregisterflag` char(1) DEFAULT NULL,
  `golddiscussedflag` char(1) DEFAULT NULL,
  `goldacpflag` char(1) DEFAULT NULL,
  `goldecommregisterflag` char(1) DEFAULT NULL,
  PRIMARY KEY (`arc_id`),
  KEY `arczid` (`arczid`),
  KEY `arcuid` (`arcuid`)
) ENGINE=InnoDB AUTO_INCREMENT=927 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bookmarkdata`
--

DROP TABLE IF EXISTS `bookmarkdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarkdata` (
  `mark_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `markstamp` datetime DEFAULT NULL,
  `markzid` mediumint(6) unsigned DEFAULT NULL,
  `markuid` smallint(4) unsigned DEFAULT NULL,
  `marknotes` varchar(255) DEFAULT NULL,
  `marklist` varchar(30) DEFAULT NULL,
  `markpriority` enum('Normal','URGENT') DEFAULT 'Normal',
  PRIMARY KEY (`mark_id`),
  KEY `markzid` (`markzid`),
  KEY `markuid` (`markuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bpwtdata`
--

DROP TABLE IF EXISTS `bpwtdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bpwtdata` (
  `bpwt_id` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `bpwtzid` mediumint(6) unsigned DEFAULT NULL,
  `bpwtuid` smallint(4) unsigned DEFAULT NULL,
  `bpwtstamp` datetime DEFAULT NULL,
  `bpwtmodal` varchar(50) DEFAULT NULL,
  `bpwtdate` date DEFAULT NULL,
  `bpsyst` smallint(3) unsigned DEFAULT NULL,
  `bpdiast` smallint(3) unsigned DEFAULT NULL,
  `weight` decimal(5,2) unsigned DEFAULT NULL,
  `height` decimal(3,2) unsigned DEFAULT NULL,
  `bpwttype` varchar(60) DEFAULT NULL,
  `BMI` decimal(3,1) unsigned DEFAULT NULL,
  `urine_prot` varchar(6) DEFAULT NULL,
  `urine_blood` varchar(6) DEFAULT NULL,
  `urinedate` date DEFAULT NULL,
  `lett_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`bpwt_id`),
  KEY `bpwtzid` (`bpwtzid`),
  KEY `bpwtuid` (`bpwtuid`),
  KEY `bpwtdate` (`bpwtdate`),
  KEY `lett_id` (`lett_id`)
) ENGINE=InnoDB AUTO_INCREMENT=171671 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capdrxdata`
--

DROP TABLE IF EXISTS `capdrxdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `capdrxdata` (
  `capdrx_id` mediumint(7) NOT NULL AUTO_INCREMENT,
  `capdrxzid` mediumint(7) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `adduser` varchar(30) DEFAULT NULL,
  `adduid` smallint(3) DEFAULT NULL,
  `adddate` date DEFAULT NULL,
  `no_exchange` tinyint(1) DEFAULT NULL,
  `volume` mediumint(5) DEFAULT NULL,
  `dextrose` varchar(50) DEFAULT NULL,
  `calcium` varchar(12) DEFAULT NULL,
  `system` enum('SOLO','StaySafe') DEFAULT NULL,
  `extraneal` varchar(12) DEFAULT NULL,
  `ph` varchar(20) DEFAULT NULL,
  `signature` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`capdrx_id`),
  KEY `capdrxzid` (`capdrxzid`)
) ENGINE=InnoDB AUTO_INCREMENT=541 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capdworkups`
--

DROP TABLE IF EXISTS `capdworkups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `capdworkups` (
  `workup_id` mediumint(6) NOT NULL AUTO_INCREMENT,
  `workupzid` mediumint(6) DEFAULT NULL,
  `workupmodifstamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `workupaddstamp` datetime DEFAULT '0000-00-00 00:00:00',
  `workupuser` varchar(20) DEFAULT NULL,
  `workupdate` date DEFAULT NULL,
  `workupnurse` varchar(40) DEFAULT NULL,
  `homevisitdate` date DEFAULT NULL,
  `housingtype` varchar(30) DEFAULT NULL,
  `no_rooms` tinyint(2) DEFAULT NULL,
  `exchangearea` varchar(255) DEFAULT NULL,
  `handwashing` varchar(255) DEFAULT NULL,
  `fluidstorage` varchar(255) DEFAULT NULL,
  `bagwarming` varchar(255) DEFAULT NULL,
  `freqdeliveries` varchar(255) DEFAULT NULL,
  `rehousingflag` char(1) DEFAULT NULL,
  `rehousingreasons` text,
  `socialworkerflag` char(1) DEFAULT NULL,
  `nurseassessdate` date DEFAULT NULL,
  `seenvideo` char(1) DEFAULT NULL,
  `ableopenbag` char(1) DEFAULT NULL,
  `ableliftbag` char(1) DEFAULT NULL,
  `eyesight` varchar(255) DEFAULT NULL,
  `hearing` varchar(255) DEFAULT NULL,
  `dexterity` varchar(255) DEFAULT NULL,
  `motivation` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `notes` text,
  `suitableflag` char(1) DEFAULT NULL,
  `systemchoice` varchar(100) DEFAULT NULL,
  `insertdiscussflag` char(1) DEFAULT NULL,
  `methodchosen` varchar(255) DEFAULT NULL,
  `accessclinrefflag` char(1) DEFAULT NULL,
  `accessclinrefdate` date DEFAULT NULL,
  `abdoassessor` varchar(50) DEFAULT NULL,
  `addedcomments` text,
  `no_occupants` tinyint(2) unsigned DEFAULT NULL,
  `occupantnotes` text,
  `boweldisflag` char(1) DEFAULT NULL,
  `boweldisnotes` text,
  `homevisitflag` char(1) DEFAULT NULL,
  PRIMARY KEY (`workup_id`),
  KEY `workupzid` (`workupzid`)
) ENGINE=InnoDB AUTO_INCREMENT=1247 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clinstudylist`
--

DROP TABLE IF EXISTS `clinstudylist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clinstudylist` (
  `study_id` tinyint(3) NOT NULL AUTO_INCREMENT,
  `studycode` varchar(25) DEFAULT NULL,
  `studyname` varchar(100) DEFAULT NULL,
  `studynotes` varchar(255) DEFAULT NULL,
  `studystamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `studyleader` varchar(30) DEFAULT NULL,
  `studydate` date DEFAULT NULL,
  PRIMARY KEY (`study_id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clinstudypatdata`
--

DROP TABLE IF EXISTS `clinstudypatdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clinstudypatdata` (
  `clinstudypat_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `clinstudyzid` mediumint(6) DEFAULT NULL,
  `studyid` tinyint(3) DEFAULT NULL,
  `clinstudypatstamp` datetime DEFAULT '0000-00-00 00:00:00',
  `patadduser` varchar(20) DEFAULT NULL,
  `patadddate` date DEFAULT NULL,
  `termdate` date DEFAULT NULL,
  PRIMARY KEY (`clinstudypat_id`),
  KEY `clinstudyzid` (`clinstudyzid`),
  KEY `studyid` (`studyid`)
) ENGINE=InnoDB AUTO_INCREMENT=1479 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consultants`
--

DROP TABLE IF EXISTS `consultants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultants` (
  `cons_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `conscode` varchar(12) DEFAULT NULL,
  `conslast` varchar(20) DEFAULT NULL,
  `consfirst` varchar(30) DEFAULT NULL,
  `consfullname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cons_id`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consultcodes`
--

DROP TABLE IF EXISTS `consultcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultcodes` (
  `consultcode` varchar(10) DEFAULT NULL,
  `consultname` varchar(30) DEFAULT NULL,
  KEY `consultcode` (`consultcode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consultdata`
--

DROP TABLE IF EXISTS `consultdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultdata` (
  `consult_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `consultstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `consultmodifstamp` datetime DEFAULT NULL,
  `consultuid` smallint(4) unsigned DEFAULT NULL,
  `consultuser` varchar(20) DEFAULT NULL,
  `consultstaffname` varchar(50) DEFAULT NULL,
  `consultzid` mediumint(7) unsigned DEFAULT NULL,
  `consultmodal` varchar(20) DEFAULT NULL,
  `consultstartdate` date DEFAULT NULL,
  `consultenddate` date DEFAULT NULL,
  `consultward` varchar(50) DEFAULT NULL,
  `consulttype` varchar(50) DEFAULT NULL,
  `consultdescr` tinytext,
  `consulttext` text,
  `activeflag` char(1) DEFAULT 'Y',
  `akiriskflag` char(1) DEFAULT NULL,
  `consultsite` varchar(8) DEFAULT NULL,
  `othersite` varchar(60) DEFAULT NULL,
  `contactbleep` varchar(20) DEFAULT NULL,
  `sitehospno` varchar(20) DEFAULT NULL,
  `transferpriority` varchar(12) DEFAULT NULL,
  `decisiondate` date DEFAULT NULL,
  `transferdate` date DEFAULT NULL,
  PRIMARY KEY (`consult_id`),
  KEY `consultzid` (`consultzid`),
  KEY `consultuid` (`consultuid`),
  KEY `consultstartdate` (`consultstartdate`),
  KEY `consultenddate` (`consultenddate`),
  KEY `consultsite` (`consultsite`)
) ENGINE=InnoDB AUTO_INCREMENT=6252 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currentclindata`
--

DROP TABLE IF EXISTS `currentclindata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currentclindata` (
  `currentclinzid` mediumint(6) NOT NULL DEFAULT '0',
  `currentadddate` datetime DEFAULT NULL,
  `BPsyst` smallint(3) DEFAULT NULL,
  `BPdiast` smallint(3) DEFAULT NULL,
  `BPdate` date DEFAULT NULL,
  `Weight` decimal(4,1) DEFAULT NULL,
  `Weightdate` date DEFAULT NULL,
  `Height` decimal(3,2) DEFAULT NULL,
  `Heightdate` date DEFAULT NULL,
  `BMI` decimal(3,1) DEFAULT NULL,
  `currentstamp` datetime DEFAULT NULL,
  PRIMARY KEY (`currentclinzid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `downloads`
--

DROP TABLE IF EXISTS `downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloads` (
  `download_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `filetitle` varchar(100) DEFAULT NULL,
  `filedescr` varchar(255) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `addstamp` date DEFAULT NULL,
  PRIMARY KEY (`download_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `druglist`
--

DROP TABLE IF EXISTS `druglist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `druglist` (
  `drug_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `drugname` varchar(60) DEFAULT NULL,
  `esdflag` tinyint(1) unsigned DEFAULT '0',
  `immunosuppflag` tinyint(1) unsigned DEFAULT '0',
  `user` varchar(30) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  PRIMARY KEY (`drug_id`),
  KEY `drugname` (`drugname`),
  KEY `esdflag` (`esdflag`),
  KEY `immunosuppflag` (`immunosuppflag`)
) ENGINE=InnoDB AUTO_INCREMENT=2137 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `edtadeathcodes`
--

DROP TABLE IF EXISTS `edtadeathcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `edtadeathcodes` (
  `edtacode` tinyint(2) NOT NULL DEFAULT '0',
  `edtacause` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`edtacode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `encounterdata`
--

DROP TABLE IF EXISTS `encounterdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `encounterdata` (
  `encounter_id` mediumint(6) NOT NULL AUTO_INCREMENT,
  `enczid` mediumint(6) DEFAULT NULL,
  `encmodifstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `encaddstamp` datetime DEFAULT '0000-00-00 00:00:00',
  `encuser` varchar(20) DEFAULT NULL,
  `encmodal` varchar(20) DEFAULT NULL,
  `encdate` date DEFAULT NULL,
  `enctime` varchar(20) DEFAULT NULL,
  `enctype` varchar(50) DEFAULT NULL,
  `encdescr` varchar(255) DEFAULT NULL,
  `enctext` text,
  `bpsyst` tinyint(3) unsigned DEFAULT NULL,
  `bpdiast` tinyint(3) unsigned DEFAULT NULL,
  `weight` decimal(4,1) DEFAULT NULL,
  `height` decimal(3,2) DEFAULT NULL,
  `notes` text,
  `staffname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`encounter_id`),
  KEY `enczid` (`enczid`)
) ENGINE=InnoDB AUTO_INCREMENT=258562 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `esddata`
--

DROP TABLE IF EXISTS `esddata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esddata` (
  `esd_id` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `esdzid` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `esdstamp` datetime DEFAULT NULL,
  `esddate` date DEFAULT NULL,
  `esdstatus` varchar(20) DEFAULT NULL,
  `esdstartdate` date DEFAULT NULL,
  `esdmodifdate` date DEFAULT NULL,
  `esdmodifdt` datetime DEFAULT NULL,
  `esdregime` varchar(100) DEFAULT NULL,
  `prescriber` varchar(20) DEFAULT NULL,
  `unitsperweek` mediumint(6) unsigned DEFAULT NULL,
  `unitsperwkperkg` decimal(5,1) DEFAULT NULL,
  `lastirondose` varchar(12) DEFAULT NULL,
  `lastirondosetype` varchar(12) DEFAULT NULL,
  `lastirondosedate` date DEFAULT NULL,
  `lastirondosebatch` varchar(12) DEFAULT NULL,
  `esdcomments` text,
  `administrator` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`esd_id`),
  UNIQUE KEY `esdzid` (`esdzid`),
  KEY `esdstatus` (`esdstatus`),
  KEY `esddate` (`esddate`)
) ENGINE=InnoDB AUTO_INCREMENT=25189 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `esrfcauses`
--

DROP TABLE IF EXISTS `esrfcauses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esrfcauses` (
  `esrfcause_id` tinyint(3) NOT NULL AUTO_INCREMENT,
  `edtacode` char(2) DEFAULT NULL,
  `esrfcause` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`esrfcause_id`),
  KEY `edtacode` (`edtacode`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `esrfdata`
--

DROP TABLE IF EXISTS `esrfdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `esrfdata` (
  `esrf_id` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `esrfzid` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `esrfstamp` datetime DEFAULT NULL,
  `esrfmodifstamp` datetime DEFAULT NULL,
  `esrfdate` date DEFAULT NULL,
  `firstseendate` date DEFAULT NULL,
  `esrfweight` decimal(4,1) DEFAULT NULL,
  `EDTAcode` char(2) DEFAULT NULL,
  `EDTAtext` varchar(120) DEFAULT NULL,
  `SecondCause1` varchar(120) DEFAULT NULL,
  `rreg_prdcode` smallint(4) unsigned DEFAULT NULL,
  `rreg_prddate` date DEFAULT NULL,
  `Angina` enum('Y','N') DEFAULT NULL,
  `PreviousMIlast90d` enum('Y','N') DEFAULT NULL,
  `PreviousMIover90d` enum('Y','N') DEFAULT NULL,
  `PreviousCAGB` enum('Y','N') DEFAULT NULL,
  `EpisodeHeartFailure` enum('Y','N') DEFAULT NULL,
  `Smoking` enum('Y','N') DEFAULT NULL,
  `COPD` enum('Y','N') DEFAULT NULL,
  `CVDsympt` enum('Y','N') DEFAULT NULL,
  `DiabetesNotCauseESRF` enum('Y','N') DEFAULT NULL,
  `Malignancy` enum('Y','N') DEFAULT NULL,
  `LiverDisease` enum('Y','N') DEFAULT NULL,
  `Claudication` enum('Y','N') DEFAULT NULL,
  `IschNeuropathUlcers` enum('Y','N') DEFAULT NULL,
  `AngioplastyNonCoron` enum('Y','N') DEFAULT NULL,
  `AmputationPVD` enum('Y','N') DEFAULT NULL,
  PRIMARY KEY (`esrf_id`),
  UNIQUE KEY `esrfzid` (`esrfzid`),
  KEY `esrfdate` (`esrfdate`),
  KEY `rreg_prdcode` (`rreg_prdcode`)
) ENGINE=InnoDB AUTO_INCREMENT=15562 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ethniccodes`
--

DROP TABLE IF EXISTS `ethniccodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ethniccodes` (
  `ethnicity` varchar(30) DEFAULT NULL,
  `readcode` varchar(6) DEFAULT NULL,
  KEY `ethnicity` (`ethnicity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ethnicityfixdata`
--

DROP TABLE IF EXISTS `ethnicityfixdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ethnicityfixdata` (
  `ethnicity` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `patcount` int(8) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eventcodes`
--

DROP TABLE IF EXISTS `eventcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventcodes` (
  `eventcode` char(3) DEFAULT NULL,
  `eventname` varchar(60) DEFAULT NULL,
  `supportflag` enum('Y') DEFAULT NULL,
  UNIQUE KEY `eventcode` (`eventcode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eventlogs`
--

DROP TABLE IF EXISTS `eventlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventlogs` (
  `eventlog_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eventstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `eventuser` varchar(20) DEFAULT NULL,
  `event_uid` smallint(4) unsigned DEFAULT NULL,
  `eventzid` mediumint(7) unsigned DEFAULT NULL,
  `session_id` mediumint(6) unsigned DEFAULT NULL,
  `type` tinytext,
  `session_ipn` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`eventlog_id`),
  KEY `uid` (`event_uid`),
  KEY `eventzid` (`eventzid`)
) ENGINE=InnoDB AUTO_INCREMENT=4965598 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eventsdata`
--

DROP TABLE IF EXISTS `eventsdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventsdata` (
  `event_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `importstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg_id` int(9) unsigned DEFAULT NULL,
  `mshdatetime` datetime DEFAULT NULL,
  `eventdate` date DEFAULT NULL,
  `eventcode` enum('A01','A02','A03','A05','A08','A11','A13','A28','A31','A34','A38','M02') DEFAULT NULL,
  `servicecode` varchar(10) DEFAULT NULL,
  `kchno` char(7) DEFAULT NULL,
  `patlastfirst` varchar(30) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `sex` enum('MALE','FEMALE') DEFAULT NULL,
  `ward` varchar(20) DEFAULT NULL,
  `admitdatetime` datetime DEFAULT NULL,
  `admitdate` date DEFAULT NULL,
  `dischdatetime` datetime DEFAULT NULL,
  `dischdate` date DEFAULT NULL,
  `referrercode` varchar(10) DEFAULT NULL,
  `referrer` varchar(30) DEFAULT NULL,
  `consultcode` varchar(10) DEFAULT NULL,
  `consultname` varchar(30) DEFAULT NULL,
  `patienttype` varchar(6) DEFAULT NULL,
  `dischlocation` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `msg_id` (`msg_id`),
  KEY `kchno` (`kchno`),
  KEY `eventcode` (`eventcode`),
  KEY `servicecode` (`servicecode`),
  KEY `eventdate` (`eventdate`),
  KEY `patlastfirst` (`patlastfirst`),
  KEY `consultcode` (`consultcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exitsitedata`
--

DROP TABLE IF EXISTS `exitsitedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exitsitedata` (
  `exitsitedata_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `exitsitezid` mediumint(6) DEFAULT NULL,
  `infectiondate` date DEFAULT NULL,
  `organism1` varchar(50) DEFAULT NULL,
  `organism2` varchar(50) DEFAULT NULL,
  `treatment` varchar(255) DEFAULT NULL,
  `outcome` varchar(255) DEFAULT NULL,
  `exitsitenotes` varchar(255) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `modifstamp` datetime DEFAULT NULL,
  PRIMARY KEY (`exitsitedata_id`),
  KEY `exitsitezid` (`exitsitezid`)
) ENGINE=InnoDB AUTO_INCREMENT=574 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpCDAlogs`
--

DROP TABLE IF EXISTS `gpCDAlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpCDAlogs` (
  `log_id` mediumint(6) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `logstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `logadddate` date DEFAULT NULL,
  `logzid` mediumint(7) unsigned NOT NULL DEFAULT '0',
  `logletter_id` mediumint(7) unsigned NOT NULL DEFAULT '0',
  `loghospno` varchar(12) DEFAULT NULL,
  `loguid` smallint(4) unsigned NOT NULL DEFAULT '0',
  `loguser` varchar(20) NOT NULL DEFAULT 'loguser',
  `logpracticecode` varchar(12) NOT NULL,
  `logdescr` varchar(90) NOT NULL DEFAULT 'letterdescription',
  `loglettertype` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `logzid` (`logzid`),
  KEY `loguid` (`loguid`),
  KEY `logletter_id` (`logletter_id`),
  KEY `logpracticecode` (`logpracticecode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpdata`
--

DROP TABLE IF EXISTS `gpdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpdata` (
  `gp_id` mediumint(5) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `practicecode` char(6) DEFAULT NULL,
  `gpcode` char(8) DEFAULT NULL,
  `gplastinits` varchar(30) DEFAULT NULL,
  `gpaddr1` varchar(30) DEFAULT NULL,
  `gpaddr2` varchar(30) DEFAULT NULL,
  `gpaddr3` varchar(30) DEFAULT NULL,
  `gpaddr4` varchar(20) DEFAULT NULL,
  `gppostcode` varchar(8) DEFAULT NULL,
  `gptel` varchar(20) DEFAULT NULL,
  `gpname` varchar(30) DEFAULT NULL,
  `gpaddress` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`gp_id`),
  UNIQUE KEY `gpcode` (`gpcode`),
  KEY `practicecode` (`practicecode`),
  KEY `gplastinits` (`gplastinits`),
  KEY `gppostcode` (`gppostcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpemaillogs`
--

DROP TABLE IF EXISTS `gpemaillogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpemaillogs` (
  `log_id` mediumint(6) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `logstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `logadddate` date DEFAULT NULL,
  `logzid` mediumint(7) unsigned NOT NULL DEFAULT '0',
  `logletter_id` mediumint(7) unsigned NOT NULL DEFAULT '0',
  `loghospno` varchar(12) DEFAULT NULL,
  `loguid` smallint(4) unsigned NOT NULL DEFAULT '0',
  `loguser` varchar(20) NOT NULL DEFAULT 'loguser',
  `logpracticecode` varchar(12) NOT NULL,
  `logemail` varchar(60) DEFAULT NULL,
  `logdescr` varchar(90) NOT NULL DEFAULT 'letterdescription',
  `loglettertype` varchar(20) DEFAULT NULL,
  `logfilename` varchar(60) DEFAULT NULL,
  `loghtml` text,
  PRIMARY KEY (`log_id`),
  KEY `logzid` (`logzid`),
  KEY `loguid` (`loguid`),
  KEY `logletter_id` (`logletter_id`),
  KEY `logpracticecode` (`logpracticecode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hddryweightdata`
--

DROP TABLE IF EXISTS `hddryweightdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hddryweightdata` (
  `drywt_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `drywtzid` mediumint(7) unsigned DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `adduid` smallint(4) unsigned DEFAULT NULL,
  `drywtassessdate` date DEFAULT NULL,
  `dryweight` decimal(4,1) unsigned DEFAULT NULL,
  `drywtassessor` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`drywt_id`),
  KEY `drywtzid` (`drywtzid`)
) ENGINE=InnoDB AUTO_INCREMENT=25222 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hdholsdata`
--

DROP TABLE IF EXISTS `hdholsdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hdholsdata` (
  `hdholsdata_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `holzid` mediumint(6) unsigned DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `startdate` date DEFAULT NULL,
  `enddate` date DEFAULT NULL,
  `holnotes` varchar(255) DEFAULT NULL,
  `adduid` smallint(4) DEFAULT NULL,
  `adduser` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`hdholsdata_id`),
  KEY `zid` (`holzid`)
) ENGINE=InnoDB AUTO_INCREMENT=392 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hdpatdata`
--

DROP TABLE IF EXISTS `hdpatdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hdpatdata` (
  `hdpatzid` mediumint(6) NOT NULL,
  `hdaddstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `hdmodifstamp` datetime DEFAULT NULL,
  `currsite` varchar(6) DEFAULT NULL,
  `currsched` enum('MonWedFri','TueThuSat') DEFAULT NULL,
  `hdtype` enum('HD','HDF-PRE','HDF-POST') DEFAULT 'HD',
  `needlesize` varchar(10) DEFAULT NULL,
  `singleneedle` char(1) DEFAULT NULL,
  `hours` varchar(10) DEFAULT NULL,
  `dialyser` varchar(20) DEFAULT NULL,
  `dialysate` varchar(20) DEFAULT NULL,
  `flowrate` smallint(4) DEFAULT NULL,
  `dialK` tinyint(1) DEFAULT NULL,
  `dialCa` decimal(3,1) DEFAULT NULL,
  `dialTemp` decimal(3,1) DEFAULT NULL,
  `dialBicarb` varchar(30) DEFAULT NULL,
  `dialNaProfiling` char(1) DEFAULT NULL,
  `dialNa1sthalf` tinyint(3) unsigned DEFAULT NULL,
  `dialNa2ndhalf` tinyint(3) unsigned DEFAULT NULL,
  `anticoagtype` varchar(30) DEFAULT NULL,
  `anticoagloaddose` varchar(20) DEFAULT NULL,
  `anticoaghourlydose` varchar(20) DEFAULT NULL,
  `anticoagstoptime` varchar(30) DEFAULT NULL,
  `prescriber` varchar(30) DEFAULT NULL,
  `prescriptdate` date DEFAULT NULL,
  `esdflag` char(1) DEFAULT NULL,
  `ironflag` char(1) DEFAULT NULL,
  `namednurse` varchar(20) DEFAULT NULL,
  `warfarinflag` char(1) DEFAULT NULL,
  `dryweight` decimal(4,1) DEFAULT NULL,
  `drywtassessdate` date DEFAULT NULL,
  `drywtassessor` varchar(30) DEFAULT NULL,
  `transport` char(1) DEFAULT NULL,
  `transportdecider` varchar(30) DEFAULT NULL,
  `transportdate` date DEFAULT NULL,
  `transporttype` varchar(100) DEFAULT NULL,
  `currslot` enum('AM','PM','Eve') DEFAULT NULL,
  `prefsite` varchar(20) DEFAULT NULL,
  `prefsched` enum('MonWedFri','TueThuSat') DEFAULT NULL,
  `prefslot` enum('AM','PM','Eve') DEFAULT NULL,
  `prefdate` date DEFAULT NULL,
  `prefnotes` varchar(255) DEFAULT NULL,
  `carelevelrequired` varchar(40) DEFAULT NULL,
  `careleveldate` date DEFAULT NULL,
  `lastavg_syst` smallint(3) unsigned DEFAULT NULL,
  `lastavg_diast` smallint(3) unsigned DEFAULT NULL,
  `cannulationtype` varchar(12) DEFAULT NULL,
  `lastavg_systpost` smallint(3) unsigned DEFAULT NULL,
  `lastavg_diastpost` smallint(3) unsigned DEFAULT NULL,
  UNIQUE KEY `hdpatzid` (`hdpatzid`),
  KEY `hdsitecode` (`currsite`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hdprofilehxdata`
--

DROP TABLE IF EXISTS `hdprofilehxdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hdprofilehxdata` (
  `hdprofile_id` mediumint(6) NOT NULL AUTO_INCREMENT,
  `hdprofilezid` mediumint(6) NOT NULL,
  `hdprofileaddstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `currsite` varchar(6) DEFAULT NULL,
  `currsched` enum('MonWedFri','TueThuSat') DEFAULT NULL,
  `hdtype` enum('HD','HDF-PRE','HDF-POST') DEFAULT 'HD',
  `needlesize` varchar(10) DEFAULT NULL,
  `singleneedle` char(1) DEFAULT NULL,
  `hours` varchar(10) DEFAULT NULL,
  `dialyser` varchar(20) DEFAULT NULL,
  `dialysate` varchar(20) DEFAULT NULL,
  `flowrate` smallint(4) DEFAULT NULL,
  `dialK` tinyint(1) DEFAULT NULL,
  `dialCa` decimal(3,1) DEFAULT NULL,
  `dialTemp` decimal(3,1) DEFAULT NULL,
  `dialBicarb` varchar(30) DEFAULT NULL,
  `dialNaProfiling` char(1) DEFAULT NULL,
  `dialNa1sthalf` tinyint(3) unsigned DEFAULT NULL,
  `dialNa2ndhalf` tinyint(3) unsigned DEFAULT NULL,
  `anticoagtype` varchar(30) DEFAULT NULL,
  `anticoagloaddose` varchar(20) DEFAULT NULL,
  `anticoaghourlydose` varchar(20) DEFAULT NULL,
  `anticoagstoptime` varchar(30) DEFAULT NULL,
  `prescriber` varchar(30) DEFAULT NULL,
  `prescriptdate` date DEFAULT NULL,
  `esdflag` char(1) DEFAULT NULL,
  `ironflag` char(1) DEFAULT NULL,
  `namednurse` varchar(20) DEFAULT NULL,
  `warfarinflag` char(1) DEFAULT NULL,
  `dryweight` decimal(4,1) DEFAULT NULL,
  `drywtassessdate` date DEFAULT NULL,
  `drywtassessor` varchar(30) DEFAULT NULL,
  `transport` char(1) DEFAULT NULL,
  `transportdecider` varchar(30) DEFAULT NULL,
  `transportdate` date DEFAULT NULL,
  `transporttype` varchar(100) DEFAULT NULL,
  `currslot` enum('AM','PM','Eve') DEFAULT NULL,
  `prefsite` varchar(20) DEFAULT NULL,
  `prefsched` enum('MonWedFri','TueThuSat') DEFAULT NULL,
  `prefslot` enum('AM','PM','Eve') DEFAULT NULL,
  `prefdate` date DEFAULT NULL,
  `prefnotes` varchar(255) DEFAULT NULL,
  `carelevelrequired` varchar(40) DEFAULT NULL,
  `careleveldate` date DEFAULT NULL,
  `cannulationtype` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`hdprofile_id`),
  KEY `hdprofilezid` (`hdprofilezid`)
) ENGINE=InnoDB AUTO_INCREMENT=21674 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hdsessiondata`
--

DROP TABLE IF EXISTS `hdsessiondata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hdsessiondata` (
  `hdsession_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `hdsesszid` mediumint(6) unsigned DEFAULT NULL,
  `hdsessaddstamp` datetime DEFAULT NULL,
  `hdsessmodifstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `hdsessuser` varchar(30) DEFAULT NULL,
  `hdsessdate` date DEFAULT NULL,
  `sitecode` varchar(20) DEFAULT NULL,
  `schedule` enum('MonWedFri','TueThuSat') DEFAULT NULL,
  `hdtype` enum('HD','HDF') DEFAULT 'HD',
  `modalcode` varchar(30) DEFAULT NULL,
  `timeon` char(6) DEFAULT NULL,
  `timeoff` char(6) DEFAULT NULL,
  `wt_pre` decimal(4,1) DEFAULT NULL,
  `wt_post` decimal(4,1) DEFAULT NULL,
  `weightchange` decimal(3,1) DEFAULT NULL,
  `pulse_pre` tinyint(3) unsigned DEFAULT NULL,
  `pulse_post` tinyint(3) unsigned DEFAULT NULL,
  `syst_pre` smallint(3) unsigned DEFAULT NULL,
  `syst_post` smallint(3) unsigned DEFAULT NULL,
  `diast_pre` smallint(3) unsigned DEFAULT NULL,
  `diast_post` smallint(3) unsigned DEFAULT NULL,
  `temp_pre` decimal(3,1) DEFAULT NULL,
  `temp_post` decimal(3,1) DEFAULT NULL,
  `BM_pre` varchar(5) DEFAULT NULL,
  `BM_post` varchar(5) DEFAULT NULL,
  `AP` smallint(3) DEFAULT NULL,
  `VP` smallint(3) DEFAULT NULL,
  `fluidremoved` decimal(2,1) DEFAULT NULL,
  `bloodflow` smallint(4) DEFAULT NULL,
  `UFR` decimal(3,2) DEFAULT NULL,
  `machineURR` tinyint(3) unsigned DEFAULT NULL,
  `machineKTV` decimal(2,1) unsigned DEFAULT NULL,
  `machineNo` varchar(5) DEFAULT NULL,
  `litresproc` varchar(10) DEFAULT NULL,
  `evaluation` tinytext,
  `signon` varchar(20) DEFAULT NULL,
  `signoff` varchar(20) DEFAULT NULL,
  `submitflag` tinyint(1) DEFAULT '0',
  `firstuseflag` tinyint(1) DEFAULT NULL,
  `subsfluidpct` tinyint(2) unsigned DEFAULT NULL,
  `subsgoal` decimal(4,2) DEFAULT NULL,
  `subsrate` decimal(4,2) DEFAULT NULL,
  `subsvol` decimal(4,2) DEFAULT NULL,
  `access` varchar(50) DEFAULT NULL,
  `dressingchangeflag` tinyint(1) DEFAULT NULL,
  `mrsaswabflag` tinyint(1) unsigned DEFAULT '0',
  `accesssitestatus` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`hdsession_id`),
  KEY `hdsessrid` (`hdsesszid`),
  KEY `hdsessdate` (`hdsessdate`)
) ENGINE=InnoDB AUTO_INCREMENT=677900 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hl7feed2`
--

DROP TABLE IF EXISTS `hl7feed2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hl7feed2` (
  `hl7feed_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `feedstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg_id` int(9) unsigned DEFAULT NULL,
  `msgtype` char(3) DEFAULT NULL,
  `eventtype` char(3) DEFAULT NULL,
  `msgpid` char(7) DEFAULT NULL,
  `processflag` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `msgdata` text,
  PRIMARY KEY (`hl7feed_id`),
  KEY `mshtype` (`msgtype`),
  KEY `processflag` (`processflag`),
  KEY `eventtype` (`eventtype`),
  KEY `mshpid` (`msgpid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hl7patientdata`
--

DROP TABLE IF EXISTS `hl7patientdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hl7patientdata` (
  `patient_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `modifstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `addstamp` datetime DEFAULT NULL,
  `adddate` date DEFAULT NULL,
  `lastmsg_id` int(10) unsigned DEFAULT NULL,
  `lastmshdatetime` datetime DEFAULT NULL,
  `lasteventcode` char(3) DEFAULT NULL,
  `kchno` char(7) DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `firstname` varchar(30) DEFAULT NULL,
  `middlename` varchar(30) DEFAULT NULL,
  `prefix` varchar(6) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `sex` enum('MALE','FEMALE') DEFAULT NULL,
  `nhsno` char(10) DEFAULT NULL,
  `addr_street` varchar(30) DEFAULT NULL,
  `addr_other` varchar(30) DEFAULT NULL,
  `addr_city` varchar(30) DEFAULT NULL,
  `addr_stateprov` varchar(30) DEFAULT NULL,
  `addr_postcode` varchar(14) DEFAULT NULL,
  `addr_country` varchar(20) DEFAULT NULL,
  `countycode` varchar(9) DEFAULT NULL,
  `phone_home` varchar(30) DEFAULT NULL,
  `phone_business` varchar(15) DEFAULT NULL,
  `maritalstatus` varchar(10) DEFAULT NULL,
  `deathdatetime` datetime DEFAULT NULL,
  `deathyn` char(1) DEFAULT NULL,
  `providernameaddr` varchar(255) DEFAULT NULL,
  `providertypecode` varchar(5) DEFAULT NULL,
  `practicecode` char(6) DEFAULT NULL,
  `gp_id` char(8) DEFAULT NULL,
  `gp_lastname` varchar(20) DEFAULT NULL,
  `gp_givenname` varchar(20) DEFAULT NULL,
  `gp_middlename` varchar(20) DEFAULT NULL,
  `birthplace` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `kchno` (`kchno`),
  KEY `nhsno` (`nhsno`),
  KEY `lastname` (`lastname`),
  KEY `firstname` (`firstname`),
  KEY `birthdate` (`birthdate`),
  KEY `gp_id` (`gp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `homehdassessdata`
--

DROP TABLE IF EXISTS `homehdassessdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `homehdassessdata` (
  `homehdassess_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `homehdassessstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `homehdassesszid` mediumint(7) unsigned DEFAULT NULL,
  `homehdassess_uid` smallint(4) unsigned DEFAULT NULL,
  `homehdassessuser` varchar(20) DEFAULT NULL,
  `referraldate` date DEFAULT NULL,
  `selfcarelevel` varchar(40) DEFAULT NULL,
  `selfcarenotes` text,
  `medicalassess` text,
  `medicaldate` date DEFAULT NULL,
  `technicalassess` text,
  `technicaldate` date DEFAULT NULL,
  `socialworkassess` text,
  `socialworkdate` date DEFAULT NULL,
  `counsellorassess` text,
  `counsellordate` date DEFAULT NULL,
  `fullindepconfirm` text,
  `fullindepconfirmdate` date DEFAULT NULL,
  `programmetype` varchar(40) DEFAULT NULL,
  `carername` varchar(100) DEFAULT NULL,
  `carernotes` text,
  `acceptancedate` date DEFAULT NULL,
  `equipinstalldate` date DEFAULT NULL,
  `firstdeliverydate` date DEFAULT NULL,
  `trainingstartdate` date DEFAULT NULL,
  `firstindepdialdate` date DEFAULT NULL,
  `assessmentnotes` text,
  `assessor` varchar(100) DEFAULT NULL,
  `housingtype` varchar(30) DEFAULT NULL,
  `letterwrittentype` varchar(30) DEFAULT NULL,
  `letterwrittendate` date DEFAULT NULL,
  `letterrecvtype` varchar(30) DEFAULT NULL,
  `letterrecvdate` date DEFAULT NULL,
  PRIMARY KEY (`homehdassess_id`),
  UNIQUE KEY `homehdassesszid` (`homehdassesszid`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `immunosupprepeatrxdata`
--

DROP TABLE IF EXISTS `immunosupprepeatrxdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `immunosupprepeatrxdata` (
  `import_id` mediumint(6) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `importstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `importdate` date DEFAULT NULL,
  `importuid` mediumint(5) unsigned DEFAULT NULL,
  `importuser` varchar(20) DEFAULT NULL,
  `rowno` smallint(3) unsigned DEFAULT NULL,
  `evolution_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `firstname` varchar(30) DEFAULT NULL,
  `surname` varchar(30) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `prescriber` varchar(30) DEFAULT NULL,
  `nextdelivdate` date DEFAULT NULL,
  `hospital` varchar(30) DEFAULT NULL,
  `hospno` varchar(12) DEFAULT NULL,
  `nhsno` varchar(12) DEFAULT NULL,
  `patientdx` varchar(24) DEFAULT NULL,
  `runflag` tinyint(1) unsigned DEFAULT '0',
  `runuid` mediumint(5) unsigned DEFAULT NULL,
  `runuser` varchar(20) DEFAULT NULL,
  `rundt` datetime DEFAULT NULL,
  PRIMARY KEY (`import_id`),
  UNIQUE KEY `hospno_2` (`hospno`,`nextdelivdate`),
  KEY `evolution_id` (`evolution_id`),
  KEY `hospno` (`hospno`),
  KEY `runflag` (`runflag`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `immunosupprxforms`
--

DROP TABLE IF EXISTS `immunosupprxforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `immunosupprxforms` (
  `rxform_id` mediumint(6) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `rxformstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `rxformdate` date DEFAULT NULL,
  `rxformzid` mediumint(7) unsigned NOT NULL DEFAULT '0',
  `rxformhospno` varchar(12) DEFAULT NULL,
  `med_ids` varchar(255) DEFAULT NULL,
  `rxformuid` smallint(4) unsigned NOT NULL DEFAULT '0',
  `rxformuser` varchar(20) NOT NULL DEFAULT 'rxformuser',
  `rxformmeds` varchar(255) DEFAULT NULL,
  `rxformhtml` text,
  PRIMARY KEY (`rxform_id`),
  KEY `rxformzid` (`rxformzid`),
  KEY `rxformuid` (`rxformuid`),
  KEY `med_ids` (`med_ids`),
  KEY `rxformhospno` (`rxformhospno`),
  KEY `rxformdate` (`rxformdate`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `immunosupprxmedlogs`
--

DROP TABLE IF EXISTS `immunosupprxmedlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `immunosupprxmedlogs` (
  `log_id` mediumint(6) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `logstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `logdate` date DEFAULT NULL,
  `logzid` mediumint(7) unsigned NOT NULL DEFAULT '0',
  `loghospno` varchar(12) DEFAULT NULL,
  `rxform_id` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `med_id` int(9) unsigned NOT NULL DEFAULT '0',
  `loguid` smallint(4) unsigned NOT NULL DEFAULT '0',
  `loguser` varchar(20) NOT NULL DEFAULT 'loguser',
  PRIMARY KEY (`log_id`),
  UNIQUE KEY `med_id` (`med_id`),
  KEY `logzid` (`logzid`),
  KEY `loguid` (`loguid`),
  KEY `loghospno` (`loghospno`),
  KEY `rxform_id` (`rxform_id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `irondosedata`
--

DROP TABLE IF EXISTS `irondosedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `irondosedata` (
  `irondose_id` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `irondosezid` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `irondoseuid` smallint(4) unsigned NOT NULL DEFAULT '0',
  `irondoseuser` varchar(20) DEFAULT NULL,
  `irondosestamp` datetime DEFAULT NULL,
  `irondosedate` date DEFAULT NULL,
  `irondose` varchar(12) DEFAULT NULL,
  `irondosetype` varchar(12) DEFAULT NULL,
  `irondosebatch` varchar(12) DEFAULT NULL,
  `irondosecomments` tinytext,
  PRIMARY KEY (`irondose_id`),
  KEY `irondosedate` (`irondosedate`),
  KEY `irondosebatch` (`irondosebatch`),
  KEY `irondosezid` (`irondosezid`)
) ENGINE=InnoDB AUTO_INCREMENT=3030 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ixcodes`
--

DROP TABLE IF EXISTS `ixcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ixcodes` (
  `ixcode` varchar(10) DEFAULT NULL,
  `ixname` varchar(40) DEFAULT NULL,
  UNIQUE KEY `ixcode` (`ixcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ixworkupdata`
--

DROP TABLE IF EXISTS `ixworkupdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ixworkupdata` (
  `ixworkupdata_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `ixworkupzid` mediumint(6) unsigned DEFAULT NULL,
  `ixworkupuser` varchar(30) DEFAULT NULL,
  `ixworkupaddstamp` datetime DEFAULT NULL,
  `ixworkupmodal` varchar(50) DEFAULT NULL,
  `ixworkupdate` date DEFAULT NULL,
  `ixworkuptype` varchar(100) DEFAULT NULL,
  `ixworkupresults` varchar(255) DEFAULT NULL,
  `ixworkuptext` text,
  `currflag` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`ixworkupdata_id`),
  KEY `ixworkupzid` (`ixworkupzid`),
  KEY `ixworkupuid` (`ixworkupuser`),
  KEY `ixworkuptype` (`ixworkuptype`),
  KEY `currflag` (`currflag`)
) ENGINE=InnoDB AUTO_INCREMENT=8745 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `letterccdata`
--

DROP TABLE IF EXISTS `letterccdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `letterccdata` (
  `lettercc_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `ccstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ccstatus` enum('draft','sent','read') DEFAULT 'draft',
  `cc_uid` smallint(4) unsigned DEFAULT NULL,
  `ccuser` varchar(20) DEFAULT NULL,
  `recip_uid` smallint(4) unsigned DEFAULT NULL,
  `recipuser` varchar(20) DEFAULT NULL,
  `ccletter_id` mediumint(7) DEFAULT NULL,
  `cczid` mediumint(7) DEFAULT NULL,
  `readstamp` datetime DEFAULT NULL,
  `sentstamp` datetime DEFAULT NULL,
  PRIMARY KEY (`lettercc_id`),
  KEY `cc_uid` (`cc_uid`),
  KEY `recip_uid` (`recip_uid`),
  KEY `ccstatus` (`ccstatus`),
  KEY `ccletter_id` (`ccletter_id`),
  KEY `cczid` (`cczid`)
) ENGINE=InnoDB AUTO_INCREMENT=38042 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `letterdata`
--

DROP TABLE IF EXISTS `letterdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `letterdata` (
  `letter_id` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `letterzid` mediumint(6) unsigned DEFAULT NULL,
  `letthospno` char(7) DEFAULT NULL,
  `lettuid` smallint(3) unsigned DEFAULT NULL,
  `lettuser` varchar(20) DEFAULT NULL,
  `lettaddstamp` datetime DEFAULT NULL,
  `lettmodifstamp` datetime DEFAULT NULL,
  `authorid` smallint(3) unsigned DEFAULT NULL,
  `typistid` smallint(3) unsigned DEFAULT NULL,
  `typistinits` char(6) DEFAULT NULL,
  `letterdate` date DEFAULT NULL,
  `lettertype` enum('clinic','simple','discharge','death','other') DEFAULT 'clinic',
  `clinicdate` date DEFAULT NULL,
  `printdate` date DEFAULT NULL,
  `status` enum('DRAFT','TYPED','ARCHIVED','UNPRINTED') DEFAULT NULL,
  `lettertype_id` smallint(3) unsigned DEFAULT NULL,
  `lettdescr` varchar(100) DEFAULT NULL,
  `patlastfirst` varchar(50) DEFAULT NULL,
  `authorlastfirst` varchar(40) DEFAULT NULL,
  `authorsig` varchar(50) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `recipname` varchar(100) DEFAULT NULL,
  `recipient` text,
  `salut` varchar(60) DEFAULT NULL,
  `patref` varchar(255) DEFAULT NULL,
  `pataddr` varchar(255) DEFAULT NULL,
  `lettproblems` text,
  `lettmeds` text,
  `lettresults` text,
  `lettBPsyst` smallint(3) unsigned DEFAULT NULL,
  `lettBPdiast` tinyint(3) unsigned DEFAULT NULL,
  `lettWeight` decimal(4,1) unsigned DEFAULT NULL,
  `lettHeight` decimal(3,2) unsigned DEFAULT NULL,
  `letturine_blood` varchar(6) DEFAULT NULL,
  `letturine_prot` varchar(6) DEFAULT NULL,
  `lettallergies` varchar(200) DEFAULT NULL,
  `cctext` text,
  `printstage` tinyint(1) unsigned DEFAULT '0',
  `modalstamp` varchar(15) DEFAULT NULL,
  `elecsig` tinytext,
  `admissionid` mediumint(6) unsigned DEFAULT NULL,
  `admdate` date DEFAULT NULL,
  `admward` varchar(20) DEFAULT NULL,
  `dischdate` date DEFAULT NULL,
  `dischdest` varchar(100) DEFAULT NULL,
  `admconsultant` varchar(50) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `deathcause` varchar(255) DEFAULT NULL,
  `archiveflag` tinyint(1) DEFAULT '0',
  `typeddate` date DEFAULT NULL,
  `reviewdate` date DEFAULT NULL,
  `wordcount` smallint(4) unsigned DEFAULT '0',
  PRIMARY KEY (`letter_id`),
  KEY `zid` (`letterzid`),
  KEY `lettuser` (`lettuser`),
  KEY `authorid` (`authorid`),
  KEY `lettuid` (`lettuid`),
  KEY `archiveflag` (`archiveflag`),
  KEY `patlastfirst` (`patlastfirst`),
  KEY `admissionid` (`admissionid`),
  KEY `typistid` (`typistid`),
  KEY `printstage` (`printstage`),
  KEY `admdate` (`admdate`)
) ENGINE=InnoDB AUTO_INCREMENT=325483 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `letterdescrlist`
--

DROP TABLE IF EXISTS `letterdescrlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `letterdescrlist` (
  `lettertype_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `letterdescruid` smallint(4) unsigned DEFAULT NULL,
  `letterdescr` varchar(100) DEFAULT NULL,
  `letterdescrstamp` datetime DEFAULT NULL,
  `clinicflag` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`lettertype_id`),
  KEY `lettertypeuid` (`letterdescruid`)
) ENGINE=InnoDB AUTO_INCREMENT=1146 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `letterheadlist`
--

DROP TABLE IF EXISTS `letterheadlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `letterheadlist` (
  `letterhead_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `addstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sitecode` varchar(6) DEFAULT NULL,
  `unitinfo` varchar(30) DEFAULT NULL,
  `trustname` varchar(100) DEFAULT NULL,
  `trustcaption` varchar(30) DEFAULT NULL,
  `siteinfohtml` text,
  PRIMARY KEY (`letterhead_id`),
  UNIQUE KEY `sitecode` (`sitecode`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `letterindex`
--

DROP TABLE IF EXISTS `letterindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `letterindex` (
  `letterindex_id` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `letterzid` mediumint(6) unsigned DEFAULT NULL,
  `letterhospno` char(7) DEFAULT NULL,
  `letteruid` smallint(3) unsigned DEFAULT NULL,
  `letteruser` varchar(20) DEFAULT NULL,
  `createstamp` datetime DEFAULT NULL,
  `archivestamp` datetime DEFAULT NULL,
  `authorid` smallint(3) unsigned DEFAULT NULL,
  `typistid` smallint(3) unsigned DEFAULT NULL,
  `typistinits` char(6) DEFAULT NULL,
  `lettertype` enum('clinic','simple','discharge','death','other') DEFAULT 'clinic',
  `clinicdate` date DEFAULT NULL,
  `admissionid` mediumint(6) unsigned DEFAULT NULL,
  `admdate` date DEFAULT NULL,
  `dischdate` date DEFAULT NULL,
  `letterdate` date DEFAULT NULL,
  `createdate` date DEFAULT NULL,
  `typeddate` date DEFAULT NULL,
  `reviewdate` date DEFAULT NULL,
  `printdate` date DEFAULT NULL,
  `archivedate` date DEFAULT NULL,
  `wordcount` smallint(4) unsigned DEFAULT '0',
  `lettdescr_id` smallint(3) unsigned DEFAULT NULL,
  `lettdescr` varchar(100) DEFAULT NULL,
  `patlastfirst` varchar(50) DEFAULT NULL,
  `authorlastfirst` varchar(40) DEFAULT NULL,
  `recipname` varchar(100) DEFAULT NULL,
  `modalstamp` varchar(15) DEFAULT NULL,
  `lettertext` text,
  PRIMARY KEY (`letterindex_id`),
  KEY `zid` (`letterzid`),
  KEY `authorid` (`authorid`),
  KEY `lettuid` (`letteruid`),
  KEY `typistid` (`typistid`),
  KEY `admdate` (`admdate`),
  KEY `lettertype` (`lettertype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lettertemplates`
--

DROP TABLE IF EXISTS `lettertemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lettertemplates` (
  `template_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `templateuid` smallint(4) unsigned DEFAULT NULL,
  `templatename` varchar(100) DEFAULT NULL,
  `templatetext` text,
  `templatestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`template_id`),
  KEY `userid` (`templateuid`)
) ENGINE=InnoDB AUTO_INCREMENT=2160 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lettertextdata`
--

DROP TABLE IF EXISTS `lettertextdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lettertextdata` (
  `lettertext_id` mediumint(6) unsigned NOT NULL DEFAULT '1',
  `lettertextzid` mediumint(6) unsigned NOT NULL DEFAULT '1',
  `lettertextuid` smallint(3) unsigned NOT NULL DEFAULT '1',
  `addstamp` datetime DEFAULT NULL,
  `modifstamp` datetime DEFAULT NULL,
  `archivestamp` datetime DEFAULT NULL,
  `deletestamp` datetime DEFAULT NULL,
  `ltext` text,
  `lfulltext` text,
  `deleteflag` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`lettertext_id`),
  KEY `lettzid` (`lettertextzid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `linesepsisdata`
--

DROP TABLE IF EXISTS `linesepsisdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linesepsisdata` (
  `linesepsisdata_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `linesepsiszid` mediumint(6) DEFAULT NULL,
  `bloodculturedate` date DEFAULT NULL,
  `cultureorg1` varchar(50) DEFAULT NULL,
  `cultureorg2` varchar(50) DEFAULT NULL,
  `cultureorg_other` varchar(50) DEFAULT NULL,
  `swabdate` date DEFAULT NULL,
  `swaborg1` varchar(50) DEFAULT NULL,
  `swaborg2` varchar(50) DEFAULT NULL,
  `swaborg_other` varchar(50) DEFAULT NULL,
  `Oralantibioticflag` char(1) DEFAULT NULL,
  `IVantibioticflag` char(1) DEFAULT NULL,
  `antibiotics` varchar(255) DEFAULT NULL,
  `linesepsisnotes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`linesepsisdata_id`),
  KEY `linesepsiszid` (`linesepsiszid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lupusbxdata`
--

DROP TABLE IF EXISTS `lupusbxdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lupusbxdata` (
  `lupusbx_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `lupusbxstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lupusbxuid` smallint(4) unsigned DEFAULT NULL,
  `lupusbxuser` varchar(20) DEFAULT NULL,
  `lupusbxzid` mediumint(7) unsigned DEFAULT NULL,
  `lupusbxadddate` date DEFAULT NULL,
  `lupusbxdate` date DEFAULT NULL,
  `lupusbxclass` varchar(12) DEFAULT NULL,
  `activityindex` tinyint(2) unsigned DEFAULT NULL,
  `chronicityindex` tinyint(2) unsigned DEFAULT NULL,
  `lupusbxnotes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`lupusbx_id`),
  KEY `lupusbxzid` (`lupusbxzid`),
  KEY `lupusbxuid` (`lupusbxuid`),
  KEY `lupusbxadddate` (`lupusbxadddate`),
  KEY `lupusbxdate` (`lupusbxdate`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lupusdata`
--

DROP TABLE IF EXISTS `lupusdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lupusdata` (
  `lupus_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `lupusstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lupusmodifdt` datetime DEFAULT NULL,
  `lupusuid` smallint(4) unsigned DEFAULT NULL,
  `lupususer` varchar(20) DEFAULT NULL,
  `lupuszid` mediumint(7) unsigned DEFAULT NULL,
  `lupusadddate` date DEFAULT NULL,
  `lupusmodifdate` date DEFAULT NULL,
  `lupusdxdate` date DEFAULT NULL,
  `anatitre_dxdate` date DEFAULT NULL,
  `anatitre_dx` varchar(12) DEFAULT NULL,
  `dsdna_dxdate` date DEFAULT NULL,
  `dsdna_dx` varchar(12) DEFAULT NULL,
  `anticardiolipin` char(3) DEFAULT NULL,
  `ena_sm` char(1) DEFAULT NULL,
  `ena_la` char(1) DEFAULT NULL,
  `ena_ro` char(1) DEFAULT NULL,
  `ena_jo1` char(1) DEFAULT NULL,
  `ena_scl70` char(1) DEFAULT NULL,
  `ena_rnp` char(1) DEFAULT NULL,
  `lastbxdate` date DEFAULT NULL,
  `lupusclass` varchar(12) DEFAULT NULL,
  `lupusnotes` text,
  PRIMARY KEY (`lupus_id`),
  KEY `lupuszid` (`lupuszid`),
  KEY `lupusuid` (`lupusuid`)
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medsdata`
--

DROP TABLE IF EXISTS `medsdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medsdata` (
  `medsdata_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `medzid` mediumint(6) unsigned DEFAULT NULL,
  `modifstamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `drug_id` smallint(4) DEFAULT NULL,
  `drugname` varchar(100) DEFAULT NULL,
  `dose` varchar(40) DEFAULT NULL,
  `route` varchar(12) DEFAULT NULL,
  `freq` varchar(30) DEFAULT NULL,
  `drugnotes` varchar(255) DEFAULT NULL,
  `adddate` date DEFAULT NULL,
  `termdate` date DEFAULT NULL,
  `medmodal` varchar(100) DEFAULT NULL,
  `esdflag` tinyint(1) unsigned DEFAULT '0',
  `esdunitsperweek` mediumint(6) DEFAULT '0',
  `immunosuppflag` tinyint(1) unsigned DEFAULT '0',
  `termflag` tinyint(1) unsigned DEFAULT '0',
  `adduid` smallint(4) DEFAULT NULL,
  `adduser` varchar(20) DEFAULT NULL,
  `termuser` varchar(20) DEFAULT NULL,
  `prescriber` varchar(8) DEFAULT NULL,
  `provider` varchar(8) DEFAULT NULL,
  `printflag` tinyint(1) unsigned DEFAULT '0',
  `printdate` date DEFAULT NULL,
  `printdt` datetime DEFAULT NULL,
  `printuid` smallint(4) unsigned DEFAULT NULL,
  PRIMARY KEY (`medsdata_id`),
  KEY `zid` (`medzid`),
  KEY `drug_id` (`drug_id`),
  KEY `adduid` (`adduid`),
  KEY `termflag` (`termflag`),
  KEY `printflag` (`printflag`)
) ENGINE=InnoDB AUTO_INCREMENT=318438 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `messagedata`
--

DROP TABLE IF EXISTS `messagedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messagedata` (
  `message_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `messagestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message_uid` smallint(4) unsigned DEFAULT NULL,
  `messageuser` varchar(20) DEFAULT NULL,
  `recip_uid` smallint(4) unsigned DEFAULT NULL,
  `recipuser` varchar(20) DEFAULT NULL,
  `messagezid` mediumint(7) DEFAULT NULL,
  `messagesubj` varchar(100) DEFAULT NULL,
  `messagetext` text,
  `readflag` enum('0','1') DEFAULT '0',
  `readstamp` datetime DEFAULT NULL,
  `urgentflag` enum('0','1') DEFAULT '0',
  PRIMARY KEY (`message_id`),
  KEY `message_uid` (`message_uid`),
  KEY `recip_uid` (`recip_uid`),
  KEY `readflag` (`readflag`),
  KEY `messagezid` (`messagezid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `midasdata`
--

DROP TABLE IF EXISTS `midasdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `midasdata` (
  `midas_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `importstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `hospno` char(7) DEFAULT NULL,
  `surname` varchar(40) DEFAULT NULL,
  `forename` varchar(50) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `sampledate` date DEFAULT NULL,
  `testtype_id` tinyint(2) DEFAULT NULL,
  `testtype` varchar(40) DEFAULT NULL,
  `qualifier` enum('','-','>','<','>=','=<') DEFAULT NULL,
  `result` decimal(6,2) DEFAULT NULL,
  `creationtime` date DEFAULT NULL,
  PRIMARY KEY (`midas_id`),
  KEY `hospno` (`hospno`),
  KEY `sampledate` (`sampledate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `midasfeeddata`
--

DROP TABLE IF EXISTS `midasfeeddata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `midasfeeddata` (
  `midas_id` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `importstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `midasrequestcode` varchar(16) DEFAULT NULL,
  `msgdatetime` datetime DEFAULT NULL,
  `obr_obsdatetime` datetime DEFAULT NULL,
  `kchno` varchar(12) DEFAULT NULL,
  `patlastfirst` varchar(30) DEFAULT NULL,
  `orc_ordernumber` varchar(12) DEFAULT NULL,
  `obr_testtype` varchar(24) DEFAULT NULL,
  `obx_resultvalue` varchar(12) DEFAULT NULL,
  `obx_resultunits` varchar(12) DEFAULT NULL,
  `nte_notes` text,
  PRIMARY KEY (`midas_id`),
  KEY `kchno` (`kchno`),
  KEY `obr_testtype` (`obr_testtype`),
  KEY `obx_resultvalue` (`obx_resultvalue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modalcodeslist`
--

DROP TABLE IF EXISTS `modalcodeslist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modalcodeslist` (
  `modalcode_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `modalcode` varchar(20) DEFAULT NULL,
  `modality` varchar(100) DEFAULT NULL,
  `rrmodalcode` char(2) DEFAULT NULL,
  PRIMARY KEY (`modalcode_id`),
  UNIQUE KEY `modalcode` (`modalcode`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modaldata`
--

DROP TABLE IF EXISTS `modaldata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modaldata` (
  `modal_id` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `modalzid` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `modalcode` varchar(20) DEFAULT NULL,
  `modalsitecode` varchar(10) DEFAULT NULL,
  `modalstamp` datetime DEFAULT NULL,
  `modaldate` date DEFAULT NULL,
  `modalnotes` varchar(100) DEFAULT NULL,
  `modaluser` varchar(20) DEFAULT NULL,
  `rrmodalcode` char(2) DEFAULT NULL,
  `modaltermdate` date DEFAULT NULL,
  PRIMARY KEY (`modal_id`),
  KEY `modalzid` (`modalzid`),
  KEY `modalcode` (`modalcode`),
  KEY `modaldate` (`modaldate`),
  KEY `rrmodalcode` (`rrmodalcode`)
) ENGINE=InnoDB AUTO_INCREMENT=46162 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mrsadata`
--

DROP TABLE IF EXISTS `mrsadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrsadata` (
  `mrsa_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `swabstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mrsazid` mediumint(7) unsigned DEFAULT NULL,
  `swabuid` smallint(4) unsigned DEFAULT NULL,
  `swabuser` varchar(20) DEFAULT NULL,
  `swabadddate` date DEFAULT NULL,
  `swabdate` date DEFAULT NULL,
  `swabsite` varchar(60) DEFAULT NULL,
  `resultstamp` datetime DEFAULT NULL,
  `resultuser` varchar(20) DEFAULT NULL,
  `resultdate` date DEFAULT NULL,
  `swabresult` enum('POS','NEG') DEFAULT NULL,
  PRIMARY KEY (`mrsa_id`),
  KEY `mrsazid` (`mrsazid`),
  KEY `swabdate` (`swabdate`),
  KEY `swabresult` (`swabresult`)
) ENGINE=InnoDB AUTO_INCREMENT=14045 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `newadtdata`
--

DROP TABLE IF EXISTS `newadtdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newadtdata` (
  `newmsh_id` mediumint(8) NOT NULL DEFAULT '0',
  `newmshdata` text,
  PRIMARY KEY (`newmsh_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `newhl7data`
--

DROP TABLE IF EXISTS `newhl7data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newhl7data` (
  `newfeed_id` int(9) unsigned NOT NULL DEFAULT '0',
  `feedstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msg_id` int(9) unsigned DEFAULT NULL,
  `msgtype` char(3) DEFAULT NULL,
  `eventtype` char(3) DEFAULT NULL,
  `msgpid` char(7) DEFAULT NULL,
  `processflag` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `msgdata` text,
  PRIMARY KEY (`newfeed_id`),
  KEY `mshtype` (`msgtype`),
  KEY `processflag` (`processflag`),
  KEY `eventtype` (`eventtype`),
  KEY `mshpid` (`msgpid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `optionlists`
--

DROP TABLE IF EXISTS `optionlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optionlists` (
  `option_id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `liststamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `listname` varchar(30) DEFAULT NULL,
  `listhtml` text,
  `listmodifdt` datetime DEFAULT NULL,
  `listmodifuser` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`option_id`),
  KEY `listname` (`listname`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pageviews`
--

DROP TABLE IF EXISTS `pageviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pageviews` (
  `page_uid` smallint(4) unsigned DEFAULT NULL,
  `page_uri` varchar(100) DEFAULT NULL,
  `pagestamp` datetime DEFAULT NULL,
  `pagezid` mediumint(7) unsigned DEFAULT NULL,
  `session_id` mediumint(7) unsigned DEFAULT NULL,
  `user` varchar(30) DEFAULT NULL,
  `page_title` varchar(150) DEFAULT NULL
) ENGINE=ARCHIVE DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathol_current`
--

DROP TABLE IF EXISTS `pathol_current`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pathol_current` (
  `currentpath_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `currentpid` varchar(12) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `adddate` date DEFAULT NULL,
  `modifstamp` datetime DEFAULT NULL,
  `modifdate` date DEFAULT NULL,
  `ACRAstamp` datetime DEFAULT NULL,
  `ACRA` decimal(5,1) unsigned DEFAULT NULL,
  `AFPstamp` datetime DEFAULT NULL,
  `AFP` smallint(3) DEFAULT NULL,
  `ALBstamp` datetime DEFAULT NULL,
  `ALB` smallint(3) DEFAULT NULL,
  `ALPstamp` datetime DEFAULT NULL,
  `ALP` smallint(3) DEFAULT NULL,
  `ALTstamp` datetime DEFAULT NULL,
  `ALT` smallint(3) DEFAULT NULL,
  `ALstamp` datetime DEFAULT NULL,
  `AL` decimal(3,1) DEFAULT NULL,
  `AMYstamp` datetime DEFAULT NULL,
  `AMY` smallint(4) DEFAULT NULL,
  `ANAstamp` datetime DEFAULT NULL,
  `ANA` varchar(8) DEFAULT NULL,
  `ANCAstamp` datetime DEFAULT NULL,
  `ANCA` varchar(8) DEFAULT NULL,
  `APTHstamp` datetime DEFAULT NULL,
  `APTH` decimal(3,2) DEFAULT NULL,
  `APTRstamp` datetime DEFAULT NULL,
  `APTR` decimal(3,2) DEFAULT NULL,
  `ASMstamp` datetime DEFAULT NULL,
  `ASM` varchar(8) DEFAULT NULL,
  `ASTstamp` datetime DEFAULT NULL,
  `AST` smallint(3) DEFAULT NULL,
  `B12stamp` datetime DEFAULT NULL,
  `B12` int(6) DEFAULT NULL,
  `BGLUstamp` datetime DEFAULT NULL,
  `BGLU` decimal(3,1) DEFAULT NULL,
  `BICstamp` datetime DEFAULT NULL,
  `BIC` smallint(3) DEFAULT NULL,
  `BILstamp` datetime DEFAULT NULL,
  `BIL` smallint(3) DEFAULT NULL,
  `C125stamp` datetime DEFAULT NULL,
  `C125` smallint(3) DEFAULT NULL,
  `C199stamp` datetime DEFAULT NULL,
  `C199` smallint(3) DEFAULT NULL,
  `C3stamp` datetime DEFAULT NULL,
  `C3` decimal(3,2) DEFAULT NULL,
  `C4stamp` datetime DEFAULT NULL,
  `C4` decimal(3,2) DEFAULT NULL,
  `CAERstamp` datetime DEFAULT NULL,
  `CAER` decimal(3,2) DEFAULT NULL,
  `CALstamp` datetime DEFAULT NULL,
  `CAL` decimal(3,2) DEFAULT NULL,
  `CCAstamp` datetime DEFAULT NULL,
  `CCA` decimal(3,2) DEFAULT NULL,
  `CEAstamp` datetime DEFAULT NULL,
  `CEA` smallint(3) DEFAULT NULL,
  `CHOLstamp` datetime DEFAULT NULL,
  `CHOL` decimal(3,1) DEFAULT NULL,
  `CKstamp` datetime DEFAULT NULL,
  `CK` smallint(3) DEFAULT NULL,
  `CRCLstamp` datetime DEFAULT NULL,
  `CRCL` smallint(3) DEFAULT NULL,
  `CREstamp` datetime DEFAULT NULL,
  `CRE` smallint(4) DEFAULT NULL,
  `CRPstamp` datetime DEFAULT NULL,
  `CRP` decimal(4,1) DEFAULT NULL,
  `CUstamp` datetime DEFAULT NULL,
  `CU` varchar(8) DEFAULT NULL,
  `CYAstamp` datetime DEFAULT NULL,
  `CYA` char(5) DEFAULT NULL,
  `DNAstamp` datetime DEFAULT NULL,
  `DNA` varchar(8) DEFAULT NULL,
  `FERstamp` datetime DEFAULT NULL,
  `FER` smallint(3) DEFAULT NULL,
  `FIBstamp` datetime DEFAULT NULL,
  `FIB` decimal(3,1) DEFAULT NULL,
  `FOLstamp` datetime DEFAULT NULL,
  `FOL` decimal(3,1) DEFAULT NULL,
  `GGTstamp` datetime DEFAULT NULL,
  `GGT` smallint(3) DEFAULT NULL,
  `GLOstamp` datetime DEFAULT NULL,
  `GLO` smallint(3) DEFAULT NULL,
  `HBAIstamp` datetime DEFAULT NULL,
  `HBAI` int(3) unsigned DEFAULT NULL,
  `HBAstamp` datetime DEFAULT NULL,
  `HBA` decimal(3,1) DEFAULT NULL,
  `HBstamp` datetime DEFAULT NULL,
  `HB` decimal(3,1) DEFAULT NULL,
  `HDLstamp` datetime DEFAULT NULL,
  `HDL` decimal(2,1) DEFAULT NULL,
  `HYPOstamp` datetime DEFAULT NULL,
  `HYPO` decimal(3,1) unsigned DEFAULT NULL,
  `ESRRstamp` datetime DEFAULT NULL,
  `ESRR` smallint(3) DEFAULT NULL,
  `IGLAstamp` datetime DEFAULT NULL,
  `IGLA` decimal(3,2) DEFAULT NULL,
  `IGLGstamp` datetime DEFAULT NULL,
  `IGLG` decimal(4,2) DEFAULT NULL,
  `IGLMstamp` datetime DEFAULT NULL,
  `IGLM` decimal(3,2) DEFAULT NULL,
  `INRstamp` datetime DEFAULT NULL,
  `INR` decimal(3,2) DEFAULT NULL,
  `LDLstamp` datetime DEFAULT NULL,
  `LDL` decimal(2,1) DEFAULT NULL,
  `LKMstamp` datetime DEFAULT NULL,
  `LKM` varchar(8) DEFAULT NULL,
  `LYMstamp` datetime DEFAULT NULL,
  `LYM` decimal(4,2) DEFAULT NULL,
  `MCHstamp` datetime DEFAULT NULL,
  `MCH` decimal(4,1) DEFAULT NULL,
  `MCVstamp` datetime DEFAULT NULL,
  `MCV` decimal(4,1) DEFAULT NULL,
  `MDRD` smallint(3) unsigned DEFAULT NULL,
  `MGstamp` datetime DEFAULT NULL,
  `MG` decimal(4,2) DEFAULT NULL,
  `MITOstamp` datetime DEFAULT NULL,
  `MITO` varchar(8) DEFAULT NULL,
  `NAstamp` datetime DEFAULT NULL,
  `NA` smallint(3) DEFAULT NULL,
  `NEUTstamp` datetime DEFAULT NULL,
  `NEUT` decimal(4,2) DEFAULT NULL,
  `PCRAstamp` datetime DEFAULT NULL,
  `PCRA` decimal(5,1) unsigned DEFAULT NULL,
  `PHOSstamp` datetime DEFAULT NULL,
  `PHOS` decimal(3,2) DEFAULT NULL,
  `PLTstamp` datetime DEFAULT NULL,
  `PLT` smallint(4) DEFAULT NULL,
  `POTstamp` datetime DEFAULT NULL,
  `POT` decimal(2,1) DEFAULT NULL,
  `PTHIstamp` datetime DEFAULT NULL,
  `PTHI` mediumint(4) unsigned DEFAULT NULL,
  `RETAstamp` datetime DEFAULT NULL,
  `RETA` decimal(4,1) DEFAULT NULL,
  `RFstamp` datetime DEFAULT NULL,
  `RF` decimal(4,1) DEFAULT NULL,
  `TPstamp` datetime DEFAULT NULL,
  `TP` smallint(3) DEFAULT NULL,
  `TRIGstamp` datetime DEFAULT NULL,
  `TRIG` decimal(4,1) DEFAULT NULL,
  `TSHstamp` datetime DEFAULT NULL,
  `TSH` decimal(4,2) DEFAULT NULL,
  `UALBstamp` datetime DEFAULT NULL,
  `UALB` varchar(8) DEFAULT NULL,
  `UPREstamp` datetime DEFAULT NULL,
  `UPRE` smallint(4) DEFAULT NULL,
  `UPROstamp` datetime DEFAULT NULL,
  `UPRO` varchar(8) DEFAULT NULL,
  `URATstamp` datetime DEFAULT NULL,
  `URAT` decimal(3,2) DEFAULT NULL,
  `UREPstamp` datetime DEFAULT NULL,
  `UREP` decimal(3,1) DEFAULT NULL,
  `UREstamp` datetime DEFAULT NULL,
  `URE` decimal(3,1) DEFAULT NULL,
  `URRstamp` datetime DEFAULT NULL,
  `URR` smallint(3) DEFAULT NULL,
  `WBCstamp` datetime DEFAULT NULL,
  `WBC` decimal(4,2) DEFAULT NULL,
  `BHBC` enum('Positive','Negative','Cancelled') DEFAULT NULL,
  `BHBCstamp` datetime DEFAULT NULL,
  `BHBS` varchar(12) DEFAULT NULL,
  `BHBSstamp` datetime DEFAULT NULL,
  `BHCV` varchar(12) DEFAULT NULL,
  `BHCVstamp` datetime DEFAULT NULL,
  `HCVGI` varchar(12) DEFAULT NULL,
  `HCVGIstamp` datetime DEFAULT NULL,
  `CRYO` varchar(12) DEFAULT NULL,
  `CRYOstamp` datetime DEFAULT NULL,
  PRIMARY KEY (`currentpath_id`),
  UNIQUE KEY `currentpid` (`currentpid`),
  KEY `modifdate` (`modifdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathol_ixdata`
--

DROP TABLE IF EXISTS `pathol_ixdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pathol_ixdata` (
  `ix_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `importstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pcscode` varchar(12) DEFAULT NULL,
  `ixpid` varchar(12) NOT NULL DEFAULT 'Z999999',
  `ixstamp` datetime DEFAULT NULL,
  `ixdate` date DEFAULT NULL,
  `ixcode` varchar(10) DEFAULT NULL,
  `ixname` varchar(40) NOT NULL DEFAULT 'ixname',
  `requestor` varchar(30) NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (`ix_id`),
  UNIQUE KEY `pcscode` (`pcscode`),
  KEY `ixpid` (`ixpid`),
  KEY `ixdate` (`ixdate`),
  KEY `ixcode` (`ixcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathol_msgdata`
--

DROP TABLE IF EXISTS `pathol_msgdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pathol_msgdata` (
  `msg_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `msgstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `msgpid` varchar(12) DEFAULT NULL,
  `msgtext` text,
  PRIMARY KEY (`msg_id`),
  KEY `msgpid` (`msgpid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathol_obxcodes`
--

DROP TABLE IF EXISTS `pathol_obxcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pathol_obxcodes` (
  `code` varchar(4) NOT NULL DEFAULT '',
  `obxname` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathol_obxdata`
--

DROP TABLE IF EXISTS `pathol_obxdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pathol_obxdata` (
  `obx_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `importstamp` datetime DEFAULT NULL,
  `ix_id` int(11) unsigned NOT NULL,
  `obxpid` varchar(12) DEFAULT NULL,
  `obxcode` varchar(12) DEFAULT NULL,
  `obxtype` varchar(6) DEFAULT NULL,
  `obxdate` date DEFAULT NULL,
  `obxstamp` datetime DEFAULT NULL,
  `obxresult` varchar(12) DEFAULT NULL,
  `obxcomment` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`obx_id`),
  KEY `obxpid` (`obxpid`),
  KEY `obxdate` (`obxdate`),
  KEY `obxcode` (`obxcode`),
  KEY `ix_id` (`ix_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathol_results`
--

DROP TABLE IF EXISTS `pathol_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pathol_results` (
  `results_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `resultspid` char(7) NOT NULL DEFAULT 'Z999999',
  `resultsdate` date NOT NULL DEFAULT '1989-11-09',
  `modifstamp` datetime NOT NULL DEFAULT '1989-11-09 12:00:00',
  `modifdate` date DEFAULT NULL,
  `AL` decimal(3,1) DEFAULT NULL,
  `ALB` smallint(3) DEFAULT NULL,
  `ALT` smallint(3) DEFAULT NULL,
  `AMY` smallint(4) DEFAULT NULL,
  `ALP` smallint(3) DEFAULT NULL,
  `AST` smallint(3) DEFAULT NULL,
  `B12` smallint(5) DEFAULT NULL,
  `BIC` smallint(3) DEFAULT NULL,
  `BIL` smallint(3) DEFAULT NULL,
  `CAL` decimal(3,2) DEFAULT NULL,
  `CCA` decimal(3,2) DEFAULT NULL,
  `CHOL` decimal(3,1) DEFAULT NULL,
  `CK` smallint(3) DEFAULT NULL,
  `CRCL` smallint(3) DEFAULT NULL,
  `CRE` smallint(4) DEFAULT NULL,
  `CRP` decimal(4,1) DEFAULT NULL,
  `CU` varchar(8) DEFAULT NULL,
  `CYA` varchar(6) DEFAULT NULL,
  `ESR` smallint(3) DEFAULT NULL,
  `FER` smallint(3) DEFAULT NULL,
  `FIB` decimal(3,1) DEFAULT NULL,
  `FOL` decimal(3,1) DEFAULT NULL,
  `GGT` smallint(3) DEFAULT NULL,
  `GLO` smallint(3) DEFAULT NULL,
  `BGLU` decimal(3,1) DEFAULT NULL,
  `HB` decimal(3,1) DEFAULT NULL,
  `HBAI` smallint(3) unsigned DEFAULT NULL,
  `HBA` decimal(3,1) DEFAULT NULL,
  `HDL` decimal(2,1) DEFAULT NULL,
  `HYPO` decimal(3,1) DEFAULT NULL,
  `LYM` decimal(4,2) DEFAULT NULL,
  `PHOS` decimal(3,2) DEFAULT NULL,
  `RETA` decimal(4,1) DEFAULT NULL,
  `POT` decimal(2,1) DEFAULT NULL,
  `LDL` decimal(2,1) DEFAULT NULL,
  `MCH` decimal(4,1) DEFAULT NULL,
  `MCV` decimal(4,1) DEFAULT NULL,
  `MG` decimal(4,2) DEFAULT NULL,
  `NA` smallint(3) DEFAULT NULL,
  `NEUT` decimal(4,2) DEFAULT NULL,
  `PLT` smallint(4) DEFAULT NULL,
  `PTHI` smallint(4) DEFAULT NULL,
  `TP` smallint(3) DEFAULT NULL,
  `TRIG` decimal(2,1) DEFAULT NULL,
  `TSH` decimal(4,2) DEFAULT NULL,
  `URE` decimal(3,1) DEFAULT NULL,
  `URR` smallint(3) DEFAULT NULL,
  `WBC` decimal(5,2) DEFAULT NULL,
  `URAT` decimal(3,2) DEFAULT NULL,
  `UREP` decimal(3,1) DEFAULT NULL,
  `ACRA` decimal(5,1) unsigned DEFAULT NULL,
  `PCRA` decimal(5,1) unsigned DEFAULT NULL,
  `EGFR` smallint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`results_id`),
  UNIQUE KEY `piddate` (`resultspid`,`resultsdate`),
  KEY `resultspid` (`resultspid`),
  KEY `resultsdate` (`resultsdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pathsearchflds`
--

DROP TABLE IF EXISTS `pathsearchflds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pathsearchflds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fldcode` varchar(12) DEFAULT NULL,
  `fldlabel` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fldcode` (`fldcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `patientdata`
--

DROP TABLE IF EXISTS `patientdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patientdata` (
  `patzid` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `modifstamp` datetime DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `adduid` smallint(4) unsigned DEFAULT NULL,
  `adduser` varchar(20) DEFAULT NULL,
  `hospno1` varchar(8) DEFAULT NULL,
  `hospno2` varchar(20) DEFAULT NULL,
  `hospno3` varchar(20) DEFAULT NULL,
  `hospno4` varchar(12) DEFAULT NULL,
  `hospno5` varchar(12) DEFAULT NULL,
  `hosprefno` varchar(20) DEFAULT NULL,
  `privpatno` varchar(20) DEFAULT NULL,
  `nhsno` char(10) DEFAULT NULL,
  `title` enum('Mr','Ms','Miss','Mrs','Dr','Prof') DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `firstnames` varchar(30) DEFAULT NULL,
  `suffix` varchar(6) DEFAULT NULL,
  `sex` varchar(8) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `deathdate` date DEFAULT NULL,
  `age` tinyint(3) unsigned DEFAULT NULL,
  `modalcode` varchar(20) DEFAULT 'unknown',
  `modalsite` varchar(20) DEFAULT NULL,
  `maritstatus` varchar(16) DEFAULT NULL,
  `ethnicity` varchar(50) DEFAULT NULL,
  `religion` varchar(30) DEFAULT NULL,
  `language` varchar(30) DEFAULT NULL,
  `interpreter` varchar(30) DEFAULT NULL,
  `specialneeds` varchar(255) DEFAULT NULL,
  `addr1` varchar(90) DEFAULT NULL,
  `addr2` varchar(90) DEFAULT NULL,
  `addr3` varchar(90) DEFAULT NULL,
  `addr4` varchar(50) DEFAULT NULL,
  `postcode` varchar(12) DEFAULT NULL,
  `tel1` varchar(100) DEFAULT NULL,
  `tel2` varchar(100) DEFAULT NULL,
  `fax` varchar(30) DEFAULT NULL,
  `mobile` varchar(30) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `tempaddr` varchar(255) DEFAULT NULL,
  `nok_name` varchar(90) DEFAULT NULL,
  `nok_addr1` varchar(90) DEFAULT NULL,
  `nok_addr2` varchar(90) DEFAULT NULL,
  `nok_addr3` varchar(90) DEFAULT NULL,
  `nok_addr4` varchar(50) DEFAULT NULL,
  `nok_postcode` varchar(12) DEFAULT NULL,
  `nok_tels` varchar(90) DEFAULT NULL,
  `nok_email` varchar(50) DEFAULT NULL,
  `nok_notes` varchar(255) DEFAULT NULL,
  `gp_id` int(11) unsigned DEFAULT NULL,
  `gp_natcode` varchar(9) DEFAULT 'NULL',
  `gp_name` varchar(100) DEFAULT NULL,
  `gp_addr1` varchar(100) DEFAULT NULL,
  `gp_addr2` varchar(100) DEFAULT NULL,
  `gp_addr3` varchar(100) DEFAULT NULL,
  `gp_addr4` varchar(100) DEFAULT NULL,
  `gp_postcode` varchar(12) DEFAULT NULL,
  `gp_tel` varchar(30) DEFAULT NULL,
  `gp_fax` varchar(30) DEFAULT NULL,
  `gp_email` varchar(50) DEFAULT NULL,
  `healthauthcode` varchar(20) DEFAULT NULL,
  `referrer` varchar(255) DEFAULT NULL,
  `refer_date` date DEFAULT NULL,
  `refer_type` varchar(60) DEFAULT NULL,
  `refer_notes` varchar(255) DEFAULT NULL,
  `pctcode` char(3) DEFAULT NULL,
  `pctname` varchar(50) DEFAULT NULL,
  `transferdate` date DEFAULT NULL,
  `pharmacist` varchar(100) DEFAULT NULL,
  `pharmacist_addr` varchar(255) DEFAULT NULL,
  `pharmacist_phone` varchar(100) DEFAULT NULL,
  `districtnurse` varchar(100) DEFAULT NULL,
  `districtnurse_addr` varchar(255) DEFAULT NULL,
  `districtnurse_phone` varchar(100) DEFAULT NULL,
  `adminnotes` text,
  `defaultccs` text,
  `hl7pidblock` mediumtext,
  `hl7pd1block` mediumtext,
  `patsite` enum('KCH','QEH','DVH','BROM') DEFAULT NULL,
  `advancedirflag` char(1) DEFAULT NULL,
  `advancedirdate` date DEFAULT NULL,
  `advancedirsumm` tinytext,
  `advancedirlpatext` text NOT NULL,
  `advancedirtype` varchar(100) DEFAULT NULL,
  `advancedirstaff` varchar(50) DEFAULT NULL,
  `lastingpowerflag` char(1) DEFAULT NULL,
  `lastingpowerdate` date DEFAULT NULL,
  `lastingpowerattdata` tinytext,
  `lastingpowertype` varchar(100) DEFAULT NULL,
  `lastingpowerstaff` varchar(50) DEFAULT NULL,
  `ccflag` char(1) DEFAULT 'Y',
  `ccflagdate` date DEFAULT NULL,
  `renalregoptout` enum('Y','N') NOT NULL DEFAULT 'Y',
  `renalregdate` date DEFAULT NULL,
  `renalregstaff` varchar(30) DEFAULT NULL,
  `rregflag` tinyint(1) DEFAULT '0',
  `rregno` varchar(24) DEFAULT NULL,
  `photoflag` tinyint(1) DEFAULT '0',
  `esdflag` tinyint(1) DEFAULT '0',
  `esrfflag` tinyint(1) DEFAULT '0',
  `immunosuppflag` tinyint(1) DEFAULT '0',
  `immunosuppdrugdelivery` varchar(20) DEFAULT 'GP',
  `hdflag` tinyint(1) DEFAULT '0',
  `pdflag` tinyint(1) DEFAULT '0',
  `lasteventstamp` datetime DEFAULT NULL,
  `lasteventdate` date DEFAULT NULL,
  `lasteventuser` varchar(20) DEFAULT NULL,
  `sticky` tinytext NOT NULL,
  `advancedirtext` text,
  `advancedirlocation` tinytext,
  `lastingpowertext1` text,
  `lastingpowertype1` enum('Personal Welfare','Financial','Both') DEFAULT NULL,
  `lastingpowertype2` enum('Personal Welfare','Financial','Both') DEFAULT NULL,
  `lastingpowertext2` text,
  `alert` tinytext,
  `transportflag` char(1) DEFAULT NULL,
  `transportdate` date DEFAULT NULL,
  `transporttype` varchar(60) DEFAULT NULL,
  `transportdecider` varchar(30) DEFAULT NULL,
  `rpvstatus` varchar(12) DEFAULT NULL,
  `rpvuser` varchar(20) DEFAULT NULL,
  `rpvmodifstamp` datetime DEFAULT NULL,
  `pimsupdatestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`patzid`),
  KEY `hospno1` (`hospno1`),
  KEY `modalcode` (`modalcode`),
  KEY `ethnicity` (`ethnicity`),
  KEY `modifstamp` (`modifstamp`),
  KEY `hospno2` (`hospno2`),
  KEY `hospno3` (`hospno3`),
  KEY `rregflag` (`rregflag`),
  KEY `lastname` (`lastname`),
  KEY `firstnames` (`firstnames`),
  KEY `gp_natcode` (`gp_natcode`),
  KEY `hospno4` (`hospno4`),
  KEY `hospno5` (`hospno5`),
  KEY `nhsno` (`nhsno`)
) ENGINE=InnoDB AUTO_INCREMENT=125510 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `patientindex`
--

DROP TABLE IF EXISTS `patientindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patientindex` (
  `pat_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `hospno` char(7) NOT NULL DEFAULT '',
  `patstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `adddate` date DEFAULT NULL,
  `modifstamp` datetime DEFAULT NULL,
  `modifdate` date DEFAULT NULL,
  `prefix` varchar(6) DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `firstnames` varchar(30) DEFAULT NULL,
  `suffix` varchar(6) DEFAULT NULL,
  `sex` enum('MALE','FEMALE') DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `addr1` varchar(70) DEFAULT NULL,
  `addr2` varchar(70) DEFAULT NULL,
  `addr3` varchar(70) DEFAULT NULL,
  `addr4` varchar(70) DEFAULT NULL,
  `postcode` varchar(14) DEFAULT NULL,
  `patphone` varchar(40) DEFAULT NULL,
  `nokname` varchar(60) DEFAULT NULL,
  `nokphone` varchar(40) DEFAULT NULL,
  `practicecode` char(6) DEFAULT NULL,
  `gpcode` char(8) DEFAULT NULL,
  `nhsno` bigint(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`pat_id`),
  UNIQUE KEY `hospno` (`hospno`),
  KEY `lastname` (`lastname`),
  KEY `birthdate` (`birthdate`),
  KEY `postcode` (`postcode`),
  KEY `practicecode` (`practicecode`),
  KEY `gpcode` (`gpcode`),
  KEY `firstnames` (`firstnames`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `patstats`
--

DROP TABLE IF EXISTS `patstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patstats` (
  `statzid` mediumint(7) unsigned NOT NULL DEFAULT '1',
  `statstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `statpid` char(7) DEFAULT NULL,
  `admissions` smallint(3) unsigned NOT NULL DEFAULT '0',
  `encounters` smallint(3) unsigned NOT NULL DEFAULT '0',
  `pathix` smallint(4) unsigned NOT NULL DEFAULT '0',
  `ixdata` smallint(4) unsigned NOT NULL DEFAULT '0',
  `letters` smallint(3) unsigned NOT NULL DEFAULT '0',
  `problems` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `meds` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `modals` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `bpwts` smallint(4) unsigned NOT NULL DEFAULT '0',
  `hdsess` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ops` smallint(5) unsigned NOT NULL DEFAULT '0',
  `events` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`statzid`),
  KEY `statpid` (`statpid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdpatdata`
--

DROP TABLE IF EXISTS `pdpatdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pdpatdata` (
  `pdpatzid` mediumint(6) NOT NULL,
  `pdaddstamp` datetime DEFAULT NULL,
  `pdmodifstamp` datetime DEFAULT NULL,
  `pdstatus` varchar(20) DEFAULT NULL,
  `pdstartdate` date DEFAULT NULL,
  `totaldailyfluidvol` varchar(12) DEFAULT NULL,
  `weeklyvol` varchar(12) DEFAULT NULL,
  `bagsize` varchar(20) DEFAULT NULL,
  `fluidconc` varchar(40) DEFAULT NULL,
  `linechangedate` date DEFAULT NULL,
  `pdsystem` varchar(30) DEFAULT NULL,
  `bagconc` varchar(20) DEFAULT NULL,
  `adeq_KTVweekly` varchar(20) DEFAULT NULL,
  `adeq_CrClweekly` varchar(20) DEFAULT NULL,
  `PETdate` date DEFAULT NULL,
  `PETtransporterstatus` varchar(30) DEFAULT NULL,
  `PETrecommregime` varchar(50) DEFAULT NULL,
  `gentamycinflag` tinyint(1) DEFAULT NULL,
  `gentstartdate` date DEFAULT NULL,
  UNIQUE KEY `pdpatzid` (`pdpatzid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peritonitisdata`
--

DROP TABLE IF EXISTS `peritonitisdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peritonitisdata` (
  `peritonitisdata_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `peritzid` mediumint(6) DEFAULT NULL,
  `rxstartdate` date DEFAULT NULL,
  `rxenddate` date DEFAULT NULL,
  `organism1` varchar(50) DEFAULT NULL,
  `organism2` varchar(50) DEFAULT NULL,
  `WCcount` int(6) DEFAULT NULL,
  `IPantibioticflag` char(6) DEFAULT NULL,
  `IVantibioticflag` char(6) DEFAULT NULL,
  `peritnotes` varchar(255) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `modifstamp` datetime DEFAULT NULL,
  PRIMARY KEY (`peritonitisdata_id`),
  KEY `peritzid` (`peritzid`)
) ENGINE=InnoDB AUTO_INCREMENT=989 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `petadeqdata`
--

DROP TABLE IF EXISTS `petadeqdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `petadeqdata` (
  `petadeq_id` mediumint(7) NOT NULL AUTO_INCREMENT,
  `petadeqzid` mediumint(7) DEFAULT NULL,
  `addstamp` datetime DEFAULT NULL,
  `adduser` varchar(30) DEFAULT NULL,
  `adduid` smallint(3) DEFAULT NULL,
  `adddate` date DEFAULT NULL,
  `transporterstatus` varchar(12) DEFAULT NULL,
  `ktv` decimal(4,2) DEFAULT NULL,
  `cre_clear` decimal(5,2) DEFAULT NULL,
  `fluidremoval_24hrs` varchar(12) DEFAULT NULL,
  `urinevolume_24hrs` varchar(12) DEFAULT NULL,
  `regimechange` enum('Y','N') DEFAULT NULL,
  `petdate` date DEFAULT NULL,
  `adeqdate` date DEFAULT NULL,
  PRIMARY KEY (`petadeq_id`),
  KEY `petadeqzid` (`petadeqzid`)
) ENGINE=InnoDB AUTO_INCREMENT=1021 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `practicecodes`
--

DROP TABLE IF EXISTS `practicecodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `practicecodes` (
  `practice_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `practicecode` varchar(8) NOT NULL,
  `practicename` varchar(200) DEFAULT NULL,
  `practiceemail` varchar(100) DEFAULT NULL,
  `sendCDAflag` tinyint(1) DEFAULT '0',
  `sendemailflag` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`practice_id`),
  UNIQUE KEY `practicecode` (`practicecode`),
  KEY `sendCDAflag` (`sendCDAflag`),
  KEY `sendemailflag` (`sendemailflag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `practiceemaillist`
--

DROP TABLE IF EXISTS `practiceemaillist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `practiceemaillist` (
  `email_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `addstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `practicecode` varchar(12) DEFAULT NULL,
  `practicename` varchar(100) DEFAULT NULL,
  `practiceemail` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`email_id`),
  UNIQUE KEY `practicecode` (`practicecode`)
) ENGINE=InnoDB AUTO_INCREMENT=377 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `problemdata`
--

DROP TABLE IF EXISTS `problemdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problemdata` (
  `problem_id` mediumint(7) NOT NULL AUTO_INCREMENT,
  `probzid` mediumint(6) DEFAULT NULL,
  `probstamp` datetime DEFAULT NULL,
  `probuid` tinyint(3) DEFAULT NULL,
  `probuser` varchar(20) DEFAULT NULL,
  `problem` varchar(255) DEFAULT NULL,
  `probnotes` text,
  `probcode` varchar(100) DEFAULT NULL,
  `probdate` date DEFAULT NULL,
  PRIMARY KEY (`problem_id`),
  KEY `zid` (`probzid`)
) ENGINE=InnoDB AUTO_INCREMENT=161725 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `psychsoc_encounterdata`
--

DROP TABLE IF EXISTS `psychsoc_encounterdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `psychsoc_encounterdata` (
  `encounter_id` mediumint(6) NOT NULL AUTO_INCREMENT,
  `enczid` mediumint(7) DEFAULT NULL,
  `encstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `encuser` varchar(20) DEFAULT NULL,
  `encmodal` varchar(20) DEFAULT NULL,
  `encdate` date DEFAULT NULL,
  `enctime` varchar(20) DEFAULT NULL,
  `enctype` enum('Counsellor Meeting','Social Worker') DEFAULT NULL,
  `encdescr` tinytext,
  `enctext` text,
  `staffname` varchar(50) DEFAULT NULL,
  `publishflag` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`encounter_id`),
  KEY `enczid` (`enczid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `renalbxdata`
--

DROP TABLE IF EXISTS `renalbxdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `renalbxdata` (
  `renalbxdata_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `renalbxdate` date DEFAULT NULL,
  `renalbxzid` mediumint(6) DEFAULT NULL,
  `renalbxresult` varchar(255) DEFAULT NULL,
  `renalbxstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `renalbxuser` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`renalbxdata_id`),
  KEY `renalbxzid` (`renalbxzid`)
) ENGINE=InnoDB AUTO_INCREMENT=1394 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `renaldata`
--

DROP TABLE IF EXISTS `renaldata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `renaldata` (
  `renalzid` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `renalmodifstamp` datetime DEFAULT NULL,
  `clinAlcoholHx` tinytext,
  `clinAllergies` tinytext,
  `clinCormorbidity` tinytext,
  `clinFamilyHx` tinytext,
  `clinHLAType` tinytext,
  `clinMRSAstatus` tinytext,
  `clinMRSAtestDate` date DEFAULT NULL,
  `clinSmokingHx` tinytext,
  `clinSocialHx` tinytext,
  `deathCauseEDTA1` tinyint(2) unsigned DEFAULT NULL,
  `deathCauseEDTA2` tinyint(2) unsigned DEFAULT NULL,
  `deathCauseText1` tinytext,
  `deathCauseText2` tinytext,
  `deathnotes` text,
  `accessCurrent` varchar(40) DEFAULT NULL,
  `accessCurrDate` date DEFAULT NULL,
  `accessPlan` varchar(60) DEFAULT NULL,
  `accessPlanner` varchar(50) DEFAULT NULL,
  `accessPlandate` date DEFAULT NULL,
  `accessLastAssessdate` date DEFAULT NULL,
  `accessRxDecision` varchar(100) DEFAULT NULL,
  `accessSurveillance` varchar(50) DEFAULT NULL,
  `accessAssessOutcome` enum('Green','Amber','Red') DEFAULT NULL,
  `ixECGFlag` char(1) DEFAULT NULL,
  `ixEchoFlag` char(1) DEFAULT NULL,
  `ixExerciseECGFlag` varchar(50) DEFAULT NULL,
  `lowAccessClinic` varchar(255) DEFAULT NULL,
  `lowFirstseendate` date DEFAULT NULL,
  `lowDialPlan` varchar(255) DEFAULT NULL,
  `lowDialPlandate` date DEFAULT NULL,
  `lowPredictedESRFdate` date DEFAULT NULL,
  `lowReferralCRE` smallint(4) DEFAULT NULL,
  `lowReferredBy` varchar(255) DEFAULT NULL,
  `lowEducationStatus` varchar(8) DEFAULT NULL,
  `txWaitListEntryDate` date DEFAULT NULL,
  `txWaitListModifDate` date DEFAULT NULL,
  `txWaitListNotes` text,
  `txWaitListStatus` varchar(60) DEFAULT NULL,
  `TxNHBconsent` enum('Yes','No','Unknown') DEFAULT 'Unknown',
  `TxNHBconsentdate` date DEFAULT NULL,
  `TxNHBconsentstaff` varchar(20) DEFAULT NULL,
  `txAbsHighest` smallint(4) DEFAULT NULL,
  `txAbsHighestDate` date DEFAULT NULL,
  `txAbsLatest` smallint(4) DEFAULT NULL,
  `txAbsLatestDate` date DEFAULT NULL,
  `txBloodGroup` varchar(5) DEFAULT NULL,
  `txHLAType` varchar(255) DEFAULT NULL,
  `txHLATypeDate` date DEFAULT NULL,
  `txNoGrafts` tinyint(2) DEFAULT NULL,
  `txSensStatus` varchar(30) DEFAULT NULL,
  `txTransplType` varchar(50) DEFAULT NULL,
  `txRejectionRisk` varchar(8) DEFAULT NULL,
  `txWaitListContact` varchar(255) DEFAULT NULL,
  `lowReferralEGFR` decimal(6,1) unsigned DEFAULT NULL,
  `lowEducationType` enum('day','evening') DEFAULT NULL,
  `lowAttendeddate` date DEFAULT NULL,
  `lowDVD1` char(1) DEFAULT NULL,
  `lowDVD2` char(1) DEFAULT NULL,
  `lowTxReferralflag` char(1) DEFAULT NULL,
  `lowTxReferraldate` date DEFAULT NULL,
  `lowHomeHDflag` char(1) DEFAULT NULL,
  `lowSelfcareflag` char(1) DEFAULT NULL,
  `lowAccessnotes` text,
  `pdlinechangedate` date DEFAULT NULL,
  `psychsoc_housing` text,
  `psychsoc_socialnetwork` text,
  `psychsoc_carepackage` text,
  `psychsoc_other` text,
  `psychsoc_stamp` datetime DEFAULT NULL,
  `diabetesflag` enum('Y','N') DEFAULT NULL,
  `hivflag` enum('Y','N') DEFAULT NULL,
  `endstagedate` date DEFAULT NULL,
  `lupusflag` enum('Y','N') DEFAULT NULL,
  `alertflag` enum('Y','N') DEFAULT NULL,
  `hbvflag` enum('Y','N') DEFAULT NULL,
  `hcvflag` enum('Y','N') DEFAULT NULL,
  `mrsaflag` enum('Y','N') DEFAULT NULL,
  `mrsadate` date DEFAULT NULL,
  `mrsasite` varchar(40) DEFAULT NULL,
  `mrsaposflag` enum('Y','N') DEFAULT NULL,
  `mrsaposdate` date DEFAULT NULL,
  `mrsalast_id` mediumint(6) unsigned DEFAULT NULL,
  `akiflag` char(1) DEFAULT NULL,
  UNIQUE KEY `renalzid` (`renalzid`),
  KEY `mrsalast_id` (`mrsalast_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `renalsessions`
--

DROP TABLE IF EXISTS `renalsessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `renalsessions` (
  `session_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `activeflag` tinyint(1) unsigned DEFAULT '1',
  `starttime` datetime DEFAULT NULL,
  `sessuser` varchar(20) DEFAULT NULL,
  `sessuid` smallint(4) unsigned DEFAULT NULL,
  `user_ipaddr` varchar(25) DEFAULT NULL,
  `agent` varchar(100) DEFAULT NULL,
  `lasteventtime` datetime DEFAULT NULL,
  `endtime` datetime DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `sessuid` (`sessuid`),
  KEY `activeflag` (`activeflag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpvlogs`
--

DROP TABLE IF EXISTS `rpvlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpvlogs` (
  `rpv_id` mediumint(6) NOT NULL AUTO_INCREMENT,
  `hospno1` varchar(12) DEFAULT NULL,
  `logstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `rpvstatus` varchar(20) DEFAULT NULL,
  `sequence` mediumint(6) DEFAULT NULL,
  `xmltext` text,
  PRIMARY KEY (`rpv_id`),
  KEY `hospno1` (`hospno1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rreg_prdcodes`
--

DROP TABLE IF EXISTS `rreg_prdcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rreg_prdcodes` (
  `id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `prdcode` smallint(4) unsigned DEFAULT NULL,
  `prdterm` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rregcode` (`prdcode`)
) ENGINE=InnoDB AUTO_INCREMENT=274 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rregmodalcodes`
--

DROP TABLE IF EXISTS `rregmodalcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rregmodalcodes` (
  `rwarecode` varchar(20) DEFAULT NULL,
  `rregcode` char(2) DEFAULT NULL,
  UNIQUE KEY `modalcode` (`rwarecode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sharedcaredata`
--

DROP TABLE IF EXISTS `sharedcaredata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sharedcaredata` (
  `sharedcare_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `sharedcarestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sharedcareuid` smallint(4) unsigned DEFAULT NULL,
  `sharedcareuser` varchar(20) DEFAULT NULL,
  `sharedcarezid` mediumint(8) unsigned DEFAULT NULL,
  `sharedcareadddate` date DEFAULT NULL,
  `sharedcaredate` date DEFAULT NULL,
  `currentflag` tinyint(1) unsigned DEFAULT '1',
  `q1interest` char(1) DEFAULT NULL,
  `q1participating` tinyint(1) unsigned DEFAULT '0',
  `q1completed` tinyint(1) DEFAULT '0',
  `q1completed_by` varchar(20) DEFAULT NULL,
  `q1completed_date` date DEFAULT NULL,
  `q2interest` char(1) DEFAULT NULL,
  `q2participating` tinyint(1) unsigned DEFAULT '0',
  `q2completed` tinyint(1) DEFAULT '0',
  `q2completed_by` varchar(20) DEFAULT NULL,
  `q2completed_date` date DEFAULT NULL,
  `q3interest` char(1) DEFAULT NULL,
  `q3participating` tinyint(1) unsigned DEFAULT '0',
  `q3completed` tinyint(1) DEFAULT '0',
  `q3completed_by` varchar(20) DEFAULT NULL,
  `q3completed_date` date DEFAULT NULL,
  `q4interest` char(1) DEFAULT NULL,
  `q4participating` tinyint(1) unsigned DEFAULT '0',
  `q4completed` tinyint(1) DEFAULT '0',
  `q4completed_by` varchar(20) DEFAULT NULL,
  `q4completed_date` date DEFAULT NULL,
  `q5interest` char(1) DEFAULT NULL,
  `q5participating` tinyint(1) unsigned DEFAULT '0',
  `q5completed` tinyint(1) DEFAULT '0',
  `q5completed_by` varchar(20) DEFAULT NULL,
  `q5completed_date` date DEFAULT NULL,
  `q6interest` char(1) DEFAULT NULL,
  `q6participating` tinyint(1) unsigned DEFAULT '0',
  `q6completed` tinyint(1) DEFAULT '0',
  `q6completed_by` varchar(20) DEFAULT NULL,
  `q6completed_date` date DEFAULT NULL,
  `q7interest` char(1) DEFAULT NULL,
  `q7participating` tinyint(1) unsigned DEFAULT '0',
  `q7completed` tinyint(1) DEFAULT '0',
  `q7completed_by` varchar(20) DEFAULT NULL,
  `q7completed_date` date DEFAULT NULL,
  `q8interest` char(1) DEFAULT NULL,
  `q8participating` tinyint(1) unsigned DEFAULT '0',
  `q8completed` tinyint(1) DEFAULT '0',
  `q8completed_by` varchar(20) DEFAULT NULL,
  `q8completed_date` date DEFAULT NULL,
  `q9interest` char(1) DEFAULT NULL,
  `q9participating` tinyint(1) unsigned DEFAULT '0',
  `q9completed` tinyint(1) DEFAULT '0',
  `q9completed_by` varchar(20) DEFAULT NULL,
  `q9completed_date` date DEFAULT NULL,
  `q10interest` char(1) DEFAULT NULL,
  `q10participating` tinyint(1) unsigned DEFAULT '0',
  `q10completed` tinyint(1) DEFAULT '0',
  `q10completed_by` varchar(20) DEFAULT NULL,
  `q10completed_date` date DEFAULT NULL,
  `q11interest` char(1) DEFAULT NULL,
  `q11participating` tinyint(1) unsigned DEFAULT '0',
  `q11completed` tinyint(1) DEFAULT '0',
  `q11completed_by` varchar(20) DEFAULT NULL,
  `q11completed_date` date DEFAULT NULL,
  `q12interest` char(1) DEFAULT NULL,
  `q12participating` tinyint(1) unsigned DEFAULT '0',
  `q12completed` tinyint(1) DEFAULT '0',
  `q12completed_by` varchar(20) DEFAULT NULL,
  `q12completed_date` date DEFAULT NULL,
  `q13interest` char(1) DEFAULT NULL,
  `q13participating` tinyint(1) unsigned DEFAULT '0',
  `q13completed` tinyint(1) DEFAULT '0',
  `q13completed_by` varchar(20) DEFAULT NULL,
  `q13completed_date` date DEFAULT NULL,
  `q14interest` char(1) DEFAULT NULL,
  `q14participating` tinyint(1) unsigned DEFAULT '0',
  `q14completed` tinyint(1) DEFAULT '0',
  `q14completed_by` varchar(20) DEFAULT NULL,
  `q14completed_date` date DEFAULT NULL,
  PRIMARY KEY (`sharedcare_id`),
  KEY `sharedcarezid` (`sharedcarezid`),
  KEY `sharedcareuid` (`sharedcareuid`),
  KEY `sharedcareadddate` (`sharedcareadddate`),
  KEY `sharedcaredate` (`sharedcaredate`),
  KEY `currentflag` (`currentflag`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sitelist`
--

DROP TABLE IF EXISTS `sitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitelist` (
  `site_id` tinyint(2) NOT NULL AUTO_INCREMENT,
  `mainsitecode` varchar(6) DEFAULT NULL,
  `sitecode` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sitename` varchar(50) DEFAULT NULL,
  `rregcode` varchar(10) DEFAULT NULL,
  `sitetype` varchar(4) DEFAULT NULL,
  `dxbays` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`site_id`),
  UNIQUE KEY `sitecode` (`sitecode`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `statdata`
--

DROP TABLE IF EXISTS `statdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statdata` (
  `datazid` mediumint(7) unsigned NOT NULL,
  `datapid` char(10) DEFAULT NULL,
  `statcount` smallint(4) unsigned DEFAULT NULL,
  KEY `datazid` (`datazid`),
  KEY `datapid` (`datapid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcilistdata`
--

DROP TABLE IF EXISTS `tcilistdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tcilistdata` (
  `tcilist_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `tciliststamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tcilistmodifstamp` datetime DEFAULT NULL,
  `activeflag` tinyint(1) unsigned DEFAULT '1',
  `tcilistuid` smallint(4) unsigned DEFAULT NULL,
  `tcilistuser` varchar(20) DEFAULT NULL,
  `tcilistzid` mediumint(7) unsigned DEFAULT NULL,
  `tciconsult_id` mediumint(7) unsigned DEFAULT NULL,
  `tciproced_id` mediumint(7) unsigned DEFAULT NULL,
  `tcilistmodal` varchar(20) DEFAULT NULL,
  `tcilistsource` varchar(20) DEFAULT NULL,
  `tcilistadddate` date DEFAULT NULL,
  `tcilistremovaldate` date DEFAULT NULL,
  `tcilistremovalcause` varchar(100) DEFAULT NULL,
  `tcireason` varchar(20) DEFAULT NULL,
  `tcipriority` varchar(20) DEFAULT NULL,
  `tcilistrank` smallint(3) unsigned DEFAULT NULL,
  `patlocation` varchar(50) DEFAULT NULL,
  `tcinotes` text,
  PRIMARY KEY (`tcilist_id`),
  KEY `tcilistzid` (`tcilistzid`),
  KEY `tcilistuid` (`tcilistuid`),
  KEY `tcilistadddate` (`tcilistadddate`),
  KEY `tcipriority` (`tcipriority`),
  KEY `tcilistrank` (`tcilistrank`),
  KEY `tciconsult_id` (`tciconsult_id`),
  KEY `tciproced_id` (`tciproced_id`)
) ENGINE=InnoDB AUTO_INCREMENT=634 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timelinedata`
--

DROP TABLE IF EXISTS `timelinedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timelinedata` (
  `timeline_id` mediumint(7) unsigned NOT NULL AUTO_INCREMENT,
  `timelinestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `timelineuid` smallint(4) unsigned DEFAULT NULL,
  `timelineuser` varchar(20) DEFAULT NULL,
  `timelinecode` varchar(20) DEFAULT NULL,
  `timelinezid` mediumint(7) unsigned DEFAULT NULL,
  `timelineadddate` date DEFAULT NULL,
  `timelinedescr` varchar(60) DEFAULT NULL,
  `timelinetext` text,
  PRIMARY KEY (`timeline_id`),
  KEY `timelinezid` (`timelinezid`),
  KEY `timelinecode` (`timelinecode`),
  KEY `timelineuid` (`timelineuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `txbxdata`
--

DROP TABLE IF EXISTS `txbxdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `txbxdata` (
  `txbxdata_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `txbxzid` mediumint(6) DEFAULT NULL,
  `txbxdate` date DEFAULT NULL,
  `txbxresult1` varchar(255) DEFAULT NULL,
  `txbxresult2` varchar(255) DEFAULT NULL,
  `txbxnotes` varchar(255) DEFAULT NULL,
  `txbxaddstamp` datetime DEFAULT NULL,
  `txbxmodifstamp` datetime DEFAULT NULL,
  `txbxuser` varchar(20) DEFAULT NULL,
  `txopid` smallint(4) DEFAULT NULL,
  PRIMARY KEY (`txbxdata_id`),
  KEY `renalbxzid` (`txbxzid`)
) ENGINE=InnoDB AUTO_INCREMENT=730 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `txinactivepatdata`
--

DROP TABLE IF EXISTS `txinactivepatdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `txinactivepatdata` (
  `txinactivepat_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `txinactivepatzid` mediumint(7) unsigned DEFAULT NULL,
  `assessstamp` datetime DEFAULT NULL,
  `assessuid` smallint(4) unsigned DEFAULT NULL,
  `assessdate` date DEFAULT NULL,
  `assessor` varchar(50) DEFAULT NULL,
  `reason1` varchar(50) DEFAULT NULL,
  `reason2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`txinactivepat_id`),
  KEY `txinactivepatzid` (`txinactivepatzid`)
) ENGINE=InnoDB AUTO_INCREMENT=727 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `txops`
--

DROP TABLE IF EXISTS `txops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `txops` (
  `txop_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `txopzid` mediumint(7) DEFAULT NULL,
  `txopaddstamp` datetime DEFAULT NULL,
  `txopmodifstamp` datetime DEFAULT NULL,
  `txopdate` date DEFAULT NULL,
  `txopno` tinyint(1) unsigned DEFAULT NULL,
  `txoptype` varchar(50) DEFAULT NULL,
  `patage` tinyint(2) unsigned DEFAULT NULL,
  `lastdialdate` date DEFAULT NULL,
  `donortype` varchar(50) DEFAULT NULL,
  `donorsex` enum('M','F') DEFAULT NULL,
  `donorbirthdate` date DEFAULT NULL,
  `donorage` varchar(12) DEFAULT NULL,
  `donorweight` decimal(3,1) unsigned DEFAULT NULL,
  `donor_deathcause` varchar(100) DEFAULT NULL,
  `donorHLA` varchar(255) DEFAULT NULL,
  `HLAmismatch` varchar(255) DEFAULT NULL,
  `donorCMVstatus` varchar(12) DEFAULT NULL,
  `recipCMVstatus` varchar(12) DEFAULT NULL,
  `donor_bloodtype` varchar(6) DEFAULT NULL,
  `recip_bloodtype` varchar(6) DEFAULT NULL,
  `kidneyside` enum('R','L') DEFAULT NULL,
  `kidney_asyst` tinyint(1) DEFAULT NULL,
  `txsite` varchar(12) DEFAULT NULL,
  `kidney_age` varchar(12) DEFAULT NULL,
  `kidney_weight` decimal(2,1) DEFAULT NULL,
  `coldinfustime` varchar(20) DEFAULT NULL,
  `failureflag` tinyint(1) DEFAULT NULL,
  `failuredate` date DEFAULT NULL,
  `failurecause` varchar(255) DEFAULT NULL,
  `failuredescr` varchar(255) DEFAULT NULL,
  `stentremovaldate` date DEFAULT NULL,
  `graftfxn` varchar(100) DEFAULT NULL,
  `immunosuppneed` varchar(10) DEFAULT NULL,
  `dsa_date` date DEFAULT NULL,
  `dsa_result` varchar(6) DEFAULT NULL,
  `dsa_notes` varchar(255) DEFAULT NULL,
  `bkv_date` date DEFAULT NULL,
  `bkv_result` varchar(6) DEFAULT NULL,
  `bkv_notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`txop_id`),
  KEY `txopzid` (`txopzid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `txwaitlistdata`
--

DROP TABLE IF EXISTS `txwaitlistdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `txwaitlistdata` (
  `txwaitzid` mediumint(7) DEFAULT NULL,
  `eventstamp` datetime DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `eventtext` text,
  KEY `txwaitzid` (`txwaitzid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userdata`
--

DROP TABLE IF EXISTS `userdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userdata` (
  `uid` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `pass` varchar(41) DEFAULT NULL,
  `userlast` varchar(20) DEFAULT NULL,
  `userfirst` varchar(30) DEFAULT NULL,
  `adminflag` tinyint(1) unsigned DEFAULT '0',
  `consultantflag` tinyint(1) unsigned DEFAULT '0',
  `editflag` tinyint(1) unsigned DEFAULT '0',
  `authorflag` tinyint(1) unsigned DEFAULT '1',
  `clinicflag` tinyint(1) unsigned DEFAULT '0',
  `hdnurseflag` tinyint(1) unsigned DEFAULT '0',
  `decryptflag` tinyint(1) unsigned DEFAULT '0',
  `printflag` tinyint(1) unsigned DEFAULT NULL,
  `adddate` date DEFAULT NULL,
  `expiredate` date DEFAULT NULL,
  `passmodifstamp` datetime DEFAULT NULL,
  `usertype` varchar(20) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL,
  `sitecode` enum('kings','qeh') DEFAULT 'kings',
  `dept` enum('Renal','Liver','Urology','Dietetics','Diabetic','Palliative') DEFAULT 'Renal',
  `location` varchar(50) DEFAULT NULL,
  `maintel` varchar(25) DEFAULT NULL,
  `directtel` varchar(25) DEFAULT NULL,
  `mobile` varchar(25) DEFAULT NULL,
  `fax` varchar(25) DEFAULT NULL,
  `inits` varchar(6) DEFAULT NULL,
  `authorsig` varchar(50) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `userstamp` datetime DEFAULT NULL,
  `modifstamp` datetime DEFAULT NULL,
  `logged_inflag` tinyint(1) unsigned DEFAULT '0',
  `lastloginstamp` datetime DEFAULT NULL,
  `lasteventstamp` datetime DEFAULT NULL,
  `bedmanagerflag` tinyint(1) DEFAULT '0',
  `pathflag` tinyint(1) DEFAULT '0',
  `startpage` varchar(255) DEFAULT NULL,
  `expiredflag` tinyint(1) DEFAULT '0',
  `newpwflag` enum('0','1') DEFAULT '0',
  `wardclerkflag` tinyint(1) DEFAULT '0',
  `transportdeciderflag` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `user` (`user`),
  KEY `consultantflag` (`consultantflag`),
  KEY `authorflag` (`authorflag`),
  KEY `clinicflag` (`clinicflag`),
  KEY `decryptflag` (`decryptflag`),
  KEY `loginflag` (`logged_inflag`),
  KEY `adminflag` (`adminflag`),
  KEY `editflag` (`editflag`),
  KEY `hdnurseflag` (`hdnurseflag`),
  KEY `expiredflag` (`expiredflag`)
) ENGINE=InnoDB AUTO_INCREMENT=1097 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `viroldata`
--

DROP TABLE IF EXISTS `viroldata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viroldata` (
  `virol_id` mediumint(6) unsigned NOT NULL AUTO_INCREMENT,
  `virolzid` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `viroladdstamp` datetime DEFAULT NULL,
  `virolmodifstamp` datetime DEFAULT NULL,
  `viroldate` date DEFAULT NULL,
  `CMVAbStatus` varchar(30) DEFAULT NULL,
  `CMVAbdate` date DEFAULT NULL,
  `EBVstatus` varchar(30) DEFAULT NULL,
  `EBVdate` date DEFAULT NULL,
  `HBVsurfaceAbStatus` varchar(30) DEFAULT NULL,
  `HBVsurfaceAbdate` date DEFAULT NULL,
  `HBVsurfaceAgStatus` varchar(30) DEFAULT NULL,
  `HBVsurfaceAgdate` date DEFAULT NULL,
  `HBVboosterdate` date DEFAULT NULL,
  `HBVcoreAbStatus` varchar(30) DEFAULT NULL,
  `HBVcoreAbdate` date DEFAULT NULL,
  `HBVlatestTitre` varchar(10) DEFAULT NULL,
  `HBVlatestTitredate` date DEFAULT NULL,
  `HBVvacc1date` date DEFAULT NULL,
  `HBVvacc2date` date DEFAULT NULL,
  `HBVvacc3date` date DEFAULT NULL,
  `HBVvacc4date` date DEFAULT NULL,
  `HCV_AbStatus` varchar(30) DEFAULT NULL,
  `HCV_Abdate` date DEFAULT NULL,
  `HCV_RNAstatus` varchar(30) DEFAULT NULL,
  `HCV_RNAdate` date DEFAULT NULL,
  `HIV_AbStatus` varchar(30) DEFAULT NULL,
  `HIV_Abdate` date DEFAULT NULL,
  `HIVviralload` int(7) DEFAULT NULL,
  `HIVviralloaddate` date DEFAULT NULL,
  `HIV_CD4count` smallint(5) DEFAULT NULL,
  `HIV_CD4countdate` date DEFAULT NULL,
  `HTLVstatus` varchar(30) DEFAULT NULL,
  `HTLVdate` date DEFAULT NULL,
  `HZVstatus` varchar(30) DEFAULT NULL,
  `HZVdate` date DEFAULT NULL,
  `virolNotes` tinytext,
  PRIMARY KEY (`virol_id`),
  UNIQUE KEY `virolzid` (`virolzid`)
) ENGINE=InnoDB AUTO_INCREMENT=25250 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wardcodes`
--

DROP TABLE IF EXISTS `wardcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wardcodes` (
  `ward_id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `wardcode` varchar(20) NOT NULL,
  `wardname` varchar(60) DEFAULT NULL,
  `wardflag` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`ward_id`),
  KEY `visitcode` (`wardcode`),
  KEY `wardflag` (`wardflag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wardlist`
--

DROP TABLE IF EXISTS `wardlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wardlist` (
  `sitecode` char(6) DEFAULT NULL,
  `wardcode` varchar(20) NOT NULL,
  `ward` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`wardcode`),
  KEY `sitecode` (`sitecode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-10-06 15:53:24
