<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
?>
<h3>Procedure History</h3>
<table class="list">
<?php
$fields="
logstamp,
user,
type,
cxflag
";
$tables="bedmgtlogs";
$sql="SELECT $fields FROM $tables WHERE pid=$pid ORDER BY log_id";

$result = $mysqli->query($sql);
while($row = $result->fetch_assoc())
	{
	//set colors
	$bg = ($bg=='#ffffff' ? '#ccccff' : '#ffffff'); // switch bg color
	if ( $row["cxflag"]==1 )
	{
		$bg='#ff0000';
	}
	echo '<tr>
	<td>' . $row["logstamp"] . '</td>
	<td>' . $row["user"] . '</td>
	<td>' . $row["type"] . '</td>
	</tr>';
	}

?>
</table>