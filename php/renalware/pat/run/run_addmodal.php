<?php
//----Fri 28 Feb 2014----episodestatus
//----Tue 07 Jan 2014----handle new AKI episode with ARF/AKI modal change
//----Mon 25 Feb 2013----streamlining and handle modaltermdate
//Mon May 11 14:59:59 CEST 2009
//add new modal
$modalzid = $zid;
$modalcode = $mysqli->real_escape_string($_POST["modalcode"]);
$modalsitecode = $mysqli->real_escape_string($_POST["modalsitecode"]);
$modalnotes = $mysqli->real_escape_string($_POST["modalnotes"]);
$modaldate = $mysqli->real_escape_string($_POST["modaldate"]);
$modaldate = fixDate($modaldate);
$modaluser = $user;

//----Mon 25 Feb 2013----termdate on prev modal prn
$sql = "SELECT modal_id as lastmodal_id, modalcode as lastmodal FROM modaldata WHERE modalzid=$modalzid AND modaltermdate IS NULL ORDER BY modaldate DESC";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
    $row = $result->fetch_assoc();
    $lastmodal_id=$row["lastmodal_id"];
    $lastmodalcode=$row["lastmodal"];
    $sql = "UPDATE modaldata SET modaltermdate='$modaldate' WHERE modal_id=$lastmodal_id LIMIT 1";
    $result = $mysqli->query($sql);
    showAlert("Previous modality <b>$lastmodalcode</b> has been terminated!");
}
//set new
//add to problemdata
$insertfields="modalzid, modalcode, modalsitecode, modalstamp, modalnotes, modaluser,modaldate";
$values="$modalzid, '$modalcode', '$modalsitecode', NOW(), '$modalnotes', '$modaluser', '$modaldate'";
$table = "modaldata";
$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW MODALITY: $modalcode -- $modalsitecode";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
//end logging
//incr
incrStat('modals',$zid);
//update patientdata
$sql= "UPDATE patientdata SET modalcode='$modalcode', modalsite='$modalsitecode', modifstamp=NOW() WHERE patzid=$zid";
$mysqli->query($sql);
showAlert("<b>' . $modalcode . '</b> has been added!");
//need to make HD and PD if indicated...
//if HD
if (substr("$modalcode", 0, 2)=="HD") {
	//find out if HD record exists
	$sql = "SELECT hdpatzid FROM hdpatdata WHERE hdpatzid=$zid";
	$result = $mysqli->query($sql);
	$numrows=$result->num_rows;
	if (!$numrows) {
    	//need to make HD record
    	$insertfields="hdpatzid, hdaddstamp, hdmodifstamp, currsite";
    	$values="$zid, NOW(), NOW(), '$modalsitecode'";
    	$table = "hdpatdata";
    	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
    	$mysqli->query($sql);
    	showAlert("An <b>HD record</b> has been created for this patient!");
    	//update HDFLAG
    	$sql= "UPDATE patientdata SET hdflag='1', modifstamp=NOW() WHERE patzid=$zid";
    	$mysqli->query($sql);
    	//log the event
    	$eventtype="NEW HD RECORD created: $modalcode -- $modalsitecode";
    	$eventtext=$mysqli->real_escape_string($sql);
    	include "$rwarepath/run/logevent.php";
    	//end logging
	} //end create HD prn
	else {
    	//need to update sitecode only
    	$sql= "UPDATE hdpatdata SET hdmodifstamp=NOW(), currsite='$modalsitecode' WHERE hdpatzid=$zid";
    	$mysqli->query($sql);
    	showAlert("The HD site has been changed to <b>' . $modalsitecode . '</b>.");
    	//log the event
    	$eventtype="HD site changed to: $modalcode -- $modalsitecode";
    	$eventtext=$mysqli->real_escape_string($sql);
    	include "$rwarepath/run/logevent.php";
    	//end logging
	}
}
//for PD
if ($pdflag !="1" && substr("$modalcode", 0, 2)=="PD") {
	//need to make PD record
	$insertfields="pdpatzid, pdaddstamp, pdmodifstamp";
	$values="$zid, NOW(), NOW()";
	$table = "pdpatdata";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
	$mysqli->query($sql);
	showAlert("A <b>PD record</b> has been created for this patient!");
	//update PDFLAG
	$sql= "UPDATE patientdata SET pdflag='1', modifstamp=NOW() WHERE patzid=$zid";
	$mysqli->query($sql);
	//log the event
	$eventtype="NEW PD RECORD created: $modalcode";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//end logging
}
	//for Death
