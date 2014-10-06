<button onclick="$('#holssearchdiv').toggle()">Toggle Search Options</button>
<div id="holssearchdiv" style="display: none;">
	<form action="renal/hdlists.php" method="get">Find by <b>Site</b>: 
<fieldset><input type="hidden" name="list" value="holslist" id="list" />
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
	&nbsp;&nbsp;<b>Patient surname</b>: 
<input type="text" name="patname" size="15" /><input type="submit" style="color: green;" value="search!" /></fieldset>
</form>
	<form action="renal/hdlists.php" method="get">
<fieldset><b>Period starting</b>: 
	<input type="hidden" name="list" value="holslist" id="list" />
<input type="text" name="starting" size="12" />
	and <b>ending</b>: 
	<input type="text" name="ending" size="12" />
<input type="submit" style="color: green;" value="search!" /></fieldset></form></div>
<?php
//get total
$display = 500; //default
$displaytext = "$siteshort HD patients"; //default
$where = "";  // default
if($_GET["site"])
	{
	$display = 500;
	$site = $_GET["site"];
	$where = "WHERE v.currsite='$site'";
	$displaytext = "HD holidays at <b>$site</b>";
	}
if($_GET["zid"])
	{
	$display = 100;
	$zid = $_GET["zid"];
	$displaytext = "HD holiday(s) found";
	$where = "WHERE patzid='$zid'";
	}
if($_GET["patname"])
	{
	$display = 100;
	$patname = $_GET["patname"];
	$displaytext = "HD holidays for patient like '$patname'";
	$where = "WHERE LOWER(lastname) LIKE LOWER('$patname%')";
	}
if($_GET["site_sched"])
	{
	$sitesched = explode("-",$_GET["site_sched"]);
	$site = $sitesched[0];
	$sched = $sitesched[1];
	$displaytext = "HD holidays found for $site patients with schedule $sched";
	$where = "WHERE v.currsite='$site' AND v.currsched='$sched'";
	}
if($_GET["schedslot"])
	{
	$schedslot = $_GET["schedslot"];
	$displaytext = "HD holidays found for patients with schedule $schedslot";
	$where = "WHERE v.sched_slot='$schedslot'";
	}
if($_GET["schedslot"] && $_GET["site"])
	{
	$schedslot = $_GET["schedslot"];
	$site = $_GET["site"];
	$displaytext = "HD holidays found for patients with schedule $schedslot at site $site";
	$where = "WHERE v.sched_slot='$schedslot' AND v.currsite='$site'";
	}
if($_GET["starting"] && $_GET["ending"])
	{
	$startdmy = $_GET["starting"];
	$startymd=fixDate($startdmy);
	$enddmy = $_GET["ending"];
	$endymd=fixDate($enddmy);
	$site = $_GET["site"];
	$displaytext = "HD holidays found in the period $startymd to $endymd";
	$where = "WHERE startdate<='$endymd' AND enddate >= '$startymd'";
	}
if($_GET["show"]=='current')
	{
	$displaytext = "Current HD holidays found";
	$where = "WHERE startdate<=NOW() AND enddate >= NOW()";
	}
$orderby = "ORDER BY startdate DESC"; //default
$displaytime = date("D j M Y  G:i:s");
//$fields = "patzid, hospno1, lastname, firstnames, sex, age, modalcode, currsite, currsched, currslot, h.addstamp, DATE_FORMAT(startdate, '%a %d/%m/%y') AS startdate_dmy, DATE_FORMAT(enddate, '%a %d/%m/%y') AS enddate_dmy, holnotes, IF(startdate<=NOW() AND enddate >= NOW(), 1, 0) as currflag";
$fields = "patzid, hospno1, lastname, firstnames, sex, age, modalcode, currsite, currsched, currslot, h.addstamp, startdate,enddate, holnotes, IF(startdate<=NOW() AND enddate >= NOW(), 1, 0) as currflag";
$tables = "hdholsdata h LEFT JOIN patientdata p ON holzid=patzid LEFT JOIN hdpatdata hd ON holzid=hdpatzid";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
//echo "<hr>$sql<hr>";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext! <a href=\"renal/hdlists.php?list=holslist\">Show all</a>&nbsp;&nbsp;<a href=\"renal/hdlists.php?list=holslist&amp;show=current\">Show current only.</a></p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext ($numrows displayed). YELLOW are current. <a href=\"renal/hdlists.php?list=holslist\">Show all</a>&nbsp;&nbsp;<a href=\"renal/hdlists.php?list=holslist&amp;show=current\">Show current only.</a></p>";
	echo "<table class=\"list\">
	<tr>
	<th>$hosp1label</th>
	<th>patient</th>
	<th>sex</th>
	<th>age</th>
    <th>Modality</th>
    <th>HD profile</th>
    <th>Curr site</th>
    <th>Curr sched-slot</th>
    <th>Starts</th>
    <th>Ends</th>
    <th>notes</th>
    </tr>";
	while ($row = $result->fetch_assoc()) {
		$zid = $row["patzid"];
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$modalslink = '<a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '">' . $row["modalcode"] . '</a>';
		$sitelink = $row["currsite"] . ' <a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '"><i>change</i></a>';
		$profilelink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=hdnav">profile</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		//for pref colouring
		//defaults
		$holnotes=$row["holnotes"];
		$currflag=$row["currflag"];
		$trclass = ($currflag==1) ? "hilite" : "" ;
		echo "<tr class=\"$trclass\">
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["sex"] . "</td>
		<td>" . $row["age"]."</td>
		<td>$modalslink</td>
		<td>$profilelink</td>
		<td>$sitelink</td>
		<td>" . $row["currsched"] . '-' . $row["currslot"] . "</td>
		<td class=\"start\">" . dmy($row["startdate"]) . "</td>
		<td class=\"term\">" . dmy($row["enddate"]) . '</td>
		<td style="width: 30%">' . $row["holnotes"] . "</td>
		</tr>";
		}
	echo '</table>';
	}
?>