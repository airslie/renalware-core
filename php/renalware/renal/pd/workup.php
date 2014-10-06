<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
//get patientdata
$zid = $get_zid;
include "$rwarepath/data/patientdata.php";
$pagetitle= "$get_mode CAPD Assessment for $firstnames " . strtoupper($lastname);
include "$rwarepath/parts/head.php";
include "$rwarepath/optionlists/renaloptionlistarrays.php";
switch ($get_mode) {
	case 'create':
		$runtype="add";
		include "$rwarepath/renal/pd/pdworkupform.php";
		break;
	case 'view':
		$runtype="update";
		include "$rwarepath/renal/pd/getworkupdata.php";
		include "$rwarepath/renal/pd/pdworkupform.php";
		break;
}
switch ($get_run) {
	case 'add':
		//include "$rwarepath/renal/run/runworkup_add.php";
		//$debug=TRUE;
		$insertfields="workupaddstamp, workupuser, workupzid";
		$insertvalues="NOW(), '$user', '$zid'";
		foreach ($_POST as $key => $value) {
				${$key}=$mysqli->real_escape_string($value);
				if (substr($key,-4)=="date")
					{
					${$key} = fixDate($value);
					}
				$insertfields .= $value ? ", $key" : "";
				$insertvalues .= $value ? ", '".${$key}."'" : "";
			}
			//INSERT  the table
			$table = 'renalware.capdworkups'; //****UPDATE
			$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
			runsql($sql, $debug);
			//log the event
		//	$zid=$get_zid; //*****UPDATE
			$eventtype="Patient PD Workup created";
			$eventtext=$mysqli->real_escape_string($sql); //store change!
			include "$rwarepath/run/logevent.php";
			if (!$debug) {
				header ("Location: $rwareroot/renal/renal.php?scr=renalsumm&zid=$zid"); //****UPDATE
			}
		
		break;
	case 'update':
		include "$rwarepath/renal/run/runworkup_update.php";
		break;
}
?>
</body>
</html>