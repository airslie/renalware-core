<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$insertfields="txopaddstamp";
$insertvalues="NOW()";
//$updatefields="txopmodifstamp=NOW()";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			if (substr($key,-3)!="_id")
				{
					$insertfields .= $value ? ", $key" : "";
					$insertvalues .= $value ? ", '".${$key}."'" : "";
				}
	}
	//upd  the table
	$table = 'renalware.txops';
	$sql= "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
//	echo "$sql <br>";
	//log the event
	$zid=$txopzid;
	$eventtype="Patient Tx Op added";
	$eventtext=$mysqli->real_escape_string($sql); //store change!
	include "$rwarepath/run/logevent.php";
	header ("Location: $rwareroot/renal/txoplist.php");
?>