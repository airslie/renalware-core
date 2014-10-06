<?php
//----Tue 11 Sep 2012----
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//get pat data via zid
$fields="
title,
lastname,
firstnames,
suffix,
hospno1,
sex, age,
IF(birthdate, DATE_FORMAT(birthdate, '%d/%m/%y'),'') AS birthdate,
maritstatus,
ethnicity,
religion,
language,
interpreter,
specialneeds,
addr1,
addr2,
addr3,
addr4,
postcode,
tel1,
tel2,
fax,
mobile,
email,
gp_name,
gp_addr1,
gp_addr2,
gp_addr3,
gp_addr4,
gp_postcode,
gp_tel,
gp_fax,
gp_email,
healthauthcode,
modalcode,
modalsite,
currsched,
currslot
";
$table="renalware.patientdata LEFT JOIN renalware.hdpatdata ON patzid=hdpatzid";
$where="WHERE patzid=$zid";
$sql="SELECT $fields FROM $table $where LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
foreach ($row as $key => $value) {
    ${$key}=$value;
}
$patientref=$row["firstnames"] . ' ' . $row["lastname"] . ' (Hosp No. ' . $row["hospno1"] . ' DOB: ' . $row["birthdate_dmy"] .')';
$hospno=$row["hospno1"];
$patient=$row["firstnames"] . ' ' . $row["lastname"];
