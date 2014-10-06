<?php
//--------Page Content Here----------
?>
<?php
$sql= "select sitename, currsite, count(hdpatzid) as patcount FROM hdpatdata LEFT JOIN sitelist ON currsite=sitecode JOIN patientdata on hdpatzid=patzid where modalcode LIKE 'HD%' group by currsite";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows $siteshort HD sites. <i>Click on site to view patients</i></p>";
?>
<table class="list">
<tr>
<th>HD site</th>
<th>View list</th>
<th>Print list</th>
<th>patient count</th>
</tr>
<?php
while ($row = $result->fetch_assoc())
	{
	$modalsite = $row["modalsite"];
	echo '<tr>
	<td><b>' . $row["sitename"] . '</b></td>
	<td><a href="renal/hdlists.php?list=hdpatlist&amp;site=' . $row["currsite"] . '">' . $row["modalsite"] . ' view list</td>
	<td><a href="renal/hd/hdsitepatlist_print.php?hdsite=' . $row["currsite"] . '" target="new">print list*</td>
	<td>' . $row["patcount"] . '</td>
	</tr>';
	}
?>
</table>
*Opens in new window.
<br><br>
<small>NB use the new <a href="renal/hdlists.php?list=sitescheds">HD Site Schedules</a> list to print HD Profiles and Screens.</small>