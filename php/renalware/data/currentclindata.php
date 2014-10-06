<?php
//Sun Dec 20 12:44:09 JST 2009
$sql= "SELECT * FROM currentclindata WHERE currentclinzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
$currBP="$BPsyst/$BPdiast";
?>