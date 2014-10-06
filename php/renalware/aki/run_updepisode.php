<?php
//----Mon 06 Jan 2014----redirect to consults prn
//----Sun 29 Dec 2013----
//--Tue Mar  5 14:41:18 EST 2013--
require 'req_fxnsconfig.php';
$table="akidata";
$tableid="aki_id";
$thisid=$post_aki_id;
$updatefields="akimodifdt=NOW(),akimodifdate=CURDATE()";
$ignoreflds = array('akizid','aki_id','consultflag');
foreach ($_POST as $field => $value) {
    if (!in_array($field, $ignoreflds)) {
    	$fieldvalue=$mysqli->real_escape_string($value);
    	${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
    	$updatefields .= ", $field='${$field}'";
    }
}
//special calculations here:
$existingckdscore = (strpos($ckdstatus,'CKD')) ? 1 : 0 ;
//risk score
$akiriskscore=$elderlyscore+$existingckdscore+$cardiacfailurescore+$diabetesscore+$liverdiseasescore+$vasculardiseasescore+$nephrotoxicmedscore;
$updatefields .= ", akiriskscore=$akiriskscore";
//update the table
$sql= "UPDATE $table SET $updatefields WHERE $tableid=$thisid LIMIT 1";
$result = $mysqli->query($sql);
//log the event
$eventtype="AKI episode $thisid updated";
$eventtext=$mysqli->real_escape_string($updatefields);
include "$rwarepath/run/logevent.php";
$_SESSION['successmsg']=$eventtype;
if ($post_consultflag=='Y') {
    header ("Location: $rwareroot/ls/consultlist.php?list=userconsults");
} else {
    header ("Location: view_episode.php?ls=list_episodes&zid=$post_akizid&id=$post_aki_id");
}
