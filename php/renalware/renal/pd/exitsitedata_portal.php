<?php
$addtable='exitsitedata';
$addtablename='Exit Site Infections';
$addlabel='Add new infection data';
echo "<h3>$addtablename</h3>";
if ($get_add=="$addtable")
	{
	include( $addtable . '_add.php' );
	}
?>
<!-- toggle form here -->
<div id="<?php echo $addtable; ?>form" style="display:none;padding-top:0px;font-size: 10px;">
<?php include( $addtable . 'form.html'); ?></div>
<!-- end toggle form -->
<?php 
$descr = "exit site infections";
$fields = "exitsitedata_id,
infectiondate,
organism1,
organism2,
treatment,
outcome,
exitsitenotes,
modifstamp";
$table = "exitsitedata";
//assume want most recent on top so DESC
$sql = "SELECT $fields FROM $table WHERE exitsitezid=$zid ORDER BY infectiondate DESC";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">$numrows $descr recorded. &nbsp; <a class=\"tg\" onclick=\"toggl('" . $addtable . "form');\">$addlabel</a></p>";
if ($numrows) {
	echo '
		<table class="list">
		<tr>
		<th>Infection date</th>
		<th>organism1</th>
		<th>organism2</th>
		<th>treatment</th>
		<th>outcome</th>
		<th>notes</th>
		<th>last updated</th>
		<th>update?</th>
		</tr>
	';
while($row = $result->fetch_assoc())
	{
	$exitsitedata_id=$row["exitsitedata_id"];
	echo '<tr>
	<td>' . dmyyyy($row["infectiondate"]) . '</td>
	<td>' . $row["organism1"] . '</td>
	<td>' . $row["organism2"] . '</td>
	<td>' . $row["treatment"] . '</td>
	<td>' . $row["outcome"] . '</td>
	<td>' . $row["exitsitenotes"] . '</td>
	<td>' . $row["modifstamp"] . '</td>
	<td><a href="renal/forms/exitsitedata_updateform.php?zid='.$zid.'&amp;data_id='.$exitsitedata_id.'">update</a></td>
	</tr>';
	}
	echo "</table>";
}
?>