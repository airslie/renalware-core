<?php
$medflag=FALSE;
echo '<div class="lettertext">
<p id="ref">' . $patref . '<br>
	' . $pataddr . '</p>';
switch($lettertype)
	{
	case "clinic":
	$medflag=TRUE;
	$medsheader="Current Medications";
	include 'clinicalinfodiv_incl.php';
	break;
	case "discharge":
	echo "<b>Admitted:</b> $admdate to $admward under Dr $admconsultant.<br>
	<b>Discharged:</b> $dischdate to $dischdest.<br>";
	if ( $reason )
	{
	echo "<b>Reason for Admission:</b> $reason<br>";
	}
	$medflag=TRUE;
	$medsheader="Medications on Discharge";
	include 'clinicalinfodiv_incl.php';
	break;
	case "death":
	echo "<b>Admitted:</b> $admdate to $admward under Dr $admconsultant.<br>
	<b>Died:</b> $dischdate<br>
	<b>Reason for Admission:</b><br>
	$reason<br>
	<b>Cause of Death:</b><br>
	$deathcause<br>";
	$medflag=FALSE;
	include 'clinicalinfodiv_incl.php';
	break;
	}
	//for pagebreaks Tue Aug 12 10:30:12 BST 2008
	$ltextfix=str_replace("*pagebreak*",'<div style="page-break-after: always;"></div>',$ltext);
	echo '<div id="lettertextdiv">';
	echo nl2br($ltextfix) . '<br><br>Yours sincerely';
	echo '<div id="signaturediv">';
	if ($elecsig and $showsig )
	{
	echo nl2br($elecsig);
	}
	echo '</div>';
	echo "<b>$authorsig</b> <br>
	$position </div>
	<div id=\"ccdiv\">cc:<br>" . 
	nl2br($cctext) . "<br><br>";
	if ($status!="ARCHIVED") {
		//display eCCs list here; when ARCHIVED they are added to cctext permanently
		$sql = "SELECT lettercc_id, recip_uid, authorsig, position FROM letterccdata JOIN userdata ON recip_uid=uid WHERE ccletter_id=$letter_id ORDER BY userlast, userfirst";
		$result = $mysqli->query($sql);
		$numrows=$result->num_rows;
		if ($numrows) {
		while($row = $result->fetch_assoc())
			{
			echo $row["authorsig"].', '.$row["position"].' [electr CC]<br>';
			}
		}
	}
	echo "<br>$typistinits: $letter_id
	</div>
</div>";
