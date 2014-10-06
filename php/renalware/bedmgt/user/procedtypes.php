<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$displaytext = "KRU operation types recorded"; //default
$where=""; //default
$fields="
procedtype_id,
proced,
category,
modifstamp
";
$tables="procedtypes";
$sql="SELECT $fields FROM $tables $where $orderby";
if ( $_GET['debug'] )
	{
	echo "<hr>$query<hr>";
	}
$result = $mysqli->query($sql);
$numfound=$result->num_rows;
if (!$numfound)
	{
	echo "<p class=\"results\">There are no $displaytext!</p>";
	}
else
	{
echo '<table class="list">
<tr>
<th>proced ID</th>
<th>procedure</th>
<th>category</th>
<th>updated</th>
</tr>';
while($row = $result->fetch_assoc())
	{
	//set colors
	echo '<tr>
	<td>' . $row["procedtype_id"] . '</td>
	<td><b>' . $row["proced"] . '</b></td>
	<td>' . $row["category"] . '</td>
	<td><i>' . $row["modifstamp"] . '</i></td>
	</tr>';
	}
echo '</table>';
}
