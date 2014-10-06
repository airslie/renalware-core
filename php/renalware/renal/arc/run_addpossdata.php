<?php
//----Wed 27 Oct 2010----
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
	$insertfields="eq5duser,eq5dadddate";
	$insertvalues="'$user',NOW()";
	foreach ($_POST as $key => $value) {
		if ($value!="" && $key!="runmode") {
			$valfix = $mysqli->real_escape_string($value);
			if (substr($key,-4)=="date") {
				$valfix=fixDate($valfix);
			}
			$insertfields.=",$key";
			$insertvalues.=",'$valfix'";			
		}
	}
	$sql = "INSERT INTO renalware.arc_eq5ddata ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//echo "SUCCESS";
?>