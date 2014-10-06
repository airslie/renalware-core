<?php
$ixworkuptype=$post_ixworkuptype;
$insertfields="ixworkupuser, ixworkupaddstamp, ixworkupzid,currflag";
$insertvalues="'$user',NOW(),$zid,1";
foreach ($_POST as $key => $value) {
		$escvalue=$mysqli->real_escape_string($value);
		${$key} = (substr($key,-4)=="date") ? fixDate($escvalue) : $escvalue ;
		if ($value) {
			//omit nulls
			$insertfields.=",$key";
			$insertvalues.=",'${$key}'";
		}
}
//unflag prev currflag!
$sql = "UPDATE ixworkupdata SET currflag=0 WHERE ixworkuptype='$ixworkuptype' AND ixworkupzid=$zid AND currflag=1 LIMIT 1";
$result = $mysqli->query($sql);
//add to ixdatatbl
$table = "ixworkupdata";
$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
$eventtype="NEW INVESTIGATION: $ixworkuptype";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
//end logging
//incr
incrStat('ixdata',$zid);
//set pat modifstamp
stampPat($zid);
showAlert("The '.$ixworkuptype.' investigation has been recorded!");
