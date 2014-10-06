<?php
//get data if exists
//----Wed 02 Feb 2011----fix
$table="homehdassessdata";
$sql = "SELECT homehdassess_id FROM $table WHERE homehdassesszid=$zid";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$row = $result->fetch_assoc();
	$record_id=$row["homehdassess_id"]; //for update link
	echo "<h3>Home Haemo Assessment</h3>";
	//link for update
	$linkval="Update Home HD Assessment";
	$linkurl='renal/homehd/upd_assessmentform.php?zid='.$zid.'&amp;record_id='.$record_id;
	makeredButton($linkval,$linkurl);
	//show data
	include 'homehd/homehdassessdata_incl.php';
	} else {
	//link to form
	$linkval="Add New Home HD Assessment";
	$linkurl='renal/homehd/add_assessmentform.php?zid='.$zid;
	makeredButton($linkval,$linkurl);
}
?>