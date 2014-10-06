<?php
//Sat May 17 09:10:44 CEST 2008
//Sun May 10 18:43:01 CEST 2009
if ($listnotes) {
	echo "<p><b>Note: $listnotes </b></p>";
}
$fields="";
$th="<th>options</th>";
$flip = ($get_flip=="DESC") ? "ASC" : "DESC" ;
$orderby=FALSE;
$sortedby=FALSE;
//order by searchfield prn
if ($searched) {
	$orderby= "ORDER BY $get_srchfld";
	$sortedby="SORTED BY " . $fieldslist[$get_srchfld];
}
//order by sortfield prn
if ($get_sort) {
	$orderby= "ORDER BY $get_sort $flip";
	$sortedby="SORTED BY " . $fieldslist[$get_sort];
}
$dataheaders="";
foreach ($fieldslist as $key => $value) {
	$fields.=", $key";
	if ($key!="patzid") {
	$th.="<th>$value</th>";
	$dataheaders.=",$value";
	}
}
//remove leading commas
$fields=substr($fields,1);
$headerslist=substr($dataheaders,1);
$sql = "SELECT $fields FROM $table $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($showsql) {
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
		echo '<a href="'.$link.'&amp;zid='.$zid.'" target="new">'.$label.'</a>&nbsp;&nbsp;';
	}
	echo '</td>'; //end options
	foreach ($row as $key => $value) {
		if ($key!="patzid") {
			$flddata=$row["$key"];
			$showdata = (strtolower(substr($key,-4))=="date") ? dmyyyy($flddata) : $flddata ;
			echo '<td>'.$showdata.'</td>';
		}
	}
	echo '</tr>';
	}
?>
</tbody></table>