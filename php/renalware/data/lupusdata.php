<?php
//--Thu Nov  1 14:36:41 CET 2012--
$sql= "SELECT * FROM lupusdata WHERE lupuszid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
