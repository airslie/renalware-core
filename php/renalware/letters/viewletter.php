<?php
include '../req/confcheckfxns.php';
$zid = $_GET['zid'];
$letter_id = $_GET['letter_id'];
include "$rwarepath/letters/data/letterdata.php";
$pagetitle= 'VIEW ' . $lettdescr . ' [' . $letterdate . '] ' . htmlspecialchars($patlastfirst, ENT_QUOTES) . ' (' . $letthospno . ', ' . $modalstamp . ')';
//log the event?
$eventtype="Letter ID $letter_id ($lettdescr) VIEWED by $user";
include "$rwarepath/run/logevent.php";
include "$rwarepath/parts/head_letter.php";
include "$rwarepath/letters/lettersites.php";
$showstatus=true; //not PRINT
$showsig=true; //show
include "$rwarepath/letters/incl/letter2html.php";
echo '</body>
</html>';
//for pageview logs Wed Nov 21 13:17:42 CET 2007
include "$rwarepath/incl/logpageview.php";
