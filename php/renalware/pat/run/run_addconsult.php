<?php
//----Fri 28 Feb 2014----episodestatus
//----Mon 06 Jan 2014----redirect to episode prn
//----Fri 20 Dec 2013----create AKI record
//----Fri 28 Jun 2013----akiriskflag
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
}
$consultdate = fixDate($consultdate);
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
$insertvalues="$uid,'$user','$consultstaffname',$consultzid, '$consultmodal', '$consultdate','$consultward','$consulttype', '$consultdescr','$akiriskflag','Y','$consultsite','$othersite','$contactbleep','$sitehospno'";
$table = "renalware.consultdata";
$sql= "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
$newconsult_id = $mysqli->insert_id;
//log the event
$zid=$consultzid;
$eventtype="NEW CONSULT: $consulttype -- $consultward";
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
	header ("Location: $rwareroot/ls/consultlist.php");	
}