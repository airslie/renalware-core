<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$displaytext = "KRU surgeons recorded"; //default
$where=""; //default
$fields="
surg_id,
surglast,
surgfirst,
surgemail,
addstamp
";
$tables="surgeons";
$orderby="ORDER BY surglast, surgfirst";
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
	echo "<p class=\"results\">$numtotal $displaytext ($numfound displayed). ";
	// include links stuff
	echo '<table class="list">
	<tr>
<th>surgeon</th>
<th>email</th>
<th>addstamp</th>
	</tr>';
	while($row = $result->fetch_assoc())
		{
		//set colors
		
		echo '<tr>
<td><b>' . $row["surglast"] . ', ' . $row["surgfirst"] . '</b></td>
<td><a href="mailto:' . $row["surgemail"] . '">' . $row["surgemail"] . '</a></td>
<td>' . $row["addstamp"] . '</td>
		</tr>';
		}
	echo '</table>';
	}
