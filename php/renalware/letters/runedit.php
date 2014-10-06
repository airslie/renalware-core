<?php
//----Fri 15 Nov 2013----$lettersite now set in letterdata.php
//----Fri 07 Jun 2013----new if CDA flag for script ----Mon 10 Jun 2013----streamlining
//----Sun 08 Jan 2012----NOTE: revised/streamlined for GP email PDFs
include '../req/confcheckfxns.php';
$zid = $_POST['letterzid'];
$letter_id = $_POST['letter_id'];
$stage = $_POST['stage'];
$lettertype = $_POST['lettertype'];
//misc patient data
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/letters/data/letterpatdata.php";
include "$rwarepath/letters/data/letterpatholdata.php";
include "$rwarepath/data/currentclindata.php";
//defaults
switch($stage) {
	case "refresh":
		$status="DRAFT";
		$archiveflag=false;
		include 'run/refresh.php';
		header ("Location: editletter.php?zid=$zid&letter_id=$letter_id");
		exit();
		break;
	case "draft":
		$status="DRAFT";
		$archiveflag=false;
		include 'run/refresh.php';
		//log the event
		$eventtype="Letter ID $letter_id saved as DRAFT by $user";
		$eventtext=$mysqli->real_escape_string($updatefields);
		include "$rwarepath/run/logevent.php";
		header ("Location: ../user/userletters.php");
		exit();
		break;
	case "typed":
		$status="TYPED";
		$archiveflag=false;
		include 'run/refresh.php';
		include 'run/updatecompile.php';
		//set typeddate
		$sql= "UPDATE letterdata SET typeddate=NOW() WHERE letter_id=$letter_id";
		$result = $mysqli->query($sql);
		header ("Location: ../user/userletters.php");
		break;
	case "archive":
		$status="ARCHIVED";
		$archiveflag='1';
		include 'run/refresh.php';
		include 'run/archived.php';
		//refresh
		//for lastname
		include "$rwarepath/data/patientdata.php";
		include "$rwarepath/letters/data/letterdata.php";
        //----Fri 15 Nov 2013----NB lettersites now set in letterdata.php
        // //----Mon 30 Jan 2012----we make HTML for all letters then route accordingly
        // $lettersite='KCH'; //default
        // if (strpos($lettdescr, 'QEH)')) { $lettersite='qeh'; }
        // if (strpos($lettdescr, 'DVH')) { $lettersite='dvh'; }
		//detect type/destination
		//default
		$EPRtype="Clinic";
		$ldate = $clinicdateymd;
		if ($lettertype=="simple") {
			$EPRtype="General";
			$ldate=fixDate($letterdate);
		}
        $lastnameblankfix=str_replace(" ","-",$lastname); //for occasional spaces in lastname
        $lastnamefix=str_replace("'","",$lastnameblankfix); //for e.g. O'Reilly
		$basefilename=$letthospno.'_'.strtoupper($lastnamefix).'_'.str_replace("-","",$ldate).$letter_id;
		$htmlfilename=$basefilename.'.html';
		//make HTML
		include('incl/renderhtml_incl.php');
		//create file for archives
		$handle = fopen("$HTMLarchivepath/$htmlfilename", "w"); //for archives
		fwrite($handle, $html);
		fclose($handle);
		//detect site
		if ($lettersite=="KCH") {
			//only KCH patients have HTML version sent to EPR
			$handle2 = fopen("$EPRpath/$EPRtype/$htmlfilename", "w");
			fwrite($handle2, $html);
			fclose($handle2);
		}
        //----Mon 10 Jun 2013----these now use field content from practicecodes tbl cf letterpatdata.php
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
		header ("Location: ../user/userletters.php");
		break;
	case "delete":
		$confirm=$_POST['confirmdelete'];
		if ( $confirm=='Y' ) {
			include('run/delete.php');
			header ("Location: ../user/userletters.php");
			break;
		} else {
			include 'run/refresh.php';
			header ("Location: editletter.php?zid=$zid&letter_id=$letter_id");
			exit();
			break;
		}
}
