<?php
include '../../req/confcheckfxns.php';
//---------------CONFIG--------------
$insertfields="templateuid,templatestamp";
$insertvalues="$uid, NOW()";
$table="lettertemplates";
$goto=FALSE;
//---------------END CONFIG--------------
foreach ($_POST as $key => $value) {
		$valuefix = (substr($key,-4)=="date") ? fixDate($value) : $value ;
		${$key}=$mysqli->real_escape_string($valuefix);
		if ($value) {
			//omit nulls
			$insertfields.=",$key";
			$insertvalues.=",'${$key}'";
		}
}
//run INSERT
$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
if ($goto) {
	header ("Location: $goto");
}
?>