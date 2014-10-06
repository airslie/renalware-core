<?php
//Sat May 17 09:10:44 CEST 2008
//Sun May 10 18:43:01 CEST 2009
if ($listnotes) {
	echo "<p><b>Note: $listnotes </b></p>";
}
$fields="";
$theaders="<th>options</th>";
foreach ($fieldslist as $key => $value) {
	$fields.=", $key";
	if ($key!="patzid") {
	$theaders.='<th>'.$value. "</th>\r";
	}
}
//remove leading commas
$fields=substr($fields,1);
$sql = "SELECT $fields FROM $table $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($showsql) {
	echo "<p class=\"alertsmall\">$sql</p>";
}
echo "<p class=\"header\">$numrows $thislistname results found $showwhere. Click on headers to sort.";
?>
<table class="tablesorter">
	<thead><tr><?php echo $theaders ?></tr></thead>
	<tbody>
	<?php
	while($row = $result->fetch_assoc())
		{
		$zid=$row["patzid"];
		echo "<tr>";
		//options links
		echo '<td>';
		foreach ($optionlinks as $link => $label) {
			echo '<a class="gr" href="'.$link.'&amp;zid='.$zid.'" target="new">'.$label.'</a> ';
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
	</tbody>
</table>