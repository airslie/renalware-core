<small><b>Note:</b> Prefs may also be edited in the main HD Profile screen. Site is changed in Modalities.</small><br><br>
<?php
//run an update
if ( $_GET['update']=='prefs' )
{
	$patzid=$zid;
	$prefnotes=$mysqli->real_escape_string($_POST["prefnotes"]);
	$prefdate=$mysqli->real_escape_string($_POST["prefdate"]);
	$prefdate= fixDate($prefdate);
	$prefsite=$_POST['prefsite'];
	$prefsched=$_POST['prefsched'];
	$prefslot=$_POST['prefslot'];
	$sched_slot=$prefsched . '-' . $prefslot;
	$sql="UPDATE hdpatdata SET prefsite='$prefsite', prefsched='$prefsched', prefslot='$prefslot', prefdate='$prefdate', prefnotes='$prefnotes', hdmodifstamp=NOW() WHERE hdpatzid=$patzid";
$result = $mysqli->query($sql);
		# //log the event
	$eventtype="HD PREFERRED SCHED/SLOT updated: $sched_slot for patient No $patzid";
	$eventtext=$sched_slot;
	include "$rwarepath/run/logevent.php";
	//end logging
	//refresh data
	include "$rwarepath/data/hddata.php";
	//msg
	showAlert("<b>The preferences have been updated to ' . $prefsite . '-' . $sched_slot . '!");
}
?>
<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=hdnav&amp;hdmode=prefshols&amp;update=prefs" method="post">
    <fieldset>
        <legend>Add/Update HD Preferences</legend>
		<ul class="form">
<li><label for="currdata">Curr Site/Sched</label>&nbsp;<?php echo "$currsite--$currschedslot"; ?></li>        
<li><label for="prefsite">Pref Site</label>&nbsp;<select name="prefsite">
	<?php
	if ($prefsite) { echo '<option value="' . $prefsite . '">' . $prefsite . '</option>'; }
	else { echo '<option value="">Site...</option>'; }
	echo $prefsiteoptions;
	?>
</select></li>
<li><label for="prefsched">Pref Sched</label>&nbsp;<select name="prefsched">
	<?php
	if ($prefsched)
		{
		echo '<option value="' . $prefsched . '">' . $prefsched . '</option>';
		}
	else
	{
		echo '<option value="">Sched...</option>';
	}
	?>
	<option>MonWedFri</option>
	<option>TueThuSat</option>
</select></li>
<li><label for="prefsched">Pref Sched</label>&nbsp;<select name="prefslot">
	<?php
	if ($prefslot)
		{
		echo '<option value="' . $prefslot . '">' . $prefslot . '</option>';
		}
	else
	{
		echo '<option value="">Slot...</option>';
	}
	?>
	<option value="AM">AM</option>
	<option value="PM">PM</option>
	<option value="Eve">Eve</option>
	</select></li>
<li><label for="prefdate">Date entered</label>&nbsp;<input type="text" name="prefdate" value="<?php echo $prefdate; ?>" size="12" /></li>
<li><label for="prefnotes">Notes</label>&nbsp;<input type="text" name="prefnotes" value="<?php echo $prefnotes; ?>" size="70" id="prefnotes" /></li>
<li class="submit"><input type="submit" style="color: green;" value="Update HD Prefs" /></li>
</ul>
</fieldset>
</form>
<br><br>
<?php
//run an add
if ( $_GET['add']=='hol' )
{
	$holzid=$zid;
	$startdate = $mysqli->real_escape_string($_POST["startdate"]);
	$enddate = $mysqli->real_escape_string($_POST["enddate"]);
	$startdate=fixDate($startdate);
	$enddate=fixDate($enddate);
	$holnotes = $mysqli->real_escape_string($_POST["holnotes"]);
	$insertfields="holzid, addstamp, startdate, enddate, holnotes, adduid, adduser";
	$values="'$holzid', NOW(), '$startdate', '$enddate', '$holnotes', '$uid', '$user'";
	$sql= "INSERT INTO hdholsdata ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//	echo "<hr>$sql<hr>";
		# //log the event
	$eventtype="HD HOLIDAY ADDED: starting $startdate ending $enddate for patient No $patzid";
	$eventtext=$sched_slot;
	include "$rwarepath/run/logevent.php";
	showAlert("<b>The holiday has been added!");
}
	include('../data/hdholsdata.php');
?>
<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=hdnav&amp;hdmode=prefshols&amp;add=hol" method="post">
<fieldset>
    <legend>Add an HD Holiday</legend>
	<ul class="form">
<li><label for="startdate">Start Date</label>&nbsp;<input type="text/submit/hidden/button" name="startdate" size="12" id="startdate" /></li>
<li><label for="enddate">End Date</label>&nbsp;<input type="text/submit/hidden/button" name="enddate" size="12" id="enddate" /></li>
<li><label for="holnotes">Notes</label>&nbsp;<input type="text" name="holnotes" size="70" id="holnotes" /></li>
<li class="submit"><input type="submit" style="color: green;" value="Add Holiday" /></li>
</ul>
</fieldset>
</form>
<br>
<h2>Holidays History</h2>
<?php
$where = "WHERE holzid='$zid'";
$orderby = "ORDER BY startdate DESC"; //default
$displaytime = date("D j M Y  G:i:s");
$fields = "h.addstamp, DATE_FORMAT(startdate, '%a %d/%m/%y') AS startdate_dmy, DATE_FORMAT(enddate, '%a %d/%m/%y') AS enddate_dmy, holnotes, IF(startdate<=NOW() AND enddate >= NOW(), 1, 0) as currflag";
$tables = "hdholsdata h";
$sql= "SELECT $fields FROM $tables $where $orderby";
//echo "<hr>$sql<hr>";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"header\">There are no holidays recorded!</p>";
	} else
	{
	echo "<p class=\"header\">$numrows holidays recorded</p>";
	echo '<table class="list">
	<tr>
    <th>Hol Starts</th>
    <th>Hol Ends</th>
    <th>notes</th>
    <th>hol added</th>
    </tr>';
	
	while ($row = $result->fetch_assoc()) {
		//for pref colouring
		//defaults
        $trclass = ($row["currflag"]==1) ? "hilite" : "" ;
		echo '<tr class="'.$trclass.'">
		<td class="start">' . $row["startdate_dmy"] . '</td>
		<td class="term">' . $row["enddate_dmy"] . '</td>
		<td>' . $row["holnotes"] . '</td>
		<td><i>' . $row["addstamp"] . '</i></td>
		</tr>';
		}
	echo '</table>';
	}
?>