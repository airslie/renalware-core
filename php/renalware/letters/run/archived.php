<?php
//----Mon 23 Jul 2012----urine data capture plus BP/Wt streamlining
//Thu Dec  6 18:17:16 CET 2007 too bloody complicated!
//$letter_id = $_POST['letter_id'];
//refresh probs, meds
$lettproblems=$mysqli->real_escape_string($problist);
$lettmeds=$mysqli->real_escape_string($medlist);	
$elecsig="";
if ( $elecsigflag=='1' )
	{
	$elecsig="ELECTRONICALLY SIGNED BY AUTHOR\n on " . Date("D d M Y H:i:s");
	}
//complete cctext w/ any ccs
$sql = "SELECT recip_uid FROM letterccdata WHERE ccletter_id=$letter_id";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$cctext.="\n\n";
	$cc_uidlist="";
	while($row = $result->fetch_assoc())
		{
			$recipuid=$row["recip_uid"];
			$cc_uidlist.=",$recipuid";
		}
	//strip ,
	$cc_uidlist=substr($cc_uidlist,1);
	//get user info
	$sql = "SELECT user, userlast, userfirst, authorsig,position FROM userdata WHERE uid IN($cc_uidlist)";
	$result = $mysqli->query($sql);
	while($row = $result->fetch_assoc())
		{
			//add to ccblock
			$cctext.=$row["authorsig"].', '.$row["position"].', King&rsquo;s Renal Unit [electr CC]'."\n";
		}
	$result->close();
}
$wordcount=str_word_count($ltext);
$updatefields = "lettmodifstamp=NOW(), letterdate=NOW(), status='ARCHIVED', archiveflag='1', salut='$salut', lettdescr='$lettdescr', cctext='$cctext', recipname='$recipname', recipient='$recipient', authorid=$authorid, authorlastfirst='$authorlastfirst',  authorsig='$authorsig', position='$position', lettertype_id=$lettertype_id, printstage=1, elecsig='$elecsig', wordcount=$wordcount";
if ($lettertype!='simple' )
	{
	$updatefields .= ", lettresults='$lettresults', clinicdate='$clinicdateymd', reason='$reason', deathcause='$deathcause', lettproblems='$lettproblems', lettmeds='$lettmeds'";
    $clinicaldata=array('lettBPsyst','lettBPdiast','lettWeight','lettHeight','letturine_blood','letturine_prot');
    foreach ($clinicaldata as $key => $fld) {
        if (${$fld}) {
            $fldval=${$fld};
            $updatefields.=", $fld='$fldval'";
        }
    }
}  
$tables = 'letterdata';
$where = "WHERE letter_id=$letter_id";
$sql= "UPDATE $tables SET $updatefields $where LIMIT 1";
$result = $mysqli->query($sql);
//update ltext
$updatefields = "lettertextuid=$uid, modifstamp=NOW(), archivestamp=NOW(), ltext='$ltext'";
$sql= "UPDATE lettertextdata SET $updatefields WHERE lettertext_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//NEW 19 may 09
$sql="INSERT INTO letterindex (letterindex_id, letterzid, letterhospno, letteruid, letteruser, createstamp, archivestamp, authorid, typistid, typistinits, lettertype, clinicdate, admissionid, admdate, dischdate, letterdate, createdate, typeddate, reviewdate, printdate, archivedate, wordcount, lettdescr_id, lettdescr, patlastfirst, authorlastfirst, recipname, modalstamp, lettertext) SELECT $letter_id, l.letterzid, l.letthospno, l.lettuid, l.lettuser, l.lettaddstamp, NOW(), l.authorid, l.typistid, l.typistinits, l.lettertype, l.clinicdate, l.admissionid, l.admdate, l.dischdate, l.letterdate, date(lettaddstamp), l.typeddate, l.reviewdate, l.printdate, l.letterdate, l.wordcount, l.lettertype_id, l.lettdescr, l.patlastfirst, l.authorlastfirst, l.recipname, l.modalstamp, ltext FROM letterdata l LEFT JOIN letterindex i ON l.letter_id=i.letterindex_id JOIN lettertextdata ON letter_id=lettertext_id WHERE letter_id=$letter_id LIMIT 1;";
$result = $mysqli->query($sql);
//log the event
$eventtype="LETTER ADDED TO INDEX";
$eventtext="";
include "$rwarepath/run/logevent.php";
//end logging

//echo "$sql";
//update currentclindata
//only if entered!
include "$rwarepath/letters/data/letterdata.php";
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
//log the event
$eventtype="NEW CLINIC LETTER $fldslogged DATA ADDED";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
//end logging
if ( $lettBPsyst or $lettWeight )
{
	//insert into BPWT
		$bpwtzid=$zid;
		$bpwtdate=$clinicdateymd;
		$bpsyst=$lettBPsyst;
		$bpdiast=$lettBPdiast;
		$weight=$lettWeight;
		$insertfields="bpwtzid, bpwtuid, bpwtstamp,lett_id, bpwttype, bpwtmodal, bpwtdate, bpsyst, bpdiast, weight"; 
		$values="$zid, $uid, NOW(), $letter_id, '$lettdescr','$modalcode', '$bpwtdate', '$bpsyst', '$bpdiast', '$weight'";
        if ($lettWeight && $lettHeight) {
            $insertfields.=", height, BMI";
            $values.=",'$lettHeight','$newBMI'";
        }
        if ($letturine_blood or $letturine_prot) {
            $insertfields.=", urine_blood, urine_prot, urinedate";
            $values.=",'$letturine_blood','$letturine_prot','$clinicdateymd'";
        }
        
		$sql= "INSERT INTO bpwtdata ($insertfields) VALUES ($values)";
		$result = $mysqli->query($sql);
		//log the event
		$eventtype="NEW $fldslogged DATA FROM $lettdescr LETTER ADDED";
		$eventtext=$mysqli->real_escape_string($sql);
		include "$rwarepath/run/logevent.php";
		//end logging
}
//update admission prn
if ( $lettertype=='discharge' or $lettertype=='death')
	{
	$doctype = ($lettertype=="death") ? "Death Notif" : "Disch Summ" ;
	$dischstatus="$doctype ID $letter_id (ARCHIVED) by $authorsig";
	$sql= "UPDATE admissiondata SET dischsummstatus='$dischstatus', dischsummdate=NOW(), dischsummflag=1 WHERE admission_id=$admissionid LIMIT 1";
	$result = $mysqli->query($sql);
	}
//compile the whole letter
include ('incl/compiletext.php');
$letterfulltext=$mysqli->real_escape_string($letterfulltext);
//update letter with fulltext field
$sql= "UPDATE lettertextdata SET lfulltext='$letterfulltext' WHERE lettertext_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//log the event w/ fulltext
	$eventtype="ARCHIVED $lettdescr [ID $letter_id] by $authorsig";
	$eventtext=$letterfulltext;
	include "$rwarepath/run/logevent.php";
	//end logging
	//incr
	incrStat('letters',$zid);
//Mon Aug  4 13:48:38 CEST 2008
//mark CCs as sent
$sql = "UPDATE letterccdata SET ccstatus='sent', sentstamp=NOW() WHERE ccletter_id=$letter_id";
$result = $mysqli->query($sql);
//set the user now
//mark CCs as sent
$sql = "UPDATE letterccdata, userdata SET ccuser=user WHERE ccletter_id=$letter_id AND cc_uid=uid";
$result = $mysqli->query($sql);
