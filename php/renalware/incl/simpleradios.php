<?php
$sql="SELECT $popcode, $popname FROM $poptable ORDER BY $popname";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) {
echo '<input type ="radio" name=' . $name . ' value="' . $row['0'] . '" />' . $row['1'] . "&nbsp; &nbsp;";
}
?>