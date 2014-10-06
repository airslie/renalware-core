<?php
//----Fri 15 Nov 2013----move set $lettersite to data/letterdata.php
//----Fri 25 Oct 2013----PRUH
$sql = "SELECT * FROM letterheadlist WHERE sitecode='$lettersite' LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$unitinfo=$row["unitinfo"];
$trustname=$row["trustname"];
$trustcaption=$row["trustcaption"];
$siteinfohtml=$row["siteinfohtml"];
echo '<div id="letterhead">
	<div id="topleft">
	<p id="renalunit">'.$unitinfo.'</p>
	<p id="header">'.$letterdate.
	'<br><b>' . strtoupper($lettdescr) . '</b>';
		if ( $showstatus ) //hides status in PRINTLETTER
		{
		echo '&nbsp; &nbsp; <span class="letterstatus">' . $status . '</span>';
		}
		if ($clinicdate_ddmy)
		{
		echo "<br>(Clinic Date $clinicdate_ddmy)";
		}
		echo '<br><br><br>PRIVATE AND CONFIDENTIAL<br><br>' . 
		nl2br($recipient) . '<br><br><br><br>';
		echo $salut . '</p>
	</div>
	<div id="topright">
		<span id="trustname">'.$trustname.'</span> <span id="nhslogo">NHS</span><br>
		<span id="trustcaption">'.$trustcaption.'</span><br>
		<div class="siteinfohtml">'.$siteinfohtml.'</div>
	</div>
</div>';
