<?php
//if form submitted
if ($get_add=="peritonitisdata" )
	{
	include( 'peritonitisdata_add.php' );
	}
?>
<h3>Peritonitis Episodes</h3>
<!-- toggle form here -->
<div id="peritonitisdataform" style="display:none;padding-top:0px;font-size: 10px;">
<?php include( 'peritonitisdataform.html'); ?></div>
<!-- end toggle form -->
<?php
$descr = "peritonitis episodes"; //for display with $num
$fields = "peritonitisdata_id, rxstartdate, rxenddate, organism1, organism2, WCcount, IPantibioticflag, IVantibioticflag, peritnotes, addstamp, modifstamp";
$table = "peritonitisdata";
$sql = "SELECT $fields FROM $table WHERE peritzid=$zid ORDER BY peritonitisdata_id DESC";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">$numrows $descr recorded. &nbsp; <a class=\"tg\" onclick=\"toggl('peritonitisdataform');\">add new episode</a></p>";
if ($numrows) {
	echo '
		<table class="list">
		<tr>
		<th>Rx start date</th>
		<th>Rx end date</th>
		<th>organism 1</th>
		<th>organism 2</th>
		<th>WC count</th>
		<th>IP ABs?</th>
		<th>IV ABs?</th>
		<th>notes</th>
		<th>last updated</th>
		<th>update?</th>
		</tr>
	';
	while($row = $result->fetch_assoc())
		{
		$peritonitisdata_id=$row["peritonitisdata_id"];
		echo '<tr>
		<td>' . dmyyyy($row["rxstartdate"]) . '</td>
		<td>' . dmyyyy($row["rxenddate"]) . '</td>
		<td>' . $row["organism1"] . '</td>
		<td>' . $row["organism2"] . '</td>
		<td>' . $row["WCcount"] . '</td>
		<td>' . $row["IPantibioticflag"] . '</td>
		<td>' . $row["IVantibioticflag"] . '</td>
		<td>' . $row["peritnotes"] . '</td>
		<td>' . $row["modifstamp"] . '</td>
		<td><a href="renal/forms/peritonitisdata_updateform.php?zid='.$zid.'&amp;data_id='.$peritonitisdata_id.'">update</a></td>
		</tr>';
		}
	echo "</table>";
}
?>