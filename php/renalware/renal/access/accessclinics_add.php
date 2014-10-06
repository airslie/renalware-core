<?php
	//insert not update
	$accessclinzid = $zid;
	$accessclindate = $mysqli->real_escape_string($_POST["accessclindate"]);
	$decision = $mysqli->real_escape_string($_POST["decision"]);
	$ixrequests = $mysqli->real_escape_string($_POST["ixrequests"]);
	$surgeon = $_POST["surgeon"];
	$anaesth = $_POST["anaesth"];
	$priority = $_POST["priority"];
	$accessclindate = fixDate($accessclindate);
	//add
$insertfields="accessclinzid, addstamp, accessclinuser, accessclindate, surgeon, decision, ixrequests, anaesth, priority";
$values="$accessclinzid, NOW(), '$user', '$accessclindate', '$surgeon', '$decision', '$ixrequests', '$anaesth', '$priority'";
	$table = "accessclinics";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
	# //log the event
	$eventtype="NEW ACCESS CLINIC: $accessclindate -- $decision $priority under $anaesth (by $surgeon)";
	include "$rwarepath/run/logevent.php";
	showAlert("The Access Clinic for ' . $firstnames . ' ' . $lastname . ' has been recorded!");
?>