<table class="searchbar">
<tr><td>
	<form action="renal/hdlists.php" method="get">Find by <b>Site</b>: 
	<input type="hidden" name="list" value="patprefslist" id="list" />
	<select name="site">
	<option value="">Select HD Site...</option>
	<?php
	$popcode="sitecode";
	$popname="sitename";
	$poporder="ORDER BY sitename";
	$poptable="sitelist";
include('../incl/simpleoptions.php');
	?>
	</select>&nbsp;&nbsp;
	<select name="schedslot">
	<option value="">Select Schedule...</option>
<option>MonWedFri-AM</option>
<option>MonWedFri-PM</option>
<option>MonWedFri-Eve</option>
<option>TueThuSat-AM</option>
<option>TueThuSat-PM</option>
<option>TueThuSat-Eve</option>
</select> &nbsp; &nbsp;
<!--
	&nbsp;&nbsp;<b>Patient surname</b>: 
<input type="text" name="patname" size="15" />
-->
<input type="submit" style="color: green;" value="search!" /></form>
</td>
<td>
<form action="renal/hdlists.php" method="get">
<input type="hidden" name="list" value="patprefslist" id="list" />
	<input type="hidden" name="show" value="unmatched" id="list" />
	<input type="submit" style="color: green;" value="Show 'UNHAPPY'" />
</form>
</td>
<td>
	<form action="renal/hdlists.php" method="get">Find <b>Preferred Site</b>: 
	<input type="hidden" name="list" value="patprefslist" id="list" />
	<select name="prefsite">
	<option value="">Select...</option>
	<?php
	include 'siteoptions_incl.php';
	echo $prefsiteoptions;
	?>
</select><input type="submit" style="color: green;" value="Find..." /></form>
</td>
</tr></table>
<?php
//create easy sitelist
$sql="SELECT sitecode FROM sitelist";
$result = $mysqli->query($sql);
$siteoptions=""; //start
while($row = $result->fetch_row()) {
 $siteoptions .= '<option>' . $row['0'] . "</option>\n";
}

//run an update
if ( $_GET['mode']=='update' )
{
	$patzid=$_GET['updzid'];
	$sched_slot=$_GET['sched_slot'];
	$schedslot = explode("-",$_GET["sched_slot"]);
	$newsched = $schedslot[0];
	$newslot = $schedslot[1];
	$sql="UPDATE hdpatdata SET currsched='$newsched', currslot='$newslot' WHERE hdpatzid=$patzid";
$result = $mysqli->query($sql);
		# //log the event
	$eventtype="HD SCHED/SLOT change: $newsched-$newslot for patient No $patzid";
	$eventtext=$sched_slot;
	include "$rwarepath/run/logevent.php";
	//end logging
	//msg
	showAlert("<b>The schedule/slot has been updated to ' .  $sched_slot . '!");
}
//get total
$display = 500; //default
$displaytext = "$siteshort HD patients"; //default
$where = "";  // default
if($_GET["site"])
	{
	$display = 500;
	$site = $_GET["site"];
	$where = "WHERE v.currsite='$site'";
	$displaytext = "HD patients at <b>$site</b>";
	}
if($_GET["zid"])
	{
	$display = 100;
	$zid = $_GET["zid"];
	$displaytext = "HD patient found";
	$where = "WHERE patzid='$zid'";
	}
if($_GET["patname"])
	{
	$display = 100;
	$patname = $_GET["patname"];
	$displaytext = "HD patient found like '$patname'";
	$where = "WHERE LOWER(lastname) LIKE LOWER('$patname%')";
	}
if($_GET["site_sched"])
	{
	$sitesched = explode("-",$_GET["site_sched"]);
	$site = $sitesched[0];
	$sched = $sitesched[1];
	$displaytext = "HD patients found at $site with schedule $sched";
	$where = "WHERE v.currsite='$site' AND v.currsched='$sched'";
	}
if($_GET["schedslot"])
	{
	$schedslot = $_GET["schedslot"];
	$displaytext = "HD patients found with schedule $schedslot";
	$where = "WHERE v.sched_slot='$schedslot'";
	}
if($_GET["schedslot"] && $_GET["site"])
	{
	$schedslot = $_GET["schedslot"];
	$site = $_GET["site"];
	$displaytext = "HD patients found with schedule $schedslot at site $site";
	$where = "WHERE v.sched_slot='$schedslot' AND v.currsite='$site'";
	}
if($_GET["show"]=='unmatched')
	{
	$displaytext = "HD patients found whose current site is not their preferred site";
	$where = "WHERE v.currsite!=v.prefsite";
	}
if($_GET["prefsite"])
	{
	$prefsite=$_GET["prefsite"];
	$displaytext = "HD patients who would prefer to be at $prefsite";
	$where = "WHERE v.currsite!=v.prefsite AND v.prefsite='$prefsite'";
	}

