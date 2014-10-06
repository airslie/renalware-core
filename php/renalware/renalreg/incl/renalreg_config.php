<?php
$debug = ($_GET["debug"]=="Y") ? TRUE : FALSE ;
$limitno = 100;
$limit = ($debug) ? "LIMIT $limitno" : "" ;
$db="renalware";
$center='RJZ';
require '/var/conns/renalregconn.php';
$versionstamp="Fri May 30 16:39:52 EDT 2014";
