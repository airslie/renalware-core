<?php
foreach ($_POST as $key => $value) {
		$escvalue=$mysqli->real_escape_string($value);
		${$key} = (substr($key,-4)=="date") ? fixDate($escvalue) : $escvalue ;
}
$insertfields="encuser, encaddstamp, enczid, encmodal,encdate,enctime,enctype,encdescr,staffname,enctext";
$insertvalues="'$user',NOW(),$get_zid, '$modalcode','$encdate','$enctime','$enctype','$encdescr','$staffname','$enctext'";
if (is_numeric($encbpsyst) && is_numeric($encbpdiast)) {
	$encbp=TRUE;
	$insertfields.=",bpsyst, bpdiast";
	$insertvalues.=",$encbpsyst,$encbpdiast";
	//run BP
	$sql = "UPDATE currentclindata SET currentstamp=NOW(), BPsyst=$encbpsyst, BPdiast=$encbpdiast, BPdate='$encdate' WHERE currentclinzid=$zid";
	$result = $mysqli->query($sql);
}
if (is_numeric($encweight)) {
	$encwt=TRUE;
	$insertfields.=",weight";
	$insertvalues.=",$encweight";
	$sql = "UPDATE currentclindata SET currentstamp=NOW(), Weight=$encweight, Weightdate='$encdate' WHERE currentclinzid=$zid";
	$result = $mysqli->query($sql);
}
if (is_numeric($encheight) && $encheight<3) {
	$encht=TRUE;
	//ignore height in cm for now
	$insertfields.=",height";
	$insertvalues.=",$encheight";
	$sql = "UPDATE currentclindata SET currentstamp=NOW(), Height=$encheight, Heightdate='$encdate' WHERE currentclinzid=$zid";
	$result = $mysqli->query($sql);
}

$table = "encounterdata";
//run INSERT
$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW ENCOUNTER: $encdate $enctime -- $enctype; $encdescr by $staffname";
$eventtext=$enctext;
include "$rwarepath/run/logevent.php";
//end logging
//incr
incrStat('encounters',$zid);
//set pat modifstamp
stampPat($zid);
if ($encwt)
	{
		$sql = "UPDATE currentclindata SET BMI=Weight/Height/Height WHERE currentclinzid=$zid AND Height>0";
		$result = $mysqli->query($sql);
		//NB any encht already submitted above
	}
if ( $encbp or $encwt  )
	{
	//insert into BPWT
	$insertfields="bpwtzid, bpwtuid, bpwtstamp, bpwttype, bpwtmodal, bpwtdate"; 
	$insertvalues="$zid, $uid, NOW(), '$enctype', '$modalcode', '$encdate'";
	if ($encbp) {
		$insertfields.=",bpsyst, bpdiast";
		$insertvalues.=",$encbpsyst, $encbpdiast";
	}
	if ($encwt) {
		$insertfields.=",weight";
		$insertvalues.=",$encweight";
		if ($Height or $encht) {
			$currht = ($encht) ? $encheight : $Height ;
			$currbmi=$encweight/$currht/$currht;
			$insertfields.=",BMI";
			$insertvalues.=",$currbmi";
		}
	}
	$sql= "INSERT INTO bpwtdata ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="NEW BP/Wt DATA ADDED";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//incr
	incrStat('bpwts',$zid);
	//set pat modifstamp
	stampPat($zid);
	}
showAlert("The '. $enctype .' encounter has been recorded!");
//end ADD
?>