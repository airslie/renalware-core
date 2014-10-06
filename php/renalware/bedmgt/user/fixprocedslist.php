<p><strong>IMPORTANT: (1) Ensure the operation/procedure is not already in the database and (2) please be sure to use the correct spelling!</strong><br>
The existing list is displayed below -- please check it carefully before adding a new entry.</p>
<p><span class="alertsmall">DELETE with caution -- this operation cannot be undone!</span></p>
<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//run delete prn
if ( $_GET['delete'] )
	{
	$delete_id=$_GET['delete'];
	$sql="DELETE FROM procedtypes WHERE procedtype_id=$delete_id LIMIT 1";
	$result = $mysqli->query($sql);
	echo "<br>Procedure No $delete_id has been deleted!";
	}
//display list
$displaytext = "KRU operation types recorded"; //default
$where=""; //default
$fields="
procedtype_id,
proced,
category,
modifstamp
";
$tables="procedtypes";
$orderby="ORDER BY proced";
$sql="SELECT $fields FROM $tables $where $orderby";
if ( $_GET['debug'] )
	{
	echo "<hr>$query<hr>";
	}
$result = $mysqli->query($sql);
$numfound=$result->num_rows;
echo "<p class=\"results\">$numfound $displaytext.</p>";
	// include links stuff
	echo '<table class="list">
	<tr>
	<th>op ID</th>
	<th>operation</th>
	<th>category</th>
	<th>added</th>
	<th>options</th>
	</tr>';
	while($row = $result->fetch_assoc())
		{
		//set colors
		$bg='#ccf';
		echo '<tr>
		<td>' . $row["procedtype_id"] . '</td>
		<td><b>' . $row["proced"] . '</b></td>
		<td>' . $row["category"] . '</td>
		<td><i>' . $row["modifstamp"] . '</i></td>
		<td><a href="index.php?vw=user&amp;scr=fixprocedslist&delete=' . $row["procedtype_id"] . '">delete No ' . $row["procedtype_id"] . '</a></td>
		</tr>';
		}
	echo '</table>';

//add form
?>
<hr>
<h3>Add New Op/Procedure</h3>
<form action="run/runaddprocedtype.php" method="post">
<input type="hidden" name="mode" value="add" id="mode" />
<table>
<tr><td class="fldview">Op/Procedure Name</td><td class="data"><input class="form" type="text" size="40" name="proced" ></td></tr>
<tr><td class="fldview">Category</td><td class="data"><select name="category" >
<option>Biopsy</option>
<option>Diagnostic</option>
<option>Surgical</option>
<option>N/A</option>
</select></td></tr>
</table>
<input type="submit" name="submit" value="Add new Op/Procedure" id="submit" />