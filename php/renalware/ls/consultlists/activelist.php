<?php
//----Thu 24 Apr 2014----column tweaks
//----Fri 28 Jun 2013----akiriskflag
//Wed Oct 22 16:44:40 IST 2008
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="consultdata JOIN patientdata ON consultzid=patzid";
include 'consultlists/fieldslist_incl.php';
$where="WHERE activeflag ='Y'";
$paginate='false';
$omitfields=array('consult_id','consultzid','activeflag','consultdescr','consultward');
$listnotes='<a href="ls/printconsultlist.php">Print this Active list!</a>'; //appears before "Last run"
$showsql=false;
include 'consultlists/consultlist_incl.php';