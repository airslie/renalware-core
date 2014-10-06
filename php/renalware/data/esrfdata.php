<?php
//----Wed 06 Aug 2014----get PRD term from JOIN
//Sun Dec 20 14:37:20 JST 2009
$sql= "SELECT esrfdata.*, prdterm FROM esrfdata LEFT JOIN rreg_prdcodes ON rreg_prdcode=prdcode WHERE esrfzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
