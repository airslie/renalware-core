<?php
//Sun Dec 20 13:07:26 JST 2009
$sql= "SELECT * FROM txops WHERE txop_id=$txop_id LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>