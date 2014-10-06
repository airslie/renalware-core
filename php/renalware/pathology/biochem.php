<?php
//----Sun 03 Aug 2014----now use EGFR from pathresults table (run in nightly script) instead of calculating here
//----Fri 25 Oct 2013----'old CRE' display DEPR
//-------CONFIG-----------
$limitno=FALSE; //or FALSE
$resultsheader="Biochemistry"; //e.g. Haematol, Biochem, etc
//desired fields ***NB resultsdate automatically 1st column
//follow code with * to bold the column
$pathfieldslist=array(
	'NA',
	'POT*',
	'BIC*',
	'CCA',
	'PHOS',
	'PTHI*',
	'TP',
	'GLO',
	'ALB',
	'URAT',
	'BIL',
	'ALT',
	'AST',
	'ALP',
	'GGT',
	'BGLU',
	'HBA',
	'HBAI*',
	'CHOL',
	'HDL*',
	'LDL',
	'TRIG',
	'TSH',
	'CK',
	'URR*',
	'CRCL',
	'UREP',
	'AL',
	);
include 'incl/obxcodelist.php';
//process
$fields="resultsdate, URE, CRE, EGFR";
$symbls=array('*','^');
foreach($pathfieldslist as $key => $value) {
	$fields.=",$value";
}
//remove * and ^
$fields=str_replace($symbls,"",$fields);
$limit = ($limitno) ? "LIMIT $limitno" : "" ;
$sql = "SELECT $fields, birthdate,FLOOR(DATEDIFF(resultsdate,birthdate)/365) as resultsage FROM hl7data.pathol_results JOIN renalware.patientdata ON resultspid=hospno1 WHERE resultspid='$pid' ORDER BY resultsdate DESC $limit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"resultsheader\">There are no recorded results in the system for this patient!</p>";
	}
else
	{
	echo "<p class=\"resultsheader\">$numrows $resultsheader results displayed (Max $limitno). Click on headers to sort; hover over column header abbreviation for investigation name.</p>";
	echo "<table class=\"tablesorter\"><thead>
	<tr><th>date</th><th>age</th><th>URE</th><th>CRE</th><th>EGFR</th>";
	foreach($pathfieldslist as $key => $value) {
		$pathfld=str_replace($symbls,"",$value);
		echo '<th><a title="'.$obxcodelist[$pathfld].'">'.$pathfld.'</a></th>';
	}
	echo "</tr></thead><tbody>";
    while($row = $result->fetch_assoc())
    	{
    		list($yyyy,$mm,$dd)=explode("-",$row["resultsdate"]);
    		echo '<tr class="" onMouseOver="this.className=\'hi\'" onMouseOut="this.className=\'n\'">
    		<td class="b">' . "$dd/$mm/$yyyy" . '</td>';
    		echo '<td class="bc">'.$row["resultsage"].'</td>';
    		echo '<td class="bc">'.$row["URE"].'</td>';
    		echo '<td class="bc">'.$row["CRE"].'</td>';
    		echo '<td class="mdrd">'.$row["EGFR"].'</td>';
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
