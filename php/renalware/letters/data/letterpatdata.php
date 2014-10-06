<?php
//----Mon 10 Jun 2013----streamlining and sendCDAflag
//get patientdata
$tables = "renalware.patientdata";
$sql= "SELECT * FROM $tables WHERE patzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
	//fixes
$patlastfirst= $lastname . ', ' . $firstnames;
$patfirstlast= $firstnames . ' ' . $lastname;
$birthdate=dmyyyy($row['birthdate']);
$hospnos="";
if ($hospno1) {
	$hospnos.="KCH: $hospno1&nbsp;&nbsp;";
}
if ($hospno2) {
	$hospnos.="QEH: $hospno2&nbsp;&nbsp;";
}
if ($hospno3) {
	$hospnos.="DVH: $hospno3&nbsp;&nbsp;";
}
$patref= "$title $firstnames " . strtoupper($lastname) . " $suffix ($sex; DOB: $birthdate; $hospnos)";
$pataddrhoriz= "$addr1 $addr2 $addr3 $addr4 $postcode";
$patrecip= "$title $firstnames $lastname $suffix^$addr1^$addr2^$addr3 $addr4 $postcode";
$patblock= "$title $firstnames $lastname $suffix\n$addr1\n$addr2\n$addr3 $addr4 $postcode";
$gpaddrblock= $row['gp_addr1'] . "\n" . $row['gp_addr2'] . "\n" . $row['gp_addr3'] . " " . $row['gp_addr4'] . " " . $row['gp_postcode'];
$gpblock = $gp_name . "\n" . $gpaddrblock;
$patsalut="Dear $title $lastname";
$gplastname=lastWord($gp_name); // might be Dr AN One or just Dr Smith
$gpsalut="Dear Dr $gplastname";
//get core renaldata
$fields = "clinAllergies, accessCurrent, esdstatus, esdregime, endstagedate, txWaitListStatus";
$tables = "renaldata LEFT JOIN esddata ON renalzid=esdzid";
$sql= "SELECT $fields FROM $tables WHERE renalzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
//----Mon 30 Jan 2012----get GP email status
//----Mon 10 Jun 2013----combine into one query
$sendemailflag=false;
$sendCDAflag=false;
$sql = "SELECT p.* FROM hl7data.practicecodes p JOIN hl7data.gpdata g ON p.practicecode=g.practicecode JOIN renalware.patientdata pd ON gpcode=gp_natcode WHERE patzid=$zid LIMIT 1";
//echo "$sql";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$practiceemail=$row["practiceemail"];
$practicecode=$row["practicecode"];
$practicename=$row["practicename"];
$sendemailflag=$row["sendemailflag"];
$sendCDAflag=$row["sendCDAflag"];
if ($sendemailflag) {
    //append to GP addr
    $gpblock.= "\nVIA EMAIL to $practiceemail";
}
if ($sendCDAflag) {
    //append to GP addr
    $gpblock.= "\nVIA DocMan direct to Practice";
}
