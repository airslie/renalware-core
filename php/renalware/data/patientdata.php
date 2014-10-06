<?php
//----Sun 03 Aug 2014----$blackflag DEPR
//Tue Feb  5 14:45:34 GMT 2008
$table = "renalware.patientdata p";
$sql = "SELECT * FROM $table WHERE patzid=$zid LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
foreach($row AS $key => $value)
	{
	$$key = ($value) ? $value : FALSE ;
	if (strtolower(substr($key,-4))=="date" && $value)
		{
		${$key} = dmyyyy($value);
		}
	}
	//misc tweaks
	$birthdateymd=$row["birthdate"]; //for results
	//gp
	$gpref= strtoupper($gp_name) . ", $gp_addr1 $gpaddr2 $gpaddr3 $gpaddr4 $gp_postcode";
	$hospnos="";
	if ($hospno1) {
		$hospnos.="KCH: $hospno1&nbsp;&nbsp;";
		$pid=$hospno1;
		
	}
	if ($hospno2) {
		$hospnos.="QEH: $hospno2&nbsp;&nbsp;";
	}
	if ($hospno3) {
		$hospnos.="DVH: $hospno3&nbsp;&nbsp;";
	}
	if ($hospno4) {
		$hospnos.="BROM: $hospno4&nbsp;&nbsp;";
	}
	if ($hospno5) {
		$hospnos.="GUYS: $hospno5&nbsp;&nbsp;";
	}
	$pat_ref= "$title $firstnames " . strtoupper($lastname) . " $suffix ($sex; DOB: $birthdate; HospNo: $hospnos NHSNo: $nhsno)";
	$pat_addr= "$addr1 $addr2 $addr3 $addr4 $postcode";
	$patref_addr= "$pat_ref<br/>\n$pat_addr";
	if ($tel1) {
		$patref_addr .= "&nbsp;&nbsp;&nbsp;Tel(1): $tel1";
	}
	if ($tel2) {
		$patref_addr .= "&nbsp;&nbsp;&nbsp;Tel(2): $tel2";
	}
	$titlestring = strtoupper($lastname) . ', ' . $firstnames . ' -- ' . $hospnos . ' (' . $age . 'yo ' . $sex . ' dob ' . $birthdate .' -- ' . $modalcode . ' ' . $modalsite . ')';
//get counts and renal stuff
$fields="letters as count_letters, meds as count_meds, problems as count_probs, modals as count_modals, admissions as count_admissions, encounters as count_encounters, pathix as count_pathix, ixdata as count_ixdata, hdsess as count_hdsess, bpwts as count_bpwts, ops as count_ops, events as count_events";
$tables = "renalware.patstats";
$sql = "SELECT $fields FROM $tables WHERE statzid=$zid LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
include "$rwarepath/fxns/parserows.php";

