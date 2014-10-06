<?php
//Sun Dec 20 12:49:09 JST 2009
$fields="psychsoc_housing, psychsoc_socialnetwork, psychsoc_carepackage, psychsoc_other, psychsoc_stamp";
$sql= "SELECT $fields FROM renaldata WHERE renalzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>