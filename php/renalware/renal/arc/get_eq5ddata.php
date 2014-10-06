<?php
//----Wed 11 May 2011----
require '../../config_incl.php';
require '../../incl/check.php';
include '../../fxns/fxns.php';
include 'arc_config.php';
$table="arc_eq5ddata";
$sql = "SELECT * FROM $table WHERE eq5d_id=$get_eq5did";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
	$row = $result->fetch_assoc();
	foreach ($row as $key => $value) {
		$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
$showfields=$showeq5ddatafields;
echo '<h3>EQ-5D Survey of '.dmyyyy($row["eq5ddate"]).'</h3>';
echo '<ul class="dataportal">';
foreach ($showfields as $key => $value) {
	list($specs,$label)=explode("^",$value);
	if ($specs=="0") {
		echo '<li class="header">'.$label.'</li>';
	} else {
		echo '<li><b>'.$label.'</b>&nbsp;&nbsp;'.$$key."</li>";
	}
}
echo '</ul>';

?>
