<?php
$table = "problemdata";
foreach ($_POST as $key => $value) {
		$valuefix = (substr($key,-4)=="date") ? fixDate($value) : $value ;
		${$key}=$mysqli->real_escape_string($valuefix);
}
$problemfull = trim($icd10renal . ' ' . $icd10freetext);
$insertfields = "probzid, problem, probuser, probuid, probstamp,probdate";
$insertvalues="$zid, '$problemfull', '$user', $uid, NOW(),NOW()";
//run INSERT
$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
	//log the event
$eventtype="NEW RENAL DIAGNOSIS: $problemfull";
$eventtext=$mysqli->real_escape_string($sql);
include "../run/logevent.php";
incrStat('problems',$zid);
//set pat modifstamp
stampPat($zid);
showAlert("<b>' . $problemfull . '</b> has been added!");
?>