<?php
//----Mon 25 Feb 2013----catheter info
//Sat Oct 25 15:07:21 CEST 2008 v164
//if form submitted
$addtable='accessprocdata';
$addtablename='Access Procedures';
$addlabel='Add new procedure';
echo "<h3>$addtablename</h3>";
if ( $_POST['add']=="$addtable" )
	{
	include( $addtable . '_add.php' );
	}
$descr = "access procedure(s)";
//assume want most recent on top so DESC
$sql= "SELECT * FROM $addtable WHERE accessproczid=$zid ORDER BY proceduredate DESC";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows $descr recorded.</p>";
echo '<table class="list">
<tr>
<th>date</th>
<th>procedure</th>
<th>operator</th>
<th>firstflag</th>
<th>catheter make</th>
<th>catheter Lot No</th>
<th>outcome</th>
<th>first used</th>
<th>failure date</th>
<th>added</th>
</tr>';
while ($row = $result->fetch_assoc())
	{
	$accessprocdata_id=$row["accessprocdata_id"];
	echo '<form action="renal/renal.php?zid=' . $zid . '&amp;scr=access&amp;updateproced_id=' . $accessprocdata_id . '" method="post">';
	echo '<tr><td>' . dmy($row["proceduredate"]) . '</td>
	<td>' . $row["proced"] . '</td>
	<td>' . $row["operator"] . '</td>
	<td>' . $row["firstflag"] . '</td>
<td><input type="text" name="cathetermake" size="30" value="' . $row["cathetermake"] . '" /></td>
<td><input type="text" name="catheterlotno" size="15" value="' . $row["catheterlotno"] . '" /></td>
<td><input type="text" name="outcome" size="40" value="' . $row["outcome"] . '" /></td>
<td><input type="text" name="firstused_date" size="10" value="' . dmy($row["firstused_date"]) . '" /></td>
<td><input type="text" name="failuredate" size="10" value="' . dmy($row["failuredate"]) . '" /></td>
	<td>' . "<input class=\"submit\"  type=\"submit\" value=\"update\" /></td>
	</tr></form>\n";
	}
echo '</table>';
