<?php
//Tue Jan 16 14:00:08 CET 2007
echo "<select name=\"$selectname\">";
echo '<option value="">Select...</option>';
$sql="SELECT $optionid, $optionname FROM $optiontable $optionwhere ORDER BY $orderby";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) {
echo '<option value="' . $row['0'] . '">' . $row['1'] . "</option>";
}
echo "</select>";
