<?php
$admzid = $get_zid;
foreach ($_POST as $key => $value) {
		$escvalue=$mysqli->real_escape_string($value);
		${$key} = (substr($key,-4)=="date") ? fixDate($escvalue) : $escvalue ;
}
$reason = trim($reason . " " . $reasontext);
//set session consultant
$_SESSION['admconsultant']=$consultant;
//add to admissions
$insertfields = 'admdate, admward, consultant, admtype, reason, admzid, admaddstamp, admmodal, admittedflag, admstatus, admhospno1, currward';
$values="'$admdate', '$admward', '$consultant', '$type', '$reason', $admzid, NOW(), '$admmodal', 1, 'Admitted', '$hospno1', '$admward'"; 
$table = "admissiondata";
$sql = "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW ADMISSION: $admdate to $admward by $consultant type: $type";
$eventtext=$reason;
include "$rwarepath/run/logevent.php";
//incr
incrStat('admissions',$zid);
//set pat modifstamp
stampPat($zid);
header ("Location: $rwareroot/admissions/inpatientlist.php");
?>