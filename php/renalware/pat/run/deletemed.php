<?php
//----Mon 25 Feb 2013----timeline
//Thu May 14 23:50:42 BST 2009
$deletemed_id = $_POST["medsdata_id"];
if ($_POST['confirmdelete'])
	{
	$sql="SELECT drugname, route, freq, esdflag FROM medsdata WHERE medsdata_id=$deletemed_id";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
		$termdrug =  $row['drugname'] . " " .  $row['route'] . " " .  $row['freq'];
		$esdmedflag = $row['esdflag'];
	//we only set termdate NOW not delete
	$sql= "UPDATE medsdata SET termdate=NOW(), termflag=1, modifstamp=NOW(), termuser='$user' WHERE medsdata_id=$deletemed_id";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Patient $zid: Med ID $deletemed_id ($termdrug) deleted";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	if ($esdmedflag==1) //update ESA info
		{
		//get units from dose
		$sql= "UPDATE esddata SET esdstatus='Discontinued', esdregime = 'Discontinued', unitsperweek = '0',esdmodifdate=NOW(), unitsperwkperkg='0' WHERE esdzid=$zid";
		$result = $mysqli->query($sql);
		//log the event... WTH
		$eventtype="ESA TERMINATION -- $termdrug $dose $route $freq";
		include "$rwarepath/run/logevent.php";
		//end logging
		}
	//incr
	decrStat('meds',$zid);
	//set pat modifstamp
	stampPat($zid);
    //----Mon 25 Feb 2013----NEW add to timeline
    $sql= "SELECT drugname, dose, route, freq, DATEDIFF(CURDATE(),adddate) as rxdays, adddate FROM medsdata WHERE medzid=$zid AND termflag=0 ORDER BY drugname";
    $result = $mysqli->query($sql);
    $nummeds = $result->num_rows;
    $medlist = ""; //set null
     while($row = $result->fetch_assoc()) {
     	$medlist .= $row['drugname'] . " " . $row['dose'] . " " . $row['route'] . " " . $row['freq'] . "\n";
    }
    $timelinecode='MEDS';
    $timelineadddate=$adddate;
    $timelinedescr="Meds list deletion ($nummeds meds)";
    $timelinetext=$medlist;
    include "$rwarepath/pat/run/insert_timeline.php";
    showAlert("$eventtype");
	}
else
	{
	//confirmdelete not checked
	echo '<p class="alert">Sorry, you did not confirm the DELETE or something else went wrong.</p>';
	}
?>