if ($modalcode=="death") {
	//find out if hdprofile
	$sql= "SELECT hdpatzid FROM hdpatdata WHERE hdpatzid=$zid LIMIT 1";
	$result=$mysqli->query($sql);
	$numrows = $result->num_rows;
	if ($numrows) {
		//need to remove from sched
		$sql= "UPDATE hdpatdata SET currsite=NULL, currsched=NULL,currslot=NULL, hdmodifstamp=NOW() WHERE hdpatzid=$zid";
		$mysqli->query($sql);
		showAlert("The <b>HD site/schedule/slot</b> have been cleared for this patient!");
		//log the event
		$eventtype="HD site/sched/slot data cleared due to death";
		$eventtext=$mysqli->real_escape_string($sql);
		include "$rwarepath/run/logevent.php";
		//end logging
		} //end update HD
	if ($esdstatus =="Current") {
		//need to discontinue
		$sql= "UPDATE renaldata SET esdstatus='Discontinued', esdmodifdate='$modaldate', renalmodifstamp=NOW() WHERE renalzid=$zid";
		$mysqli->query($sql);
		showAlert("The <b>ESA Status</b> is &rsquo;Discontinued&lsquo; for this patient!");
		//log the event
		$eventtype="ESA status changed due to death";
		$eventtext=$mysqli->real_escape_string($sql);
		include "$rwarepath/run/logevent.php";
		//end logging
		} //end change ESA prn
	//clear any access data
		$sql= "UPDATE renaldata SET accessCurrent=NULL, accessPlan=NULL, renalmodifstamp=NOW() WHERE renalzid=$zid";
		$mysqli->query($sql);
		showAlert("The <b>Access Plan</b> and <b>Current Access</b> for this patient are set to NULL!");
		//log the event
		$eventtype="Access Plan and Current Access set NULL due to death";
		$eventtext=$mysqli->real_escape_string($sql);
		include "$rwarepath/run/logevent.php";
		//end logging
	//set DOD and mark ccflag NO
	$sql= "UPDATE patientdata SET deathdate='$modaldate', modifstamp=NOW(), ccflag='N',ccflagdate=NOW() WHERE patzid=$zid";
	$result=$mysqli->query($sql);
	$numrows = $result->num_rows;
	showAlert("Patient date of death has been set!");
	//log the event
	$eventtype="Patient date of death/ccflag SET";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//terminate drugs
	$sql= "UPDATE medsdata SET modifstamp=NOW(), termdate='$modaldate', termflag=1, termuser='DEATH' WHERE medzid=$zid AND termdate is NULL";
	$result=$mysqli->query($sql);
	$numrows = $result->num_rows;
	showAlert("' . $numrows . ' drugs have been terminated for this patient!");
	//log the event
	$eventtype="$numrows drugs TERMINATED due to death";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//send to enterdeathdata
	echo '<p>Please use the <a href="renal/renal.php?zid=' . $zid . '&amp;vw=enterdeathdata">death data form</a> to enter cause of death information.</p>';
}
//transfer
if ($modalcode=="transferout") {
	if ($hdflag) {
		//need to remove from sched
		$sql= "UPDATE hdpatdata SET currsite='', currsched='', hdmodifstamp=NOW() WHERE hdpatzid=$zid";
		$mysqli->query($sql);
		showAlert("The <b>HD site and schedule</b> have been cleared for this patient!");
		//log the event
		$eventtype="HD data cleared due to death";
		$eventtext=$mysqli->real_escape_string($sql);
		include "$rwarepath/run/logevent.php";
		//end logging
	} //end update HD
	if ($esdstatus =="Current") {
		//need to discontinue
		$sql= "UPDATE renaldata SET esdstatus='Transfer Out', esdmodifdate='$modaldate', renalmodifstamp=NOW() WHERE renalzid=$zid";
		$mysqli->query($sql);
		showAlert("The <b>ESA Status</b> is &rsquo;Transfer Out&lsquo; for this patient!");
		//log the event
		$eventtype="ESA status changed due to transfer out";
		$eventtext=$mysqli->real_escape_string($sql);
		include "$rwarepath/run/logevent.php";
		//end logging
	} //end change ESA prn
}

//handle new AKI episode prn
if (strpos($modalcode,'ARF') or strpos($modalcode,'AKI')) {
    //see if existing AKI episode
    $sql = "SELECT aki_id FROM akidata WHERE akizid=$zid";
    $result = $mysqli->query($sql);
    $numrows=$result->num_rows;
    if (!$numrows) {
        $sql = "INSERT INTO akidata (akiuid,akiuser,akizid,akiadddate,episodedate,episodestatus) VALUES ($sess_uid, '$sess_user',$zid,CURDATE(),'$modaldate','Modality')";
        $result = $mysqli->query($sql);
        $newaki_id = $mysqli->insert_id;
        $sql = "UPDATE renaldata SET akiflag='Y',renalmodifstamp=NOW() WHERE renalzid=$zid LIMIT 1";
        $result = $mysqli->query($sql);
		showAlert("An AKI Episode has been created for this patient!");
		//log the event
		$eventtype="AKI Episode created via new modality";
		$eventtext="";
		include "$rwarepath/run/logevent.php";
    }
}

