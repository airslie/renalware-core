<?php
//Sun Dec 20 12:45:15 JST 2009
$sql= "SELECT * FROM esddata WHERE esdzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>