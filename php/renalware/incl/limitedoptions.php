<?php
$popsql="SELECT $popcode, $popname FROM $poptable WHERE $popwhere";
$popresult = $mysqli->query($popsql);
while($poprow = $popresult->fetch_row()) {
echo '<option value="' . $poprow['0'] . '">' . $poprow['1'] . "</option>";
}
?>