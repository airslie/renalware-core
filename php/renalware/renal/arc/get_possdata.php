<?php
//----Wed 11 May 2011----
require '../../config_incl.php';
require '../../incl/check.php';
include '../../fxns/fxns.php';
include 'arc_config.php';
$table="arc_possdata2";
$sql = "SELECT * FROM $table WHERE poss_id=$get_possid";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
	$row = $result->fetch_assoc();
	foreach ($row as $key => $value) {
		$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
$showfields=$showpossdatafields;
echo '<h3>POS-S Survey of '.dmyyyy($row["possdate"]).'</h3>';
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
