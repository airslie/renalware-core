<?php
//Thu May 22 20:20:26 CEST 2008 :)
$showwhere="";
$urlappend="";
	$searched=TRUE;
	$sqlopers=array(
	'eq' => '=',
	'gt' => '>',
	'gte' => '>=',
	'lt' => '<',
	'lte' => '<=',
	'startswith' => 'startswith',
	'contains' => 'contains',
	'neq' => '!='
	);
	if ($get_srchfld1) {
	//HANDLE (1)
	$valfix = $mysqli->real_escape_string($get_srchval1);
	$sqlop=$sqlopers[$get_oper1];
	$whereterm=$fieldslist[$get_srchfld1]." $sqlop <b>'$valfix'</b>"; //for display
	//see if numeric
	if (is_numeric($valfix)) {
		$sqlwhereterm=$fieldslist[$get_srchfld1]." $sqlop $valfix";
		$whereterm=$fieldslist[$get_srchfld1]." $sqlop <b>$valfix</b>";		
		}
		else
		{
		$vallower=strtolower($valfix);
		$sqlwhereterm="LOWER($get_srchfld1) $sqlop '$vallower'";
		}
	if ($get_oper1=='contains') {
		//must be text
		$vallower=strtolower($valfix);
		$whereterm=$fieldslist[$get_srchfld1]." CONTAINS <b>'$vallower'</b>";
		$sqlwhereterm="LOWER($get_srchfld1) LIKE '%$vallower%'";
		}
	if ($get_oper1=='startswith') {
		//must be text
		$vallower=strtolower($valfix);
		$whereterm=$fieldslist[$get_srchfld1]." STARTS WITH <b>'$vallower'</b>";
		$sqlwhereterm="LOWER($get_srchfld1) LIKE '$vallower%'";
		}
		$urlappend="&amp;srchfld1=$get_srchfld1&amp;oper1=$get_oper1&amp;srchval1=$get_srchval1";
	}
	//END (1)
	//HANDLE (2)
	if ($get_srchfld2) {
	$valfix = $mysqli->real_escape_string($get_srchval2);
	$sqlop=$sqlopers[$get_oper2];
	$whereterm2=" AND " . $fieldslist[$get_srchfld2]." $sqlop <b>'$valfix'</b>"; //for display
	//see if numeric
	if (is_numeric($valfix)) {
		$sqlwhereterm2=" AND ".$fieldslist[$get_srchfld2]." $sqlop $valfix";
		$whereterm2=" AND " . $fieldslist[$get_srchfld2]." $sqlop <b>$valfix</b>";		
		}
		else
		{
		$vallower=strtolower($valfix);
		$sqlwhereterm2=" AND LOWER($get_srchfld2) $sqlop '$vallower'";
		}
	if ($get_oper2=='contains') {
		//must be text
		$vallower=strtolower($valfix);
		$whereterm2=" AND " . $fieldslist[$get_srchfld2]." CONTAINS <b>'$vallower'</b>";
		$sqlwhereterm2=" AND LOWER($get_srchfld2) LIKE '%$vallower%'";
		}
	if ($get_oper2=='startswith') {
		//must be text
		$vallower=strtolower($valfix);
		$whereterm2=" AND " . $fieldslist[$get_srchfld2]." STARTS WITH <b>'$vallower'</b>";
		$sqlwhereterm2=" AND LOWER($get_srchfld2) LIKE '$vallower%'";
		}
	$urlappend.="&amp;srchfld2=$get_srchfld2&amp;oper2=$get_oper2&amp;srchval2=$get_srchval2";
	//add whereterm2
	$whereterm.=$whereterm2;
	$sqlwhereterm.=$sqlwhereterm2;
	}
	//END (2)
	//HANDLE (date1)
	if ($get_datefld1) {
	$sqlop=$sqlopers[$get_dateoper1];
	$dateterm1=" AND " . $fieldslist[$get_datefld1]." $sqlop <b>'$get_dateval1'</b>"; //for display
	//dateonly
	$datefld1ymd=fixDate($get_datefld1);
	$sqldateterm1=" AND $datefld1ymd $sqlop '$get_dateval1'";
	$urlappend.="&amp;datefld1=$get_datefld1&amp;dateoper1=$get_dateoper1&amp;dateval1=$get_dateval1";
	//add dateterm1
	$whereterm.=$dateterm1;
	$sqlwhereterm.=$sqldateterm1;
	}
	//END (date1)
	//HANDLE (date2)
	if ($get_datefld2) {
	$sqlop=$sqlopers[$get_dateoper2];
	$dateterm2=" AND " . $fieldslist[$get_datefld2]." $sqlop <b>'$get_dateval2'</b>"; //for display
	//dateonly
	$datefld2ymd=fixDate($get_datefld2);
	$sqldateterm2=" AND $datefld2ymd $sqlop '$get_dateval2'";
	$urlappend.="&amp;datefld2=$get_datefld2&amp;dateoper2=$get_dateoper2&amp;dateval2=$get_dateval2";
	//add dateterm2
	$whereterm.=$dateterm2;
	$sqlwhereterm.=$sqldateterm2;
	}
	//END (date2)
	//initial $where in e.g. esdsearch.php; minimum = "WHERE";
	$where.=" AND $sqlwhereterm";
	//for debugging
//	echo "NEW WHERE: $where <br>";
	$showwhere="WHERE $whereterm"; //for display in header
?>

<?php
//Sat May 17 09:10:44 CEST 2008
if ($listnotes) {
	echo "<p><b>Note: $listnotes </b></p>";
}
//fix broken WHERE AND...
$where=str_replace("WHERE AND", "WHERE", $where);
$fields="";
$th="<th>options</th>";
$flip = ($get_flip=="DESC") ? "ASC" : "DESC" ;
$orderby=FALSE;
$sortedby=FALSE;
//order by searchfield prn
if ($searched) {
	$orderby= "ORDER BY $get_srchfld1";
	$sortedby="SORTED BY " . $fieldslist[$get_srchfld1];
}
//order by sortfield prn
foreach ($fieldslist as $key => $value) {
	$fields.=", $key";
	if ($key!="patzid") {
	$th.="<th>$value</th>";
	}
}
//remove leading comma
$fields=substr($fields,1);
$sql = "SELECT $fields FROM $table $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($showsql OR $get_showsql) {
	echo "<p class=\"alertsmall\">$sql</p>";
}
echo "<p class=\"header\">$numrows $thislistname results found $showwhere $sortedby.</p>";
// table header w/ autosorts :)
echo "<table class=\"tablesorter\"><thead>
	<tr>$th</tr></thead><tbody>";
while($row = $result->fetch_assoc())
	{
	$zid=$row["patzid"];
	echo "<tr>";
	//options links
	echo '<td class="links">';
	foreach ($optionlinks as $link => $label) {
		echo '<a href="'.$link.'&amp;zid='.$zid.'">'.$label.'</a>&nbsp;&nbsp;';
	}
	echo '</td>'; //end options
	foreach ($row as $key => $value) {
		if ($key!="patzid") {
			echo '<td>'.$row["$key"].'</td>';
		}
	}
	echo '</tr>';
	}
?>
</tbody></table>