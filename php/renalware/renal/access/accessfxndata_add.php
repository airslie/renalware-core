<?php
foreach ($_POST as $key => $value) {
	${$key}=$mysqli->real_escape_string($value);
}
$assessmentdate = fixDate($assessmentdate);
$proceduredate = fixDate($proceduredate);
$insertfields="accessfxnzid, accessfxnuser, addstamp, modalstamp, assessmentdate, accesstype, assessmentmethod, flow_feedartery, artstenosisflag, artstenosistext, venstenosisflag, venstenosistext, rx_decision, proceduredate, proced_type, proced_outcome, residualstenosisflag,surveillance,assessmentoutcome";
$values="$zid, '$user', NOW(), '$modalcode', '$assessmentdate', '$accesstype', '$assessmentmethod', '$flow_feedartery','$artstenosisflag', '$artstenosistext', '$venstenosisflag', '$venstenosistext', '$rx_decision', '$proceduredate', '$proced_type', '$proced_outcome', '$residualstenosisflag','$surveillance','$assessmentoutcome'";
$table = "accessfxndata";
$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//special update renaldata
$sql = "UPDATE renaldata SET accessLastAssessdate='$assessmentdate',accessRxDecision='$rx_decision',accessSurveillance='$surveillance',accessAssessOutcome='$assessmentoutcome',renalmodifstamp=NOW() WHERE renalzid=$zid";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW DUPLEX ULTRASOUND ASSESSMENT: $assessmentdate";
include "$rwarepath/run/logevent.php";
showAlert("The Assessment for ' . $firstnames . ' ' . $lastname . ' has been recorded!");
?>