//$orderby = "ORDER BY lastname, firstnames"; //default
$orderby = "ORDER BY prefdate"; //default
$displaytime = date("D j M Y  G:i:s");
$fields = "patzid, hospno1, lastname, firstnames, sex, age, modalcode, v.currsite, v.currsched, v.currslot, v.prefsite, v.prefsched, v.prefslot, prefdate, prefnotes";
$tables = "viewsitescheds v LEFT JOIN patientdata p ON patzid=sitezid LEFT JOIN hdpatdata hd ON patzid=hdpatzid";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext ($numrows displayed). <a href=\"renal/hdlists.php?list=patprefslist\">Show all</a></p>";
	echo "<i>Note: green backgrounds=current site/sched/slot is the preferred. Orange background indicates patient prefers a different one.</i><br>
	<table class=\"list\">
	<tr>
	<th>$hosp1label</th>
	<th>patient</th>
	<th>sex <i>(age)</i></th>
    <th>Modality</th>
    <th>HD profile</th>
    <th>Curr site</th>
    <th>Curr sched-slot</th>
    <th>Pref site-</th>
    <th>sched-</th>
    <th>slot</th>
    <th>Update curr sched/slot</th>
    <th>Pref date</th>
    <th>Pref notes</th>
    </tr>";
	
	while ($row = $result->fetch_assoc()) {
		$zid = $row["patzid"];
		$showage = ($row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>');
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$modalslink = '<a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '">' . $row["modalcode"] . '</a>';
		$sitelink = $row["currsite"] . ' <a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '"><i>change</i></a>';
		$profilelink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=hdnav">prof/sess</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		//for pref colouring
		//defaults
		$prefsite=$row["prefsite"];
		$prefsched=$row["prefsched"];
		$prefslot=$row["prefslot"];
		$happy="#99ff00";
		if ( $row["prefsite"] )
		{
			if ( $row["currsite"]==$row["prefsite"])
			{
				$sitebg=$happy;
			}
			else
			{
				$sitebg="#ff9900";
			}
		}
		if ( $row["prefsched"] )
		{
			if ( $row["currsched"]==$row["prefsched"])
			{
				$schedbg=$happy;
			}
			else
			{
				$schedbg="#ff9900";
			}
		}
		if ( $row["prefslot"] )
		{
			if ( $row["currslot"]==$row["prefslot"])
			{
				$slotbg=$happy;
			}
			else
			{
				$slotbg="#ff9900";
			}
		}
		//stuff for update cell
		/*
			$updatesched = '<form action="renal/hdlists.php" method="get">
			<input type="hidden" name="list" value="patprefslist" />
			<input type="hidden" name="mode" value="update" />
			<input type="hidden" name="updzid" value="' . $row["patzid"] .'" />
			<select name="sched_slot">
			<option value="">Change sched/slot...</option>' .
			"<option value=\"$prefsched-$prefslot\">$prefsched-$prefslot PREF</option>
			<option>MonWedFri-AM</option>
			<option>MonWedFri-PM</option>
			<option>MonWedFri-Eve</option>
			<option>TueThuSat-AM</option>
			<option>TueThuSat-PM</option>
			<option>TueThuSat-Eve</option>" . 
			'<input type="submit" style="color: green;" value="upd!" /></form>';
			*/
		$updatesched2 = '<select name="sched_slot">
		<option value="">Change sched</option>' .
		"<option value=\"$prefsched-$prefslot\">$prefsched-$prefslot PREF</option>
		<option>MonWedFri-AM</option>
		<option>MonWedFri-PM</option>
		<option>MonWedFri-Eve</option>
		<option>TueThuSat-AM</option>
		<option>TueThuSat-PM</option>
		<option>TueThuSat-Eve</option>
		</select>".'<input type="submit" style="color: green;" value="upd!" />';
			//start form here
		echo '<form action="renal/hdlists.php" method="get">
		<input type="hidden" name="list" value="patprefslist" />
		<input type="hidden" name="mode" value="update" />
		<input type="hidden" name="updzid" value="' . $row["patzid"] .'" />';
		echo "<tr>
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["sex"] . "&nbsp;&nbsp;" . "$showage</td>
		<td>$modalslink</td>
		<td>$profilelink</td>
		<td>$sitelink</td>
		<td>" . $row["currsched"] . '-' . $row["currslot"] . "</td>
		<td bgcolor=\"$sitebg\"><b>" . $row["prefsite"] . "</b></td>
		<td bgcolor=\"$schedbg\">" . $row["prefsched"] . "</td>
		<td bgcolor=\"$slotbg\">" . $row["prefslot"] . "</td>
		<td>" . $updatesched2 . "</td>
		<td>" . dmy($row["prefdate"]) . "</td>
		<td>" . $row["prefnotes"] . "</td>
		</tr></form>";
		}
	echo '</table>';
	}