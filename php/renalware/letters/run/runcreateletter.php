<?php
//----Sun 28 Oct 2012----cctext
//----Mon 23 Jul 2012----clin fields work
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$zid = $_POST['zid'];
include "$rwarepath/letters/data/letterpatdata.php";
include "$rwarepath/letters/data/letterpatholdata.php";
include "$rwarepath/data/currentclindata.php";
include "$rwarepath/data/probs_meds.php";
//2011-12-18
foreach ($_POST as $key => $value) {
	$$key = (is_string($value)) ? $mysqli->real_escape_string($value) : $value ;
}
$letterdate = fixDate($letterdate);
$clinicdate_dmy = $clinicdate;
$clinicdateymd = fixDate($clinicdate_dmy);
if ($clinicdatetext)
	{
	$clinicdateymd = fixDate($clinicdatetext);
	}
//lett description
//Sun Aug 10 15:27:12 CEST 2008 no more freetext descrs allowed :)
//get from select
$sql= "SELECT letterdescr FROM letterdescrlist WHERE lettertype_id=$lettertype_id LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$lettdescr = $row["letterdescr"];
//author data
$authorid = $_POST["authorid"];
$sql= "SELECT userlast, userfirst, inits, authorsig, position FROM userdata WHERE uid=$authorid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$authorlastfirst=$mysqli->real_escape_string($row["userlast"]) . ', ' . $mysqli->real_escape_string($row["userfirst"]);
$authorsig=$mysqli->real_escape_string($row["authorsig"]);
$position=$mysqli->real_escape_string($row["position"]);
//typist -- should be user!
$typistid = $uid;
$sql= "SELECT inits FROM userdata WHERE uid=$uid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$typistinits=$row["inits"];
//----Fri 15 Nov 2013----set lettersite SESS regardless of savedetails
$_SESSION['lettersite'] = $lettersite;
	//set session details
	if ($post_savedetails = "y") {
		$_SESSION['letterdetails'] = TRUE;
		$_SESSION['clinicdate_dmy'] = $clinicdate_dmy;
		$_SESSION['lettertype_id'] = $lettertype_id;
		$_SESSION['lettdescr'] = $lettdescr;
		$_SESSION['authorid'] = $authorid;
		$_SESSION['authorlastfirst'] = $authorlastfirst;
	}
	else {
		$_SESSION['letterdetails'] = FALSE;
		unset($_SESSION['clinicdate_dmy']);
		unset($_SESSION['lettertype_id']);
		unset($_SESSION['lettdescr']);
		unset($_SESSION['authorid']);
		unset($_SESSION['authorlastfirst']);
	}
$salut="";
switch($recipienttype) {
case "patient":
	$recipient = $patreciptext; //from POST
	$salut = $mysqli->real_escape_string($patsalut); //from letterpatdata.php
	break;
case "gp":
	$recipient = $gpreciptext;
	$salut = $mysqli->real_escape_string($gpsalut);
	break;
case "otherrecip":
	$recipient = $otherreciptext;
	break;
}
//parse out recipname
$endfirstline=strpos($recipient, '\r\n');
$recipname=substr($recipient, 0, $endfirstline);
//refresh:
include "$rwarepath/data/probs_meds.php";
//next INSERT into LETTERS...
//fix template etc prn
$lettallergies=$mysqli->real_escape_string($allergies);
$problist=$mysqli->real_escape_string($problist);
$medlist=$mysqli->real_escape_string($medlist);
$pataddrhoriz=$mysqli->real_escape_string($pataddrhoriz);
//fix  etc
$patref = $mysqli->real_escape_string($patref);
$patlastfirst = $mysqli->real_escape_string($patlastfirst);
//default hospno=1
$letthospno=$hospno1;
//----Mon 05 Mar 2012----CCs here
$cctext="";
if ($recipienttype!="patient") {
		if ($ccflag=='Y') {
			$cctext = "\n\n\nPRIVATE AND CONFIDENTIAL\n\n" . $patblock . "\n\n\n\n\n";
		}
	}
if ($recipienttype!="gp") {
	$cctext .= "\n\n\n$gpblock";
	}
if ($defaultccs) {
	$cctext .= "\n\n\n$defaultccs";
	}
$cctext = $mysqli->real_escape_string($cctext);
//core INSERTS -- for all letters
$insertfields="letterzid, letthospno, lettuid, lettuser, lettaddstamp, lettmodifstamp, modalstamp, authorid, typistid, typistinits, letterdate, lettertype, status, lettertype_id, lettdescr, patlastfirst, authorlastfirst, authorsig, position,  recipname, recipient, patref, pataddr,salut,cctext";
$insertvalues="$zid, '$letthospno', $uid, '$user', NOW(), NOW(), '$modalcode', '$authorid', '$typistid', '$typistinits', '$letterdate', '$lettertype', 'DRAFT', '$lettertype_id', '$lettdescr', '$patlastfirst', '$authorlastfirst', '$authorsig', '$position',  '$recipname', '$recipient', '$patref', '$pataddrhoriz','$salut','$cctext'";
//add if clinic
if ($lettertype=="clinic") {
	$insertfields .= ", clinicdate, lettproblems, lettmeds, lettresults, lettallergies";
	$insertvalues .= ", '$clinicdateymd', '$problist', '$medlist', '$current_lettresults', '$lettallergies'";
        
    $clinicaldata=array('lettBPsyst','lettBPdiast','lettWeight','lettHeight','letturine_blood','letturine_prot');
    foreach ($clinicaldata as $key => $fld) {
        if (${$fld}) {
            $fldval=${$fld};
            $insertfields.=", $fld";
            $insertvalues.=", '$fldval'";
        }
    }
}
$sql= "INSERT INTO letterdata ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
$letter_id = $mysqli->insert_id;
//add to ltext
$sql= "INSERT INTO lettertextdata (lettertext_id, lettertextuid, lettertextzid, addstamp, modifstamp, ltext) VALUES ($letter_id, $uid, $zid, NOW(), NOW(), '$ltext')";
$result = $mysqli->query($sql);
//log the create w/ fulltext
$eventtype="CREATED $lettdescr [ID $letter_id] by $authorsig";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
header ("Location: $rwareroot/letters/editletter.php?zid=$zid&letter_id=$letter_id&stage=created");
