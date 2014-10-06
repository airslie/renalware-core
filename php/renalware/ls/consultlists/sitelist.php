<?php
//----Fri 28 Jun 2013----akirisk
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
$thissite=$get_site;
//set tables incl JOINs
$table="consultdata JOIN patientdata ON consultzid=patzid";
include 'consultlists/fieldslist_incl.php';
$where="WHERE consultsite='$thissite' AND activeflag ='Y'";
$paginate='false';
$omitfields=array('consult_id','consultzid','activeflag','consultdescr','consultward');
$listnotes='<a href="ls/printconsultlist.php?site='.$get_site.'">Print this Site list!</a>'; //appears before "Last run"
$showsql=false;
include 'consultlists/consultlist_incl.php';
