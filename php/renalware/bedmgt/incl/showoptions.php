<?php
//where, order are optional
$sql="SELECT $popcode, $popname FROM $poptable $where $orderby";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) {
echo '<option value="' . $row['0'] . '">' . htmlentities($row['1']) . "</option>";
}
