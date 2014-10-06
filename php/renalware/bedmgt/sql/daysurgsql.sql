USE bedmgt;
ALTER TABLE `proceddata` CHANGE `surgslot` `surgslot` varchar(6) NULL DEFAULT NULL;
ALTER TABLE `proceddata` CHANGE `mgtintent` `mgtintent` enum('Day Case','Inpatient','23h Ward Stay','Renal Day Surgery') NULL DEFAULT NULL;
ALTER TABLE `proceddata` CHANGE `pzid` `pzid` mediumint(6) UNSIGNED NULL DEFAULT NULL;
ALTER TABLE `proceddata` CHANGE `pid` `pid` mediumint(6) UNSIGNED NOT NULL auto_increment;
ALTER TABLE `diarydates` ADD `daysurgflag` tinyint(1) UNSIGNED NOT NULL DEFAULT '0'  AFTER `daynotes`;
#following x1x2x3 for future better slots usage DELAYED FOR NOW IGNORE
#ALTER TABLE `diarydates` ADD `x1` mediumint(6) UNSIGNED NULL DEFAULT NULL  AFTER `daysurgflag`;
#ALTER TABLE `diarydates` ADD `x2` mediumint(6) UNSIGNED NULL DEFAULT NULL  AFTER `x1`;
#ALTER TABLE `diarydates` ADD `x3` mediumint(6) UNSIGNED NULL DEFAULT NULL  AFTER `x2`;
#for testing purposes!
SELECT diarydate, dayno, weekno,dayname,daysurgflag FROM diarydates WHERE dayno=5 AND diarydate > '2009-10-07' AND (weekno/2 != floor(weekno/2));
#set daysurgflags for alternate Thurs starting 8-oct-09 per Trish specs
UPDATE diarydates SET daysurgflag=1 WHERE dayno=5 AND diarydate > '2009-10-07' AND (weekno/2 != floor(weekno/2));
ALTER TABLE `diarydates` ADD INDEX  (`daysurgflag`);
ALTER TABLE `diarydates` ADD `daysurgfreeslots` tinyint(1) UNSIGNED NULL DEFAULT '0'  AFTER `daysurgflag`;
UPDATE diarydates SET daysurgfreeslots=3 WHERE daysurgflag=1;
ALTER TABLE `diarydates` CHANGE `availslots` `availslots` varchar(14) NULL DEFAULT NULL;
UPDATE diarydates SET freeslots=freeslots+3, availslots=CONCAT(availslots, ' XYZ') WHERE daysurgflag=1;