<?php
//Fri Aug  8 14:55:17 CEST 2008
//----Fri 02 Mar 2012----overhaul
//handle CCs
	$cctext = $mysqli->real_escape_string($_POST['cctext']);
	if ($post_clearccs=="Y") {
		$cctext="\n\n";
	}
	//handle defaultccs if EDIT
	if ($_POST['editdefaultccs']) {
		$newdefaultccs = $mysqli->real_escape_string($_POST["editdefaultccs"]);
		$sql = "UPDATE patientdata SET defaultccs='$newdefaultccs' WHERE patzid=$zid";
		$result = $mysqli->query($sql);
	}
	//handle deleted eCCs:
	foreach($_POST AS $key => $value)
		{
		if (substr($key,0,8)=="deletecc")
			{
			$deletecc_id = $value;
			$sql = "DELETE FROM letterccdata WHERE lettercc_id=$deletecc_id LIMIT 1";
			$result = $mysqli->query($sql);
			}
		}
	//handle NEW electr CCs
	if ($_POST['electrccs']) {
		$electrccuids=$_POST['electrccs'];
		//run INSERTS; NB default cc status=0 (unsent) until archived
		foreach ($electrccuids as $key => $cc_uid) {
			$insertfields="cc_uid, ccuser, recip_uid,ccletter_id,cczid";
			$insertvalues="$uid, '$user', $cc_uid,$letter_id,$zid";
			$sql = "INSERT INTO letterccdata ($insertfields) VALUES ($insertvalues)";
			$mysqli->query($sql);
		}
	}
?>	