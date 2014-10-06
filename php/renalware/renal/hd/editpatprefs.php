<form action="renal/hdlists.php" method="get">Find by <b>Site</b>: 
<fieldset><input type="hidden" name="list" value="patprefslist" id="list" />
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
<option>TueThuSat-Eve</option>" . 
</select> &nbsp; &nbsp;&nbsp;&nbsp;<b>Patient surname</b>: 
<input type="text" name="patname" size="15" />
<input type="submit" style="color: green;" value="search!" />
</fieldset></form>
<?php
include 'siteoptions_incl.php';
//run an update
if ( $_GET['mode']=='update' )
{
	$patzid=$_GET['updzid'];
	$prefnotes=$_GET['prefnotes'];
	$newprefdate=$_GET['prefdate'];
	$newprefdate= fixDate($prefdate);
	$newprefsite=$_GET['prefsite'];
	$newprefsched=$_GET['prefsched'];
	$newprefslot=$_GET['prefslot'];
	$sql="UPDATE hdpatdata SET prefsite='$newprefsite', prefsched='$newprefsched', prefslot='$newprefslot', prefdate='$newprefdate', prefnotes='$prefnotes' WHERE hdpatzid=$patzid";
$result = $mysqli->query($sql);
		# //log the event
	$eventtype="HD PREFERRED SCHED/SLOT updated: $sched_slot for patient No $patzid";
	$eventtext=$sched_slot;
	include "$rwarepath/run/logevent.php";
	//end logging
	//msg
	showAlert("<b>The preferred site/schedule/slot has been updated to ' . $newprefsite . '-' . $sched_slot . '!");
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

$orderby = "ORDER BY lastname, firstnames"; //default
$displaytime = date("D j M Y  G:i:s");
$fields = "patzid, hospno1, lastname, firstnames, sex, age, modalcode, v.currsite, v.currsched, v.currslot, v.prefsite, v.prefsched, v.prefslot, IF(prefdate, DATE_FORMAT(prefdate, '%d/%m/%y'),'') AS prefdate_dmy, prefnotes";
$tables = "viewsitescheds v LEFT JOIN patientdata p ON patzid=sitezid LEFT JOIN hdpatdata hd ON patzid=hdpatzid";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext ($numrows displayed). <a href=\"renal/hdlists.php?list=editpatprefs\">Show all</a></p>";
	echo "<i>Note: green backgrounds=current site/sched/slot is the preferred. Orange background indicates patient prefers a different one.</i><br>
	<table class=\"list\">
	<tr>
	<th>$hosp1label</th>
	<th>patient</th>
	<th>sex <i>(age)</i></th>
    <th>Curr site-schedule-slot</th>
    <th>Pref site-</th>
    <th>sched-</th>
    <th>slot</th>
    <th>Update prefs</th>
    <th>Pref date</th>
    <th>update</th>
    </tr>";
	
	while ($row = $result->fetch_assoc()) {
		$zid = $row["patzid"];
		$showage = ($row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>');
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$profilelink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=hdnav"><b>' . $row["currsite"] . '</b> ' . $row["currsched"] . '-' . $row["currslot"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		//for pref colouring
		//defaults
		$prefsite=$row["prefsite"];
		$prefsched=$row["prefsched"];
		$prefslot=$row["prefslot"];
		$happy="#99ff00";
		$sitebg=$bg;
		$schedbg=$bg;
		$slotbg=$bg;
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
			$updateprefs = '<form action="renal/hdlists.php" method="get">
			<input type="hidden" name="list" value="editpatprefs" />
			<input type="hidden" name="mode" value="update" />
			<input type="hidden" name="updzid" value="' . $row["patzid"] .'" />
			<select name="prefsite">' . 
	 		'<option value="">Pref site</option>' . $prefsiteoptions . '</select>&nbsp;&nbsp;
			<select name="prefsched">
			<option value="">Pref sched...</option>
			<option>MonWedFri</option>
			<option>TueThuSat</option>
			</select>&nbsp;&nbsp;
			<select name="prefslot">
			<option value="">slot...</option>
			<option>AM</option>
			<option>PM</option>
			<option>Eve</option>
			</select>';
		echo "<tr>
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["sex"] . "&nbsp;&nbsp;" . "$showage</td>
		<td>$profilelink</td>
		<td bgcolor=\"$sitebg\"><b>" . $row["prefsite"] . "</b></td>
		<td bgcolor=\"$schedbg\">" . $row["prefsched"] . "</td>
		<td bgcolor=\"$slotbg\">" . $row["prefslot"] . "</td>
		<td>" . $updateprefs . "</td>
		<td><input type=\"text\" name=\"prefdate\" size=\"12\" value=\"$prefdate\"id=\"prefdate\" /></td>
		<td><input class=\"submit\"  type=\"submit\" value=\"upd!\" /></form></td>
		</tr>";
		}
	echo '</table>';
	}
?>