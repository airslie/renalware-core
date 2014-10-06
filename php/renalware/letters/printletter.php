<?php
//----Mon 27 Aug 2012----
include '../req/confcheckfxns.php';
//get patientdata
$zid = $_GET['zid'];
//get letterdata
$letter_id = $_GET['letter_id'];
include "$rwarepath/letters/data/letterdata.php";
$pagetitle= 'PRINT ' . $lettdescr . '/' . $letterdate . '/' . $patlastfirst . ' (' . $letthospno . ', ' . $modalstamp . ')';
//log the event?
$eventtype="Letter ID $letter_id PRINTED by $user";
include "$rwarepath/run/logevent.php";
//update printstage
$sql= "UPDATE letterdata SET printstage=2, printdate=NOW() WHERE letter_id=$letter_id";
$result = $mysqli->query($sql);
include "$rwarepath/parts/head_letter.php";
include "$rwarepath/letters/lettersites.php";
$showstatus=false; // PRINT so hide status
$showsig=true; // PRINT elecsig prn
include "$rwarepath/letters/incl/letter2html.php";
echo "</body>
</html>";
//for pageview logs Wed Nov 21 13:17:42 CET 2007
include "$rwarepath/incl/logpageview.php";
