<?php
//Wed May  6 17:09:53 CEST 2009
//--------CONFIG PORTAL---------------
//TABLES
$searchtables="renalware.patientdata p JOIN renaldata r ON patzid=renalzid";
$fieldsinfotable=$searchtables; //for search fld popups use prim table only prn
//for option links *** use with search.php?zid=123456&search=admissions e.g. ***
$primid="patzid";
$thisitems="patients";
//FIELDS
$fields="patzid,
hospno1,
lastname,
firstnames,
sex,
birthdate,
age,
modalcode,
ethnicity,
postcode,
esdstatus,
endstagedate";
//nb following should not be in "default" search form fields e.g. sex, birthdate etc
$availfieldslist="patzid,hospno1,hospno2,hospno3,hospno4,nhsno,lastname,firstnames,sex,birthdate,deathdate,age,modalcode,modalsite,endstagedate,esdstatus,postcode,gp_name,healthauthcode,refer_date,firstseendate,accessCurrDate,prescriber,diabetesflag,hivflag"; // in search/custom popups
$availablefields=explode(",",$availfieldslist);
$hiddenfieldslist=""; //hidden in table cols
//DEFAULT SETTINGS
//WHERE
$wherelock=FALSE; //TRUE if applies to any sorts and searches
//PORTAL OPTIONS
$resultsoptions=TRUE; //for "option links" at row start; requires $thissearch_options.php + $primid
$allowdownload=TRUE; //false if no downloading desired
//$searchheader=TRUE; //if true then incl thissearch_header.php w/ menu, options etc
//--------END CONFIG-----------
?>
