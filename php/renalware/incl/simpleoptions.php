<?php
$popsql="SELECT $popcode, $popname FROM $poptable $poporder";
$popresult = $mysqli->query($popsql);
while($poprow = $popresult->fetch_row()) {
echo '<option value="' . $poprow['0'] . '">' . $poprow['1'] . "</option>";
}
?>