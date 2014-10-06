<?php
//----Mon 25 Feb 2013----cannulation
//---------------Sun Apr 11 16:04:33 CEST 2010---------------removed transport fields (now patdata)
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$zid = $_GET["zid"];
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
	}
//specials
$schedslotdata = explode("-",$sched_slot);
$currsched = $schedslotdata[0];
$currslot = $schedslotdata[1];
//update the table
$table = 'renalware.hdpatdata';
$where = "WHERE hdpatzid=$zid";
$updatefields = "
currsched='$currsched',
currslot='$currslot',
hdtype='$hdtype',
prefsite='$prefsite',
prefsched='$prefsched',
prefslot='$prefslot',
prefdate='$prefdate',
prefnotes='$prefnotes',
needlesize='$needlesize', 
singleneedle='$singleneedle', 
hours='$hours', 
dialyser='$dialyser', 
dialysate='$dialysate', flowrate='$flowrate', dialK='$dialK', dialCa='$dialCa', dialTemp='$dialTemp', dialBicarb='$dialBicarb', dialNaProfiling='$dialNaProfiling', dialNa1sthalf='$dialNa1sthalf', dialNa2ndhalf='$dialNa2ndhalf', anticoagtype='$anticoagtype', anticoagloaddose='$anticoagloaddose', anticoaghourlydose='$anticoaghourlydose', anticoagstoptime='$anticoagstoptime',prescriber='$prescriber', prescriptdate='$prescriptdate', esdflag='$esdflag', ironflag='$ironflag', namednurse='$namednurse', warfarinflag='$warfarinflag',cannulationtype='$cannulationtype'";
$sql = "UPDATE $table SET $updatefields, hdmodifstamp=NOW() $where LIMIT 1";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient HD Profile updated";
$eventtext=$mysqli->real_escape_string($updatefields);
include "$rwarepath/run/logevent.php";
//new Wed Sep 10 15:55:32 BST 2008 archive profile
$table="renalware.hdprofilehxdata";
$insertfields="
hdprofilezid,
currsite,
currsched,
hdtype,
needlesize,
singleneedle,
hours,
dialyser,
dialysate,
flowrate,
dialK,
dialCa,
dialTemp,
dialBicarb,
dialNaProfiling,
dialNa1sthalf,
dialNa2ndhalf,
anticoagtype,
anticoagloaddose,
anticoaghourlydose,
anticoagstoptime,
prescriber,
prescriptdate,
esdflag,
ironflag,
namednurse,
warfarinflag,
dryweight,
drywtassessdate,
drywtassessor,
currslot,
prefsite,
prefsched,
prefslot,
prefdate,
prefnotes,
carelevelrequired,
careleveldate,
cannulationtype";
$insertvalues="
$zid,
'$currsite',
'$currsched',
'$hdtype',
'$needlesize',
'$singleneedle',
'$hours',
'$dialyser',
'$dialysate',
'$flowrate',
'$dialK',
'$dialCa',
'$dialTemp',
'$dialBicarb',
'$dialNaProfiling',
'$dialNa1sthalf',
'$dialNa2ndhalf',
'$anticoagtype',
'$anticoagloaddose',
'$anticoaghourlydose',
'$anticoagstoptime',
'$prescriber',
'$prescriptdate',
'$esdflag',
'$ironflag',
'$namednurse',
'$warfarinflag',
'$dryweight',
'$drywtassessdate',
'$drywtassessor',
'$currslot',
'$prefsite',
'$prefsched',
'$prefslot',
'$prefdate',
'$prefnotes',
'$carelevelrequired',
'$careleveldate',
'$cannulationtype'";
$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient HD Profile archived";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
header ("Location: $rwareroot/renal/renal.php?zid=$zid&scr=hdnav&hdmode=profile");
