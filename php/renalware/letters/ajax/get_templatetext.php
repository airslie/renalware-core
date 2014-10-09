<?php
include realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
$id=$_POST["id"];
$sql = "SELECT templatetext FROM renalware.lettertemplates WHERE template_id=$id";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$templatetext=$row["templatetext"];
$result->close();
echo "$templatetext";
?>