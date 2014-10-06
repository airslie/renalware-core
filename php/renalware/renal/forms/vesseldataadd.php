<?php
//start
if ($_GET['mode']=="add")
	{
	//insert not update
	$vessdatazid = $zid;
	$assessmentdate = $mysqli->real_escape_string($_POST["assessmentdate"]);
	$vessel = $mysqli->real_escape_string($_POST["vessel"]);
	$assessment = $mysqli->real_escape_string($_POST["assessment"]);
	$assessor = $mysqli->real_escape_string($_POST["assessor"]);
	$modalstamp = $modalcode;
	$method = $mysqli->real_escape_string($_POST["method"]);
	$diameter = $mysqli->real_escape_string($_POST["diameter"]);
	$flowrate = $mysqli->real_escape_string($_POST["flowrate"]);
	$stenosis = $mysqli->real_escape_string($_POST["stenosis"]);
	$stenosis_site = $mysqli->real_escape_string($_POST["stenosis_site"]);
	$surgreferflag = $mysqli->real_escape_string($_POST["surgreferflag"]);
	$surgreferdate = $mysqli->real_escape_string($_POST["surgreferdate"]);
	$vesseluser = $user;
	$assessmentdate = fixDate($assessmentdate);
	$surgreferdate = fixDate($surgreferdate);
	//add
	$insertfields="vessdatazid, assessmentdate, vessel, assessment, assessor, modalstamp, method, diameter, flowrate, stenosis, stenosis_site, surgreferflag, surgreferdate, vesseluser";
	$values="'$vessdatazid', '$assessmentdate', '$vessel', '$assessment', '$assessor', '$modalstamp', '$method', '$diameter', '$flowrate', '$stenosis', '$stenosis_site', '$surgreferflag', '$surgreferdate', '$vesseluser'";
	$table = "vesseldata";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
	$result = $mysqli->query($sql);
	# //log the event
	$eventtype="NEW VESSEL ASSESSMENT: $assessmentdate -- $vessel = $assessment (by $assessor)";
	include "$rwarepath/run/logevent.php";
	echo '<p class="alert">The Vessel Assessment for ' . $firstnames . ' ' . $lastname . ' has been recorded!</p><br>
	<small><a href="javascript:window.close();">You may now close this window.</a></small>';
	 }
//end ADD
?>