<?php
//----Thu 12 Dec 2013----WS email fix
//----Fri 22 Nov 2013----db setting moved to config_local
//----Fri 15 Nov 2013----use new config_status.php to set BETA/DEVEL/LIVE
//----Fri 15 Nov 2013----lettersite KRU now KCH
//----Fri 25 Oct 2013----$lettersites array config here
//----Tue 11 Jun 2013----status.php now config_local.php
//for linux box 17 May 2012
require 'copyright_info.php'; //incl versionno info
require 'config_status.php'; //local server settings
require 'config_local.php'; //local server settings
//---***MAIN CONFIG***---
//set DEVEL timezone; others set below
date_default_timezone_set('Europe/London');
//-------------------------------for paths, email, etc --------------------------
//based on STATUS
$mainsitecode="kings";
$hosp1label = "KCH No";
$hosp2label = "QEH No";
$hosp3label = "DVH No";
$hosp4label = "BROM No";
$hosp5label = "GUYS No";
$siteshort ="King&rsquo;s Renal Unit";
$sitelong = "King&rsquo;s College Hospital Renal Unit";
$admin = "Waqas Shah";
$adminemail = "waqas.shah@nhs.net";
//-------------------------------for SITE OPTIONS--------------------------
//set site info here
$mainsitecode = "kings";
//--------PASSWORD SETTINGS----------
//number of days before users must change password
$pwexpiredays=60;
//--------END PASSWORD SETTINGS----------
//number of "recent days" to show in browse pathol Ix screen
$ixdaynos=2;
//default number of patients to display per screen
//need to test with satellite unit bandwidths etc
$displaycount=50;
//-------------------------------for LETTER OPTIONS--------------------------
//----Fri 25 Oct 2013----for radio buttons on createletter
$lettersites = array(
    'KCH' => "KCH", 
    'QEH' => "QEH/Woolwich", 
    'DVH' => "DVH/Dartford", 
    'PRUH' => "PRUH", 
);
//recent letters -- how many to list
$recentletters=5;
// **NEW to allow "toggling" of letters in portals-- set to '1' to enable
$toggleflag=1;
//email addr for letters (FOR TESTING PURPOSES)
$sendletteremails=0;
// $lettersemailrecip=$alertemail;
//eCCs
$ccdayswarning=3; //days over which users are warned re unread CCs
//user for "supertypist" (to view Typist Audit)
$supertypist='slindsay';
//-------------------------------for MISCELL OPTIONS--------------------------

//option for full logging (include page views; adds bulk!) 1=yes
$pagelogging=1;
//paths to renalware and to renalconn.php:
//to specify default (main) HD site
$HDsite1='KRU';
//for days used to calc dial BP averages (typically 30)
$bp_avg_days=30;
