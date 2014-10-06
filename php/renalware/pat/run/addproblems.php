<?php
//----Mon 25 Feb 2013----timeline
$table = "problemdata";
foreach ($_POST as $key => $value) {
		$valuefix = (substr($key,-4)=="date") ? fixDate($value) : $value ;
		${$key}=$mysqli->real_escape_string($valuefix);
}
$badstuff   = array("\r\n", "\n", "\r");
$pipe = '|';
$probsblock = str_replace($badstuff, $pipe, $post_problemblock);
$probsblockdata=explode("|",$probsblock);
foreach ($probsblockdata as $key => $value) {
	$newproblem=$mysqli->real_escape_string($value);
	$insertfields = "probzid, problem, probuser, probuid, probstamp,probdate";
	$insertvalues="$zid, '$newproblem', '$user', $uid, NOW(),CURDATE()";
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	$eventtype="NEW PROBLEM: $newproblem";
	$eventtext=$mysqli->real_escape_string($sql);
	include "../run/logevent.php";
	incrStat('problems',$zid);
	//set pat modifstamp
	stampPat($zid);
	showAlert("<b>' . $newproblem . '</b> has been added!");
}
//----Mon 25 Feb 2013----NEW add to timeline
//$values="$uid, '$user','$timelinecode', $zid, '$timelineadddate', '$timelinedescr', '$timelinetext'";
$sql= "SELECT problem FROM problemdata WHERE probzid=$zid ORDER BY problem_id";
$result = $mysqli->query($sql);
$numprobs = $result->num_rows;
$problist = "";
while($row = $result->fetch_assoc()){
	$problist .= $row['problem'] . "\n";
}
$timelinecode='PROBLEMS';
$timelinedescr="Probs list updated ($numprobs probs)";
$timelinetext=$problist;
include "$rwarepath/pat/run/insert_timeline.php";
