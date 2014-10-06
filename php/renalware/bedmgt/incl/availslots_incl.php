<h3>Available Surgical Slots (next 30 operating days shown)</h3>
<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$showdays=30;
//nb !="calendar days" as only days w/ ops! (i.e. 2d/wk)
if ( $_GET['showdays'] )
	{
	$showdays=$_GET['showdays'];
	}
$fields="DATE_FORMAT(diarydate, '%a %d/%m/%Y') AS diaryddmy,
slot1zid, CONCAT(p1.lastname, ', ', p1.firstnames, ' (',p1.hospno1, ')') as pat1, slot1proced, priority1,
slot2zid, CONCAT(p2.lastname, ', ', p2.firstnames, ' (',p2.hospno1, ')') as pat2, slot2proced, priority2,
slot3zid, CONCAT(p3.lastname, ', ', p3.firstnames, ' (',p3.hospno1, ')') as pat3, slot3proced, priority3,
slotEzid, CONCAT(pE.lastname, ', ', pE.firstnames, ' (',pE.hospno1, ')') as emergpat, slotEproced, priorityE,
freeslots
";
$tables="surgdiary LEFT JOIN renalware.patientdata p1 ON slot1zid=p1.patzid LEFT JOIN renalware.patientdata p2 ON slot2zid=p2.patzid LEFT JOIN renalware.patientdata p3 ON slot3zid=p3.patzid LEFT JOIN renalware.patientdata pE ON slotEzid=pE.patzid";
$sql="SELECT $fields FROM $tables WHERE freeslots>0 AND diarydate>=NOW() LIMIT $showdays";
$result = $mysqli->query($sql);
$numfound=$result->num_rows;
if (!$numfound)
	{
	echo "<p class=\"results\">There are no available slots within $showdays days!</p>";
	}
else
	{
	echo '<table class="list">
	<tr>
	<th>date</th>
	<th>slot 1</th>
	<th>slot 2</th>
	<th>slot 3</th>
	<th>emergency</th>
	<th>freeslots</th>
	</tr>';
	while($row = $result->fetch_assoc())
		{
		//set colors
		
		//flag priority
		if ( $row["freeslots"]=="3" )
		{
			$bg='#FFCC00';
		}
		if ( $row["freeslots"]=="2" )
		{
			$bg='#ffff33';
		}
		if ( $row["freeslots"]=="0" )
		{
			$bg='#cccccc';
		}
		echo '<tr>
		<td>' . $row["diaryddmy"] . '</td>
		<td>' . $row["pat1"] . '<br><b>' . $row["slot1proced"] . '</b><br>' . $row["priority1"] . '</td>
		<td>' . $row["pat2"] . '<br><b>' . $row["slot2proced"] . '</b><br>' . $row["priority2"] . '</td>
		<td>' . $row["pat3"] . '<br><b>' . $row["slot3proced"] . '</b><br>' . $row["priority3"] . '</td>
		<td>' . $row["emergpat"] . '<br><b>' . $row["slotEproced"] . '</b><br>' . $row["priorityE"] . '</td>
		<td>' . $row["freeslots"] . '</td>
		</tr>';
		}
	echo '</table>';
	}

?>