<?php
//----Sun 03 Aug 2014----use pathol_results EGFR
//----Wed 13 Nov 2013----HGB td fix
//----Mon 23 Sep 2013----HGB fix NB removed from list array and placed manually
//-------CONFIG-----------
$pid=$hospno1;
$limitno=10; //or FALSE
$resultsheader="Low Clearance"; //e.g. Haematol, Biochem, etc
//desired fields ***NB resultsdate automatically 1st column
//follow code with * to bold the column
$pathfieldslist=array(
	'RETA',
	'HYPO',
	'WBC',
	'PLT',
	'FER',
	'NA',
	'POT',
	'BIC',
	'CCA',
	'PHOS',
	'PTHI',
	'TP',
	'GLO',
	'ALB',
	'URAT',
	'BIL',
	'ALT',
	'ALP',
	'GGT',
	'BGLU',
	'HBA',
	'HBAI',
	'CRP',
	'CHOL',
	);
include "$rwarepath/pathology/incl/obxcodelist.php";
//process
$fields="resultsdate,URE,CRE,EGFR,HB"; //nb HB here
$symbls=array('*','^');
foreach($pathfieldslist as $key => $value) {
    $valuefix = str_replace($symbls,"",$value);
    $fields.=",$valuefix";
}
$limit = ($limitno) ? "LIMIT $limitno" : "" ;
$sql = "SELECT $fields, FLOOR(DATEDIFF(resultsdate,birthdate)/365) as resultsage FROM hl7data.pathol_results JOIN renalware.patientdata ON resultspid=hospno1 WHERE resultspid='$pid' ORDER BY resultsdate DESC $limit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no recorded results in the system for this patient!</p>";
	}
else
	{
	echo "<p class=\"header\">$numrows $resultsheader results displayed (Max $limitno).</p>";
	echo "<table class=\"tablesorter\"><thead>
	<tr><th>date</th><th>age</th><th>URE</th><th>CRE</th><th>MDRD</th><th>HGB</th>";
	foreach($pathfieldslist as $key => $value) {
		$pathfld=str_replace($symbls,"",$value);
		echo '<th><a title="'.$obxcodelist[$pathfld].'">'.$pathfld.'</a></th>';
	}
	echo "</tr></thead><tbody>";
while($row = $result->fetch_assoc())
	{
		list($yyyy,$mm,$dd)=explode("-",$row["resultsdate"]);
		$CRE=$row["CRE"];
        $HGB = ($row["HB"]) ? 10*$row["HB"] : '' ;
		//for mdrd
		$mdrd = $row["EGFR"];
		echo '<tr class="" onMouseOver="this.className=\'hi\'" onMouseOut="this.className=\'n\'">
		<td class="b">' . "$dd/$mm/$yyyy" . '</td>';
		echo '<td class="bc">'.$row["resultsage"].'</td>';
		echo '<td class="bc">'.$row["URE"].'</td>';
		echo '<td class="bc">'.$CRE.'</td>';
		echo '<td class="mdrd">'.$mdrd.'</td>';
		echo '<td class="hb">'.$HGB.'</td>'; //HGB fix
		//special for CRE
foreach ($pathfieldslist as $key => $value) {
		$pathfld=str_replace($symbls,"",$value);
		$tdclass='';
		if (strpos($value,"*"))
		{
		$tdclass=' class="bc"';
		}
		if (strpos($value,"^"))
		{
		$tdclass=' class="hb"';
		}
		echo '<td'.$tdclass.'>'.$row["$pathfld"].'</td>';
	}
	echo '</tr>';
	}
	echo "</tbody></table>";
}
