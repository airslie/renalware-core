<?php
//----Mon 23 Jul 2012----clinical fields
//$letter_id = $_POST['letter_id'];
//refresh probs, meds
$lettproblems=$mysqli->real_escape_string($problist);
$lettmeds=$mysqli->real_escape_string($medlist);
$updatefields = "lettmodifstamp=NOW(), letterdate=NOW(), status='TYPED', salut='$salut', lettresults='$lettresults', lettdescr='$lettdescr', lettertype_id=$lettertype_id, cctext='$cctext',reason='$reason', deathcause='$deathcause', printstage=0,lettproblems='$lettproblems',lettmeds='$lettmeds', authorid=$authorid, authorlastfirst='$authorlastfirst',  authorsig='$authorsig', position='$position'";

$clinicaldata=array('lettBPsyst','lettBPdiast','lettWeight','lettHeight','letturine_blood','letturine_prot');
foreach ($clinicaldata as $key => $fld) {
    if (${$fld}) {
        $fldval=${$fld};
        $updatefields.=", $fld='$fldval'";
    }
}
if ($lettertype=='simple')
	{
	$updatefields = "lettmodifstamp=NOW(), letterdate=NOW(), status='TYPED', salut='$salut', lettdescr='$lettdescr', lettertype_id=$lettertype_id,  cctext='$cctext', printstage=0,authorid=$authorid, authorlastfirst='$authorlastfirst',  authorsig='$authorsig', position='$position'";
	}
$sql= "UPDATE letterdata SET $updatefields WHERE letter_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//update ltext
$updatefields = "lettertextuid=$uid, modifstamp=NOW(), ltext='$ltext'";
$sql= "UPDATE lettertextdata SET $updatefields WHERE lettertext_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//update currentclindata
//----Mon 23 Jul 2012----to handle currentclindata update
$updatefields = "currentstamp=NOW()";
//only add prn
$fldslogged="";
$clinicaldata=array('BPsyst','BPdiast','Weight','Height');
foreach ($clinicaldata as $key => $fld) {
    $lettfld="lett{$fld}";
    if (${$lettfld}) {
        $fldval=${$lettfld};
        $updatefields.=", $fld='$fldval'";
        $fldslogged.="$fld ";
    }
}
//for dates
if ($lettBPsyst && $lettBPdiast) {
    $updatefields.=", BPdate='$clinicdateymd'";
}

//for BMI
if ($lettWeight && $lettHeight) {
    $newBMI=$lettWeight/$lettHeight/$lettHeight;
    $updatefields.=", BMI='$newBMI'";
    $fldslogged.="BMI ";
}
$tables = 'currentclindata';
$where = "WHERE currentclinzid=$zid";
$sql= "UPDATE $tables SET $updatefields $where";
$result = $mysqli->query($sql);

//?need to refresh data?
include "$rwarepath/letters/data/letterdata.php";

//compile the whole letter
include ('incl/compiletext.php');
$letterfulltext=$mysqli->real_escape_string($letterfulltext);
//update letter with fulltext field
	$sql= "UPDATE lettertextdata SET lfulltext='$letterfulltext' WHERE lettertext_id=$letter_id";
	$result = $mysqli->query($sql);
//log the event w/ fulltext
	$eventtype="$status $lettdescr [ID $letter_id] by $authorsig";
	$eventtext=$letterfulltext;
	include "$rwarepath/run/logevent.php";
?>