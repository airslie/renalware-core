<?php
//----Mon 25 Feb 2013----insert to timeline
//----Tue 15 Jun 2010----
foreach ($_POST as $key => $value) {
	${$key}=$mysqli->real_escape_string($value);
	if (substr($key,-4)=="date") {
		${$key}=fixDate(${$key});
	}
}
if (!$drug_id) {
	list($drug_id,$newdrugname)=explode("|",$drugid_name);
}
//fix
$route=strtoupper($route);
//add to meds ----Tue 15 Jun 2010----use drugname, immflag from druglist
$insertfields = "medzid, dose, route, freq, drugnotes, adddate, medmodal, modifstamp, adduser, drug_id, adduid, provider, drugname, immunosuppflag";
$values="$zid, '$dose', '$route', '$freq', '$drugnotes', '$adddate', '$modalcode', NOW(), '$user', $drug_id, $uid,'$provider'"; 
$table = "medsdata";
$sql= "INSERT INTO $table ($insertfields) SELECT $values, drugname, immunosuppflag FROM druglist WHERE drug_id=$drug_id";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW MEDICATION ADDED: $newdrugname (ID $drug_id) $dose $route $freq (prov: $provider)";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
incrStat('meds',$zid);
stampPat($zid);
//if immunosupp...
if ($immunosuppflag)
	{
	//all we will do is insure 'flag is TRUE in patientdata...may already be 1
	$sql= "UPDATE patientdata SET immunosuppflag=1 WHERE patzid=$zid";
	$result = $mysqli->query($sql);
	}
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
$timelinedescr="Meds list updated ($nummeds meds)";
$timelinetext=$medlist;
include "$rwarepath/pat/run/insert_timeline.php";
showAlert("$eventtype");
