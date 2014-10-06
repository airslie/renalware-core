<?php
//----Fri 28 Feb 2014----fix for missing basefilename var
//----Mon 10 Jun 2013----updated for sendCDAflag
include '../req/confcheckfxns.php';
$zid = $_POST['letterzid'];
$letter_id = $_POST['letter_id'];
$stage = $_POST['stage'];
$lettertype = $_POST['lettertype'];
//misc patient data
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/letters/data/letterpatdata.php";
include "$rwarepath/letters/data/letterpatholdata.php";
//----Tue 11 Jun 2013---- ?does not exist when depr?
//include "$rwarepath/letters/data/gpemailstatus.php";
include "$rwarepath/data/currentclindata.php";
//defaults
switch($stage) {
	case "refresh":
		$status="DRAFT";
		$archiveflag=false;
		include 'run/refreshdisch.php';
		echo "done";
		header ("Location: editletter.php?zid=$zid&letter_id=$letter_id");
		exit();
		break;
	case "draft":
		$status="DRAFT";
		$archiveflag=false;
		include 'run/refreshdisch.php';
		//log the event
			$eventtype="Letter ID $letter_id saved as DRAFT by $user";
			$eventtext=$mysqli->real_escape_string($updatefields);
			include "$rwarepath/run/logevent.php";
		header ("Location: $rwareroot/user/userletters.php");
		exit();
		break;
	case "typed":
		$status="TYPED";
		$archiveflag=false;
		include 'run/refreshdisch.php';
		include 'run/updatecompile.php';
		//set typeddate
		$sql= "UPDATE letterdata SET typeddate=NOW() WHERE letter_id=$letter_id";
		$result = $mysqli->query($sql);
		header ("Location: $rwareroot/user/userletters.php");
		break;
	case "archive":
		$status="ARCHIVED";
		$archiveflag='1';
		include 'run/refreshdisch.php';
		include 'run/archived.php';
		//refresh
		//for lastname
		include "$rwarepath/data/patientdata.php";
		include "$rwarepath/letters/data/letterdata.php";
		//----Mon 30 Jan 2012----we make HTML for all letters then route accordingly
		$EPRtype="Discharge";
		$ldate=$dischdateymd;
        //----Fri 28 Feb 2014----use basefilename
        $lastnameblankfix=str_replace(" ","-",$lastname); //for occasional spaces in lastname
        $lastnamefix=str_replace("'","",$lastnameblankfix); //for e.g. O'Reilly
		$basefilename=$letthospno.'_'.strtoupper($lastnamefix).'_'.str_replace("-","",$ldate).$letter_id;
		$htmlfilename=$basefilename.'.html';
        //----Fri 15 Nov 2013----$lettersite now set upstream not here
		//make HTML
		include('incl/renderhtml_incl.php');
		//create file for archives
		$handle = fopen("$HTMLarchivepath/$htmlfilename", "w"); //for archives
		fwrite($handle, $html);
		fclose($handle);
		if ($lettersite=="KCH") {
			//only KCH patients have HTML version sent to EPR
			$handle = fopen("$EPRpath/$EPRtype/$htmlfilename", "w");
			fwrite($handle, $html);
			fclose($handle);
		}
        //----Mon 10 Jun 2013---- cf letterpatdata.php
		if ($sendemailflag) {
			include 'incl/gpemailscript_incl.php';
        }
		if ($sendCDAflag) {
			include 'incl/gpCDAscript_incl.php';
		}
		//set reviewdate
		$sql= "UPDATE letterdata SET reviewdate=NOW() WHERE letter_id=$letter_id";
		$result = $mysqli->query($sql);
		//fix for typeddate when author archives
		$sql= "UPDATE letterdata SET typeddate=NOW() WHERE letter_id=$letter_id AND typeddate is NULL AND authorid=typistid";
		$result = $mysqli->query($sql);
		header ("Location: $rwareroot/user/userletters.php");
		break;
	case "delete":
		$confirm=$_POST['confirmdelete'];
		if ( $confirm=='Y' ) {
			include('run/delete.php');
			header ("Location: $rwareroot/user/userletters.php");
			break;
		} else {
			include 'run/refresh.php';
			header ("Location: editletter.php?zid=$zid&letter_id=$letter_id");
			exit();
			break;
		}
}