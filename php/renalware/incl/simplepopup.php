<?php
echo '<form action="' . $_SERVER['PHP_SELF'] . '" method="get"><select name="' . $popcode . '">';
echo '<option value="">Select ' . $popname . '...</option>';
$sql="SELECT $popcode, $popname FROM $poptable";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) {
echo '<option value="' . $row['0'] . '">' . $row['1'] . "</option>";
}
echo '</select><input type="submit" style="color: green;" value="Find ' . $popname . '" /></form>';
?>