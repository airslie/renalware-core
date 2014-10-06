<?php
//----Fri 15 Nov 2013----int
require '../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$zid = (int)$_GET['zid'];
$letter_id = (int)$_GET['letter_id'];
$status="DRAFT";
$archiveflag=false;
include "$rwarepath/letters/data/letterdata.php";
$pagetitle= 'PREVIEW ' . $lettdescr . '/' . $letterdate . '/' . $patlastfirst . ' (' . $letthospno . ', ' . $modalstamp . ')';
include "$rwarepath/parts/head_letter.php";
include "$rwarepath/letters/lettersites.php";
$showstatus=true; //not PRINT
$showsig=false; //not PRINT
include "$rwarepath/letters/incl/letter2html.php";
echo '</body>
</html>';
//for pageview logs Wed Nov 21 13:17:42 CET 2007
include "$rwarepath/incl/logpageview.php";
