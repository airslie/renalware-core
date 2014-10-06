<?php
//----Sun 09 Mar 2014----provider
//----Mon 25 Feb 2013----timeline
//***NOT FOR ESA***
$updatemed_id = $_POST["medsdata_id"];
$newdose = $_POST["newdose"];
$newfreq = $_POST["newfreq"];
//get existing data
$sql="SELECT drug_id, drugname, route, dose, freq, immunosuppflag, provider FROM medsdata WHERE medsdata_id=$updatemed_id";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$olddrug=$row["drugname"];
$olddrug_id=$row["drug_id"];
$oldroute=strtoupper($row["route"]);
$olddose=$row["dose"];
$oldfreq=$row["freq"];
$immunosuppflag=$row["immunosuppflag"];
$provider=$row["provider"];
//others come from above
	$olddrugdata =  $row['drugname'] . " " . $row["dose"] . " " .  $row['route'] . " " .  $row['freq'];
//we only set termdate NOW not delete
$sql= "UPDATE medsdata SET termdate=NOW(), termflag=1, modifstamp=NOW(), termuser='$user' WHERE medsdata_id=$updatemed_id";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient $zid: Med ID $updatemed_id ($olddrugdata) terminated";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
//now insert new drug data
$insertfields = "medzid, drugname, dose, route, freq, adddate, medmodal, immunosuppflag, modifstamp, adduser, drug_id, adduid, provider";
$values="$zid, '$olddrug', '$newdose', '$oldroute', '$newfreq', NOW(), '$modalcode', '$immunosuppflag', NOW(), '$user', '$olddrug_id', $uid, '$provider'"; 
$table = "medsdata";
$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient $zid: Med ID $updatemed_id ($olddrug) modified from $olddose $oldfreq to dose: $newdose freq: $newfreq";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
//set pat modifstamp
stampPat($zid);
//----Mon 25 Feb 2013----NEW add to timeline
//$values="$uid, '$user','$timelinecode', $zid, '$timelineadddate', '$timelinedescr', '$timelinetext'";
//compile new meds list
//simple current meds list
$sql= "SELECT drugname, dose, route, freq, DATEDIFF(CURDATE(),adddate) as rxdays, adddate FROM medsdata WHERE medzid=$zid AND termflag=0 ORDER BY drugname";
$result = $mysqli->query($sql);
$nummeds = $result->num_rows;
$medlist = ""; //set null
 while($row = $result->fetch_assoc()) {
 	$medlist .= $row['drugname'] . " " . $row['dose'] . " " . $row['route'] . " " . $row['freq'] . "\n";
}
$timelinecode='MEDS';
$timelineadddate=$adddate;
$timelinedescr="Meds list $olddrug updated ($nummeds meds)";
$timelinetext=$medlist;
include "$rwarepath/pat/run/insert_timeline.php";
showAlert("$eventtype");
