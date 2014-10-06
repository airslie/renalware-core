<?php
//Thu May 21 13:16:33 CEST 2009 esdtable INSERT added
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
}
//extras
$birthdate = "$dob_year-$dob_month-$dob_day";
$refer_date = fixDate($refer_date);
$ccflagdate = fixDate($ccflagdate);
//add to patientdata etc

//ensure hospno1 !exists
//use patsite
$kchpatflag=FALSE;
switch ($patsite) {
	case 'KCH':
		$where="WHERE hospno1='$hospno1'";
		$msghospno=$hospno1;
		$thishospnofld="hospno1";
		$thishospno=$hospno1;
		$kchpatflag=TRUE;
		break;
	case 'QEH':
		$where="WHERE hospno2='$hospno2'";
		$msghospno=$hospno2;
		$thishospnofld="hospno2";
		$thishospno=$hospno2;
		break;
	case 'DVH':
		$where="WHERE hospno3='$hospno3'";
		$msghospno=$hospno3;
		$thishospnofld="hospno3";
		$thishospno=$hospno3;
		break;
	case 'BROM':
		$where="WHERE hospno4='$hospno4'";
		$msghospno=$hospno4;
		$thishospnofld="hospno4";
		$thishospno=$hospno4;
		break;
}

$sql = "SELECT patzid, lastname, firstnames, birthdate FROM renalware.patientdata $where LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$existlastname=$row["lastname"];
	$existfirstnames=$row["firstnames"];
	$existbirthdate=$row["birthdate"];
	//exists
	$errormsg="Sorry! A patient ($existfirstnames $existlastname, DOB $existbirthdate) with the $patsite hosp No $msghospno is already in the system!";
	$_SESSION['errormsg']=$errormsg;
	header ("Location: $rwareroot/pat/addpatient.php");	

}
else {
	$insertfields="modifstamp, addstamp, $thishospnofld, hosprefno, privpatno, nhsno, title, lastname, firstnames, suffix, sex, birthdate, maritstatus, ethnicity, religion, language, interpreter, specialneeds, ccflag, addr1, addr2, addr3, addr4, postcode, tel1, tel2, fax, mobile, email, tempaddr, nok_name, nok_addr1, nok_addr2, nok_addr3, nok_addr4, nok_postcode, nok_tels, nok_email, nok_notes, gp_natcode, gp_name, healthauthcode, referrer, refer_date, refer_type, refer_notes, lasteventstamp, gp_addr1, gp_addr2, gp_addr3, gp_addr4, gp_postcode, gp_tel, gp_fax, gp_email, ccflagdate, adduid, adduser, adminnotes,defaultccs,patsite";
	$values="NOW(), NOW(), '$thishospno','$hosprefno', '$privpatno', '$nhsno', '$title', '$lastname', '$firstnames', '$suffix', '$sex', '$birthdate', '$maritstatus', '$ethnicity', '$religion', '$language', '$interpreter', '$specialneeds', '$ccflag', '$addr1', '$addr2', '$addr3', '$addr4', '$postcode', '$tel1', '$tel2', '$fax', '$mobile', '$email', '$tempaddr', '$nok_name', '$nok_addr1', '$nok_addr2', '$nok_addr3', '$nok_addr4', '$nok_postcode', '$nok_tels', '$nok_email', '$nok_notes', '$gp_natcode', '$gp_name', '$healthauthcode', '$referrer', '$refer_date', '$refer_type', '$refer_notes', '$lasteventstamp', '$gp_addr1', '$gp_addr2', '$gp_addr3', '$gp_addr4', '$gp_postcode', '$gp_tel', '$gp_fax', '$gp_email', '$ccflagdate', $uid, '$user','$adminnotes','$defaultccs','$patsite'";
	$table = "renalware.patientdata";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
	$result= $mysqli->query($sql);
	$zid = $mysqli->insert_id;
	$sql= "UPDATE patientdata SET age=FLOOR(DATEDIFF(NOW(), birthdate)/365.25) WHERE patzid=$zid LIMIT 1";
	$result= $mysqli->query($sql);
	$sql= "INSERT INTO renaldata (renalzid) VALUES ($zid)";
	$result= $mysqli->query($sql);
	$sql= "INSERT INTO viroldata (virolzid, viroladdstamp,viroldate) VALUES ($zid,NOW(),NOW())";
	$result= $mysqli->query($sql);
	$sql= "INSERT INTO esddata (esdzid, esdstamp) VALUES ($zid, NOW())";
	$result= $mysqli->query($sql);
	$sql= "INSERT INTO currentclindata (currentclinzid,currentadddate) VALUES ($zid,NOW())";
	$result= $mysqli->query($sql);
	if ($kchpatflag) {
		$sql = "SELECT currentpath_id FROM hl7data.pathol_current WHERE currentpid='$hospno1'";
		$result = $mysqli->query($sql);
		$numrows=$result->num_rows;
		if ($numrows==0) {
			$sql= "INSERT INTO hl7data.pathol_current (currentpid, addstamp) VALUES ('$hospno1', NOW())";
			$result= $mysqli->query($sql);
		}
	}
	$sql= "INSERT INTO patstats (statzid, statpid) VALUES ($zid, '$hospno1')";
	$result= $mysqli->query($sql);
	//log the event
	$eventtype="NEW $patsite PATIENT ADDED: $hospno1; $firstnames $lastname";
	$eventtext=$enctext;
	include "$rwarepath/run/logevent.php";
	//redirect to modals
	$runmsgtxt="Please continue by adding modality data for $firstnames $lastname here.";
	$_SESSION['runmsg']=$runmsgtxt;
	header ("Location: $rwareroot/pat/patient.php?vw=modals&zid=$zid");	
}
?>