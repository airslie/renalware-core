<?php
//Wed Oct 14 13:00:49 CEST 2009 escaped author name and sig
//only a few fields can be updated:
foreach ($_POST as $key => $value) {
	$$key = (is_string($value)) ? $mysqli->real_escape_string($value) : $value ;
}
//in case changed
	$sql= "SELECT letterdescr FROM letterdescrlist WHERE lettertype_id=$lettertype_id LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$lettdescr = $row["letterdescr"];
if ($lettertype=="clinic") {
	$clinicdateymd=fixDate($clinicdatedmy);
}
//get disch/death letterdescr
if ( $lettertype=="discharge" )
	{
	$lettdescr = "DISCHARGE SUMMARY";
	$lettertype_id = 1;
}
if ( $lettertype=="death" )
	{
	$lettdescr = "DEATH NOTIFICATION";
	$lettertype_id = 1;
}
	//refresh Author data... sigh
//try here for global use
$sql= "SELECT userlast, userfirst, inits, authorsig, position FROM userdata WHERE uid=$authorid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
	$authorlastfirst=$mysqli->real_escape_string($row["userlast"]) . ', ' . $mysqli->real_escape_string($row["userfirst"]);
	$authorsig=$mysqli->real_escape_string($row["authorsig"]);
	$position=$mysqli->real_escape_string($row["position"]);
	$_SESSION['authorid'] = $authorid;
	$_SESSION['authorlastfirst'] = $authorlastfirst;
//parse out recipname in case changed
$endfirstline=strpos($recipient, '\r\n');
$recipname=substr($recipient, 0, $endfirstline);
//refresh probs, meds
$lettproblems=$mysqli->real_escape_string($problist);
$lettmeds=$mysqli->real_escape_string($medlist);
//handle all CCs
include "$rwarepath/letters/incl/handleccs_incl.php";
//set update fields
//default set:
$updatefields = "lettmodifstamp=NOW(), letterdate=NOW(), status='$status', archiveflag='$archiveflag', salut='$salut',lettertype_id=$lettertype_id, lettdescr='$lettdescr', cctext='$cctext', recipname='$recipname', recipient='$recipient', authorid=$authorid, authorlastfirst='$authorlastfirst',  authorsig='$authorsig', position='$position'";

switch ($lettertype) {
	case 'clinic':
//		$updatefields .= ", lettresults='$lettresults', clinicdate='$clinicdateymd', lettBPsyst='$lettBPsyst', lettBPdiast='$lettBPdiast', lettWeight='$lettWeight', lettHeight='$lettHeight', lettproblems='$lettproblems', lettmeds='$lettmeds'";
		$updatefields .= ", lettresults='$lettresults', clinicdate='$clinicdateymd',lettproblems='$lettproblems', lettmeds='$lettmeds'";
        //only add prn
        $clinicaldata=array('lettBPsyst','lettBPdiast','lettWeight','lettHeight','letturine_prot','letturine_blood');
        foreach ($clinicaldata as $key => $fld) {
            if (${$fld}) {
                $fldval=${$fld};
                $updatefields.=", $fld='$fldval'";
            }
        }
		break;
	case 'discharge':
		$updatefields .= ", lettresults='$lettresults', reason='$reason', lettproblems='$lettproblems', lettmeds='$lettmeds'";
		break;
	case 'death':
		$updatefields .= ", lettresults='$lettresults', reason='$reason', deathcause='$deathcause', lettproblems='$lettproblems', lettmeds='$lettmeds'";
		break;
}
$sql= "UPDATE letterdata SET $updatefields WHERE letter_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//update ltext
$updatefields = "lettertextuid=$uid, modifstamp=NOW(), ltext='$ltext'";
$sql= "UPDATE lettertextdata SET $updatefields WHERE lettertext_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//----Wed 28 Jul 2010---- handle snippet/template
if ($post_newtemplateflag=='1' && $post_newtemplatename) {
	$insertfields="templateuid,templatestamp,templatename,templatetext";
	$insertvalues="$uid, NOW(),'$newtemplatename','$newtemplatetext'";
	$table="lettertemplates";
	//run INSERT
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
}
