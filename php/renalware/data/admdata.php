<?php
//Tue Feb  5 14:46:21 GMT 2008
$table = "admissiondata";
$where = "WHERE admission_id=$admid";
$sql= "SELECT * FROM $table $where LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>