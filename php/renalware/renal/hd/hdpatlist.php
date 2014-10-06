<p><i>NOTE: Named Nurse search is "fuzzy". For best results enter a portion of the name e.g. "laura"</i></p>
<form action="renal/hdlists.php" method="get">
<fieldset><input type="hidden" name="list" value="hdpatlist" id="list" />
<select name="hdmodalcode">
<option value="">Select HD Modality...</option>
<?php
$popcode="modalcode";
$popname="modality";
$popwhere="modalcode LIKE 'HD%'";
$poptable="modalcodeslist";
include('../incl/limitedoptions.php');
?>
</select>
&nbsp;&nbsp;<b>Site</b>: 
<select name="site">
<option value="">Select HD Site...</option>
<?php
include 'siteoptions_incl.php';
echo $siteoptions;
?>
</select>
&nbsp;&nbsp;<b>Named Nurse</b>: 
<input type="text" name="namednurse" size="15" />
&nbsp;&nbsp;<b>Patient surname</b>: 
<input type="text" name="patname" size="15" /><input type="submit" style="color: green;" value="search!" />
</fieldset></form>
<?php
//get total
$display = 500; //default
$displaytext = "$siteshort HD patients"; //default
$where = "WHERE modalcode LIKE 'HD%'";  // default
if($_GET["site"])
	{
	$display = 500;
	$site = $_GET["site"];
	$where = "WHERE modalcode LIKE 'HD%' AND currsite='$site'";
	$displaytext = "HD patients at <b>$site</b>";
	}
if ( !$_GET['site'] )
{
	$site=$HDsite1; //show main list
}
if($_GET["hdmodalcode"])
	{
	$display = 500; //want to show all
	$hdmodalcode=$_GET["hdmodalcode"];
	$where = "WHERE modalcode = '$hdmodalcode'";
	$displaytext = "<b>$hdmodalcode</b> patients";
	}
if($_GET["zid"])
	{
	$display = 100;
	$zid = $_GET["zid"];
	$displaytext = "HD patient found";
	$where = "WHERE patzid='$zid' AND modalcode LIKE 'HD%'";
	}
if($_GET["patname"])
	{
	$display = 100;
	$patname = $_GET["patname"];
	$displaytext = "HD patient found like '$patname'";
	$where = "WHERE LOWER(lastname) LIKE LOWER('$patname%') AND modalcode LIKE 'HD%'";
	}
if($_GET["namednurse"])
	{
	$display = 100;
	$namednurse = $_GET["namednurse"];
	$displaytext = "HD patients found with named nurse '$namednurse'";
	$where = "WHERE LOWER(namednurse) LIKE LOWER('%$namednurse%') AND modalcode LIKE 'HD%'";
	}
if($_GET["site_sched"])
	{
	$sitesched = explode("-",$_GET["site_sched"]);
	$site = $sitesched[0];
	$sched = $sitesched[1];
	$displaytext = "HD patients found at $site with schedule $sched";
	$where = "WHERE modalcode LIKE 'HD%' AND currsite='$site' AND currsched='$sched'";
	}
if($_GET["sss"])
	{
	$siteschedslot = explode("-",$_GET["sss"]);
	$site = $siteschedslot[0];
	$sched = $siteschedslot[1];
	$slot = $siteschedslot[2];
	$displaytext = "HD patients found at $site with schedule $sched";
	$where = "WHERE modalcode LIKE 'HD%' AND currsite='$site' AND currsched='$sched' AND currslot='$slot'";
	}
$orderby = "ORDER BY lastname, firstnames"; //default
$displaytime = date("D j M Y  G:i:s");
//----Fri 29 Oct 2010---- added transportflag
$fields = "patzid, hospno1, lastname, firstnames, sex,age, modalcode, hdsess, accessCurrent, currsite, currsched, currslot, namednurse,transportflag,DATE(hdmodifstamp) as hdmodifdate";
$tables = "renalware.patientdata JOIN renaldata ON patzid=renalzid JOIN hdpatdata ON patzid=hdpatzid JOIN patstats on patzid=statzid";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows) {
	echo "<p class=\"header\">$numrows $displaytext ($numrows displayed). <a href=\"renal/hdlists.php?list=hdpatlist\">Show all</a> Click on headers to sort.</p>";
	echo '<table class="tablesorter">
    <thead><tr>
    <th>options</th>
	<th>Hosp No</th>
	<th>patient</th>
	<th>sex age</th>
    <th>HD Site Schedule</th>
    <th>HD Info/Sess</th>
    <th>HD Screen</th>
    <th>Access</th>
    <th>Named Nurse</th>
    <th>Transport</th>
    <th>Profile Upd</th>
    </tr></thead>
    <tbody>';
	while ($row = $result->fetch_assoc()) {
		$zid = $row["patzid"];
		$printprofile = '<a class="gr" href="renal/hd/printhdprofiles.php?zid=' . $zid . '" target="new">print profile</a>';
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$modalslink = '<a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '">' . $row["modalcode"] . '</a> -- <b>' . $row["currsite"];
		$accesslink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=access">' . $row["accessCurrent"] . '</a>';
		$profilelink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=hdnav">' . $row["hdsess"] . ' sess</a>';
		$hdscreenlink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=hdnav&amp;hdmode=hdscreen">HD screen</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		echo "<tr>
    	<td>$printprofile</td>
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["sex"] . ' ' . $row["age"] . "</td>
		<td><b>" . $row["currsite"] . '</b> ' . $row["currsched"] . '-' . $row["currslot"] . "</td>
		<td>$profilelink</td>
		<td>$hdscreenlink</td>
		<td>$accesslink</td>
		<td>" . $row["namednurse"] . "</td>
		<td>" . $row["transportflag"] . "</td>
		<td>" . dmy($row["hdmodifdate"]) . "</td>
		</tr>";
		}
	echo '</tbody></table>';
} else {
	echo "<p class=\"headergray\">There are no $displaytext</p>";
}
