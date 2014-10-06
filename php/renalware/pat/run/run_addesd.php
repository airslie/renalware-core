<?php
//----Thu 24 Apr 2014----add $mcg2iu to handle Aranesp conversion
//----Sun 09 Mar 2014----add provider data
//Thu May 21 15:37:52 CEST 2009 fix re esdflag status and esdsql
//now uses arrays from ESAoptions.php
//need Wt data for units stuff
$freqarray = array(
	'.25' => 'once every 4 weeks',
	'.5' => 'once every 2 weeks',
	'1' => 'once per week',
	'2' => 'twice per week',
	'3' => '3 times per week',
	'4' => '4 times per week'
	);
$newdrug_id = $_POST["drug_id"]; //not medsdata_id!
//filter if mcg or iu
if ($post_mcgdose) {
    //drug_id 358 = Aranesp else Mircera ----Thu 24 Apr 2014----
    $mcg2iu = ($newdrug_id == 358) ? 200 : 424 ;
	$esddose=$post_mcgdose;
	$units=(int)$post_mcgdose * $mcg2iu;
} else {
	$esddose=$post_iudose;
	$units=(int)$post_iudose;
}
$route = $_POST["route"];
$esdfreq = $_POST["esdfreq"];
$drugnotes = $mysqli->real_escape_string($_POST["drugnotes"]);
$adddate = $mysqli->real_escape_string($_POST["adddate"]);
$adddate = fixDate($adddate);
$freqtext=$freqarray[$esdfreq];
$unitsperwk = $units*$esdfreq;
$unitsperwkperkg= round(($unitsperwk/$Weight),1);
//add to medsdata
//get drug data NB MUST BE ESA
$sql="SELECT drugname FROM druglist WHERE drug_id=$newdrug_id LIMIT 1";	
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
	$newdrug = $row['drugname'];
//NB on reflection inserting ESA unitsperwk not units into "esdunitsperweek" field
$insertfields = "medzid, drugname, dose, route, freq, drugnotes, adddate, medmodal, esdflag, esdunitsperweek, modifstamp, adduser, drug_id, adduid, provider";
$values="$zid, '$newdrug', '$esddose', '$route', '$freqtext', '$drugnotes', '$adddate', '$modalcode', 1, '$unitsperwk', NOW(), '$user', $newdrug_id, $uid, '$provider'"; 
$table = "medsdata";
$sql = "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW ESA MEDICATION: $newdrug $esddose $route $freqtext ($unitsperwk iu/week)";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
//end logging
//incr
incrStat('meds',$zid);
//set pat modifstamp
stampPat($zid);
//b/c ESA...
//first find if already on ESA
$sql = "SELECT esdflag FROM patientdata WHERE patzid=$zid LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$curresdflag=$row["esdflag"];
if ($curresdflag==1) {
	//already ESA
	$esdeventtype="MODIFIED";
	$esdsql = "UPDATE esddata SET esdstamp=NOW(), esdstatus ='Current', esdregime ='$newdrug $esddose $route $freqtext', unitsperweek = $unitsperwk, unitsperwkperkg=$unitsperwkperkg, esdmodifdate=NOW() WHERE esdzid=$zid LIMIT 1";
} else {
 	//STARTDATE ESA
	$esdeventtype = "COMMENCED";
	$esdsql = "UPDATE esddata SET esdstamp=NOW(),esdstartdate=NOW(), esdstatus ='Current', esdregime ='$newdrug $esddose $route $freqtext', unitsperweek = $unitsperwk, unitsperwkperkg=$unitsperwkperkg, esdmodifdate=NOW() WHERE esdzid=$zid LIMIT 1";
}
$result = $mysqli->query($esdsql);
//update pat esdflag NB stays 1 even if discontinued
$sql = "UPDATE patientdata SET esdflag=1 WHERE patzid=$zid LIMIT 1";
$result = $mysqli->query($sql);
//log the event... WTH
$eventtype="ESA $esdeventtype -- $newdrug $esddose $route $freqtext";
include "$rwarepath/run/logevent.php";
//end logging
$_SESSION['runmsg']=$eventtype;
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
$timelinedescr="Meds List: ESA Added ($nummeds meds)";
$timelinetext=$medlist;
include "$rwarepath/pat/run/insert_timeline.php";
showAlert("$eventtype");
