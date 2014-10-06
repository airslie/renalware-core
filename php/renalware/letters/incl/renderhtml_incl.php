<?php
//updated Thu Sep  3 17:10:40 CEST 2009 ----Wed 23 Mar 2011----
$title = 'Renal Letter: ' . $lettdescr . '/' . $letterdate . '/' . $patlastfirst . ' (' . $letthospno . ', ' . $modalstamp . ')';
$html='<!DOCTYPE html>
<html lang="en">
<head>
	<title>'.$pagetitle.'</title>
	<meta charset="utf-8" />
<style type="text/css" media="screen, print">';
$html .= file_get_contents("$rwarepath/css/lettercss.css");
$html.='</style>
	</head>
	<body>';
//----Wed 23 Mar 2011----new letterhead CSS logo
$sql = "SELECT * FROM letterheadlist WHERE sitecode='$lettersite' LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$unitinfo=$row["unitinfo"];
$trustname=$row["trustname"];
$trustcaption=$row["trustcaption"];
$siteinfohtml=$row["siteinfohtml"];
$html.= '<div id="letterhead">
	<div id="topleft">
	<p id="renalunit">'.$unitinfo.'</p>
	<p id="header">';
	$html.= "Letter date: $letterdate<br>";
		$html.= '<b>' . strtoupper($lettdescr) . '</b>';
		if ($clinicdate_ddmy)
		{
		$html.= "<br>(Clinic date: $clinicdate_ddmy)";
		}
		$html.= '<br><br><br>PRIVATE AND CONFIDENTIAL<br><br>' . 
		nl2br($recipient) . '<br><br><br><br>';
		$html.= $salut . '</p>
	</div>
	<div id="topright">
		<span id="trustname">'.$trustname.'</span> <span id="nhslogo">NHS</span><br>
		<span id="trustcaption">'.$trustcaption.'</span><br>
		<div class="siteinfohtml">'.$siteinfohtml.'</div>
	</div>
</div>
	<div class="lettertext">'; //start
$html.= '<p id="ref">' . $patref . '<br>
	' . $pataddr . '</p>';
switch($lettertype)
	{
	case "clinic":
	$medflag=TRUE;
	$medsheader="Current Medications";
	include 'clinicalinfodiv_html.php';
	break;
	case "discharge":
	$html.= "<b>Admitted:</b> $admdate to $admward under Dr $admconsultant.<br>
	<b>Discharged:</b> $dischdate to $dischdest.<br>";
	if ( $reason )
	{
	$html.= "<b>Reason for Admission:</b> $reason<br>";
	}
	$medflag=TRUE;
	$medsheader="Medications on Discharge";
	include 'clinicalinfodiv_html.php';
	break;
	case "death":
		$html.= "<b>Admitted:</b> $admdate to $admward under Dr $admconsultant.<br>
	<b>Died:</b> $dischdate<br>
	<b>Reason for Admission:</b><br>
	$reason<br>
	<b>Cause of Death:</b><br>
	$deathcause<br>";
	$medflag=FALSE;
	include 'clinicalinfodiv_html.php';
	break;
	}
	$htmltext=htmlentities($ltext);
	$html.=nl2br($htmltext) . '<br><br>Yours sincerely<br><br>';
	if ( $elecsig )
	{
	$html.='<br>' . nl2br($elecsig) . '<br><br>';
	}
	else
	{
	$html.='<br><br><br><br>';
	}
	$html.="<b>$authorsig</b> <br>
	$position <br><br><br>cc:<br>" . 
	nl2br($cctext) . "<br><small>$typistinits</small>";
$html.='</div>
</body>
</html>';
