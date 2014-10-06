<?php
//Sun Dec 20 13:01:43 JST 2009
$fields = "gp_natcode, gp_name, gp_addr1, gp_addr2, gp_addr3, gp_addr4, gp_postcode, gp_tel, gp_fax, gp_email";
$tables = "renalware.patientdata";
$where = "WHERE patzid=$zid LIMIT 1";
$sql= "SELECT $fields FROM $tables $where";
include "$rwarepath/incl/runparsesinglerow.php";
?>