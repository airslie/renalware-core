<?php
//----Fri 28 Jun 2013----akirisk
//Wed Oct 22 16:44:40 IST 2008
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="consultdata JOIN patientdata ON consultzid=patzid";
include 'consultlists/fieldslist_incl.php';
$where="";
$paginate='true';
$listnotes=""; //appears before "Last run"
$omitfields=array('consult_id','consultzid','consultdescr','consultward');
$showsql=false;
include 'consultlists/consultlist_incl.php';
