<?php
//----Sun 31 Jul 2011----using optionlists tbl now
$sql = "SELECT listhtml FROM optionlists WHERE listname='$optionlistname' LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
echo $row["listhtml"];
?>