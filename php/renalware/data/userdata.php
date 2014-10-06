<?php
//7 Jan 2014
$table = "userdata";
$where = "WHERE uid=$uid";
$sql= "SELECT * FROM $table $where LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
