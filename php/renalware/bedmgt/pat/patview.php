<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
	$zid=(int)$_GET['zid'];
	$sql="SELECT lastname, firstnames, hospno1 FROM renalware.patientdata WHERE patzid=$zid LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$lastname=$row["lastname"];
	$firstnames=$row["firstnames"];
	$hospno=$row["hospno1"];
	$wherestart="WHERE pzid=$zid";
	echo "<h2>$firstnames $lastname ($hospno)</h2>";
?>
<p><a class="button" href="index.php?vw=proced&amp;scr=requestsurgcase&amp;zid=<?php echo $zid; ?>">Request Proced for this patient</a></p>
<h3>Pending</h3>
<?php
$where="WHERE pzid=$zid AND status='Req'";
	include( 'pat/zidlist_incl.php' );
?>
<h3>Scheduled</h3>
<?php
$where="WHERE pzid=$zid AND status='Sched'";
	include( 'pat/zidlist_incl.php' );
?>
<h3>Archived</h3>
<?php
$where="WHERE pzid=$zid AND status='Arch'";
	include( 'pat/zidlist_incl.php' );
?>
<h3>Cancelled</h3>
<?php
$where="WHERE pzid=$zid AND status='Canc'";
	include( 'pat/zidlist_incl.php' );
?>
