<?php
//----Mon 14 Jun 2010----special for new and old CRE
$symbls=array('*','^');
$fields="resultsdate,URE,CRE";
$symbls=array('*','^');
foreach($pathfieldslist as $key => $value) {
	$fields.=",$value";
}
//remove * and ^
$fields=str_replace($symbls,"",$fields);
$limit = ($limitno) ? "LIMIT $limitno" : "" ;
//MDRD= 186*(POWER((CRE/88.4), -1.154) * POWER(age, -0.203)) * IF(sex='F',.742,1)
$sql = "SELECT $fields, IF(resultsdate>'2010-04-28' AND CRE>0,FLOOR((CRE+26.5)/1.25),'') as oldcre, POWER(FLOOR(DATEDIFF(resultsdate,birthdate)/365), -0.203) as mdrdage FROM hl7data.pathol_results JOIN renalware.patientdata ON resultspid=hospno1 WHERE resultspid='$pid' ORDER BY resultsdate DESC $limit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no recorded results in the system for this patient!</p>";
	}
else
	{
	echo "<p class=\"header\">$numrows $resultsheader results displayed (Max $limitno). Click on headers to sort; hover over column header abbreviation for investigation name. <br>
	NOTE: CRE* represents creatinine calculated with the formula used prior to 28/4/2010. ['Old CRE'='new CRE'+26.5)/1.25]</p>";
	echo "<table class=\"tablesorter\"><thead>
	<tr><th>date</th><th>URE</th><th>CRE</th><th>CRE*</th>";
	foreach($pathfieldslist as $key => $value) {
		$pathfld=str_replace($symbls,"",$value);
		echo '<th><a title="'.$obxcodelist[$pathfld].'">'.$pathfld.'</a></th>';
	}
	echo "</tr></thead><tbody>";
    while($row = $result->fetch_assoc())
    	{
		list($yyyy,$mm,$dd)=explode("-",$row["resultsdate"]);
		$CRE=$row["CRE"];
		echo '<tr class="" onMouseOver="this.className=\'hi\'" onMouseOut="this.className=\'n\'">
		<td class="b">' . "$dd/$mm/$yyyy" . '</td>';
		echo '<td class="bc">'.$row["URE"].'</td>';
		echo '<td class="bc">'.$CRE.'</td>';
		echo '<td class="old">'.$row["oldcre"].'</td>';
		//special for CRE
		foreach ($pathfieldslist as $key => $value) {
			$pathfld=str_replace($symbls,"",$value);
			$tdclass = (strpos($value,"*")) ? ' class="bc"' : '' ;
			echo '<td'.$tdclass.'>'.$row["$pathfld"].'</td>';
		    }
		echo '</tr>';
		}
		echo "</tbody></table>";
	}
