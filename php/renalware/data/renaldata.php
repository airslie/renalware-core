<?php
//Thu May 14 23:35:08 BST 2009
//Sun Dec 20 12:36:43 JST 2009
$sql= "SELECT * FROM renaldata WHERE renalzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
if ($endstagedate) {
	$sql= "SELECT * FROM esrfdata WHERE esrfzid=$zid LIMIT 1";
	include "$rwarepath/incl/runparsesinglerow.php";
}
?>