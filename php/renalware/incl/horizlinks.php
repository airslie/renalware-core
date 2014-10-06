<?php
//Wed Nov 18 17:25:25 CET 2009
echo '<p><a class="ui-state-default" style="color: green;" href="' . $_SERVER['PHP_SELF'] . '">Show all</a>&nbsp;&nbsp;';
$sql="SELECT $linkcode, $linkname FROM $linktable";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) {
echo '<a class="ui-state-default" style="color: #333;" href="' . $_SERVER['PHP_SELF'] . "?$linkcode=" . $row['0'] . '">' . $row['1'] . "</a>&nbsp;&nbsp;";
}
echo "</p>";
?>