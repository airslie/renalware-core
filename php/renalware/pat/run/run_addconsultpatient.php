<?php
//----Fri 23 May 2014----fix patient INSERT for any hospno scenario
//----Fri 07 Feb 2014----fix for non-KCH number handling
//----Fri 28 Feb 2014----episodestatus
//----Mon 06 Jan 2014----redirect to upd AKI episode prn
//----Tue 02 Jul 2013----consultsite, zid fixes
//----Fri 28 Jun 2013----akiriskflag
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
$consultstartdate = fixDate($consultstartdate);
//add to patientdata etc
//ensure hospno1 !exists
//use patsite
switch ($consultsite) {
	case 'KCH':
		$where="WHERE hospno1='$hospno1'";
		$msghospno=$hospno1;
        $hospnofld = 'hospno1';
        $hospnoval = $hospno1;
		break;
	case 'QEH':
		$where="WHERE hospno2='$sitehospno'";
		$msghospno=$sitehospno;
        $hospnofld = 'hospno2';
        $hospnoval = $sitehospno;
		break;
	case 'DVH':
		$where="WHERE hospno3='$sitehospno'";
		$msghospno=$sitehospno;
        $hospnofld = 'hospno3';
        $hospnoval = $sitehospno;
		break;
	case 'BROM':
		$where="WHERE hospno4='$sitehospno'";
		$msghospno=$sitehospno;
        $hospnofld = 'hospno4';
        $hospnoval = $sitehospno;
		break;
	case 'GUYS':
		$where="WHERE hospno5='$sitehospno'";
		$msghospno=$sitehospno;
        $hospnofld = 'hospno5';
        $hospnoval = $sitehospno;
		break;
}
$ward=$tempaddr;
$sql = "SELECT patzid, lastname, firstnames, birthdate FROM renalware.patientdata $where LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$existlastname=$row["lastname"];
	$existfirstnames=$row["firstnames"];
	$existbirthdate=$row["birthdate"];
	//exists
	$errormsg="Sorry! A patient ($existfirstnames $existlastname, DOB $existbirthdate) with the $consultsite hosp No $msghospno is already in the system!";
	$_SESSION['errormsg']=$errormsg;
	header ("Location: $rwareroot/ls/consultlist.php?list=userconsults");	
}
else {
    //cater for each scenario: KCH only; SITE only; both entered
    if ($hospno1 && $sitehospno) {
    	$insertfields="modifstamp, addstamp, hospno1, $hospnofld, title, lastname, firstnames, suffix, sex, birthdate, referrer, refer_date, refer_type, refer_notes, lasteventstamp,lasteventdate, lasteventuser,adduid, adduser, adminnotes,modalcode,modalsite";
    	$values="NOW(), NOW(), '$hospno1', '$hospnoval','$title', '$lastname', '$firstnames', '$suffix', '$sex', '$birthdate', '$referrer', '$refer_date', 'CONSULT', '$refer_notes', NOW(),NOW(),'$user', $uid, '$user','$adminnotes','Consult','KCH'";
    }
    if (!$hospno1 && $sitehospno) {
    	$insertfields="modifstamp, addstamp, $hospnofld, title, lastname, firstnames, suffix, sex, birthdate, referrer, refer_date, refer_type, refer_notes, lasteventstamp,lasteventdate, lasteventuser,adduid, adduser, adminnotes,modalcode,modalsite";
    	$values="NOW(), NOW(), '$hospnoval','$title', '$lastname', '$firstnames', '$suffix', '$sex', '$birthdate', '$referrer', '$refer_date', 'CONSULT', '$refer_notes', NOW(),NOW(),'$user', $uid, '$user','$adminnotes','Consult','KCH'";
    }
    if ($hospno1 && !$sitehospno) {
    	$insertfields="modifstamp, addstamp, hospno1, title, lastname, firstnames, suffix, sex, birthdate, referrer, refer_date, refer_type, refer_notes, lasteventstamp,lasteventdate, lasteventuser,adduid, adduser, adminnotes,modalcode,modalsite";
    	$values="NOW(), NOW(), '$hospno1','$title', '$lastname', '$firstnames', '$suffix', '$sex', '$birthdate', '$referrer', '$refer_date', 'CONSULT', '$refer_notes', NOW(),NOW(),'$user', $uid, '$user','$adminnotes','Consult','KCH'";
    }
	$table = "renalware.patientdata";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
	$result= $mysqli->query($sql);
	$zid = $mysqli->insert_id;
    
	$sql= "UPDATE patientdata SET age=FLOOR(DATEDIFF(NOW(), birthdate)/365.25) WHERE patzid=$zid LIMIT 1";
	$result= $mysqli->query($sql);
    
	$sql= "INSERT INTO renaldata (renalzid) VALUES ($zid)";
	$result= $mysqli->query($sql);
    
	$sql= "INSERT INTO currentclindata (currentclinzid) VALUES ($zid)";
	$result= $mysqli->query($sql);
    
    if ($consultsite=='KCH') {
    	$sql= "INSERT INTO hl7data.pathol_current (currentpid, addstamp) VALUES ('$hospno1', NOW())";
    	$result= $mysqli->query($sql);
    }
	$sql= "INSERT INTO patstats (statzid, statpid) VALUES ($zid, '$hospno1')";
	$result= $mysqli->query($sql);
    
	//log the event
	$eventtype="NEW CONSULT PATIENT ADDED: $hospno1; $firstnames $lastname";
	$eventtext=$enctext;
	include "$rwarepath/run/logevent.php";
	//add to modals
	$insertfields="modalzid, modalcode, modalsitecode, modalstamp, modalnotes, modaluser,modaldate";
	$values="$zid, 'Consult', 'KCH', NOW(), '$consulttype referred by $referrer', '$user', '$refer_date'";
	$table = "modaldata";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
	$result = $mysqli->query($sql);
    
	//log the event
	$eventtype="NEW MODALITY: Consult -- $ward ($consulttype)";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//end logging
	//incr
	incrStat('modals',$zid);
	//update patientdata
	//add to consults
	$insertfields="consultuid,
		consultuser,
		consultstaffname,
		consultzid,
		consultmodal,
		consultstartdate,
		consultward,
		consulttype,
		consultdescr,
        akiriskflag,
		activeflag,
		consultsite,
		othersite,
		contactbleep,
		sitehospno";
	$consultward=$selectward . $otherward;
    $sitehospno = ($consultsite == 'KCH') ? $hospno1 : $sitehospno ;
	$values="$uid,'$user','$consultstaffname',$zid,'Consult--$consultsite', '$consultstartdate','$consultward','$consulttype', '$consultdescr','$akiriskflag','Y','$consultsite','$othersite','$contactbleep','$sitehospno'";
	$table = "consultdata";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
	$result = $mysqli->query($sql);
    $newconsult_id = $mysqli->insert_id;
	//log the event
	$eventtype="NEW CONSULT: $consulttype $consultsite-- Referred by: $referrer";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
    //----Fri 20 Dec 2013----create AKI episode prn
    if ($akiriskflag=='Y') {
        $insertfields="akiuid,
        akiuser,
        akizid,
        consultid,
        akiadddate,
        episodedate,
        referraldate,
        episodestatus";
        $insertvalues="$uid,'$user',$consultzid,$newconsult_id,CURDATE(),'$consultdate','$consultdate','Suspected'";
        $table = "renalware.akidata";
        $sql= "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
        $result = $mysqli->query($sql);
        $newepisode_id = $mysqli->insert_id;
        //log event
        $eventtype="NEW AKI EPISODE $newepisode_id VIA CONSULT $newconsult_id: $consulttype -- $consultward";
        $eventtext=$mysqli->real_escape_string($sql);
        include "$rwarepath/run/logevent.php";
    }
    if ($akiriskflag=='Y') {
    	header ("Location: $rwareroot/aki/upd_consultepisode.php?zid=$consultzid&id=$newepisode_id");	
    } else {
    	header ("Location: $rwareroot/ls/consultlist.php?list=userconsults");	
    }
}
