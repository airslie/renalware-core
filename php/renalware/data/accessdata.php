<?php
$fields = "accessCurrent,
accessCurrDate,
";
$sql= "SELECT $fields FROM renaldata WHERE renalzid=$zid LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
	$accessCurrent=$row["accessCurrent"];
	$accessCurrDate=dmy($row["accessCurrDate"]);
	?>