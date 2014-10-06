<?php
require '../../config_incl.php';
include '../../incl/check.php';
include '../../fxns/fxns.php';
include '../../fxns/formfxns.php';
/*
CREATE TABLE `homehdassessdata` (
  `homehdassess_id` smallint(4) unsigned NOT NULL auto_increment,
  `homehdassessstamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `homehdassesszid` mediumint(7) unsigned default NULL,
  `homehdassess_uid` smallint(4) unsigned default NULL,
  `homehdassessuser` varchar(20) default NULL,
  `referraldate` date default NULL,
  `selfcarelevel` varchar(40) default NULL,
  `selfcarenotes` text,
  `medicalassess` text,
  `technicalassess` text,
  `socialworkassess` text,
  `counsellorassess` text,
  `fullindepconfirm` text,
  `fullindepconfirmdate` date default NULL,
  `programmetype` varchar(40) default NULL,
  `carername` varchar(100) default NULL,
  `carernotes` text,
  `acceptancedate` date default NULL,
  `equipinstalldate` date default NULL,
  `firstdeliverydate` date default NULL,
  `trainingstartdate` date default NULL,
  `firstindepdialdate` date default NULL,
  `assessmentnotes` text,
  `assessor` varchar(100) default NULL,
  PRIMARY KEY  (`homehdassess_id`),
  UNIQUE KEY `homehdassesszid` (`homehdassesszid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
*/
$table = 'renalware.homehdassessdata'; //****UPDATE
$insertfields="homehdassess_uid, homehdassessuser";
$insertvalues="$uid, '$user'";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			$insertfields .= $value ? ", $key" : "";
			$insertvalues .= $value ? ", '".${$key}."'" : "";
	}
	//upd  the table
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//log the event
	$zid=$homehdassesszid; //*****UPDATE
	$eventtype="Patient Home HD Assessment Data added";
	$eventtext=$mysqli->real_escape_string($sql); //store change!
	include "$rwarepath/run/logevent.php";
	header ("Location: $rwareroot/renal/renal.php?scr=homehdnav&zid=$zid"); //****UPDATE
?>