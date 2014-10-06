<?php
//Fri May  8 09:55:49 CEST 2009
//create easy sitelist
$sql="SELECT sitecode, sitename FROM sitelist";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) {
 echo '<option value="' . $row["0"] . '">' . $row['1'] . "</option>\n";
}
?>