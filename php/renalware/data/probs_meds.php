<?php
//for letters:
$sql= "SELECT clinAllergies FROM renaldata WHERE renalzid=$zid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$clinAllergies=$row["clinAllergies"];
$allergies = ($clinAllergies) ? $clinAllergies : 'NONE RECORDED' ;
//simple current meds list
$sql= "SELECT drugname, dose, route, freq, DATEDIFF(CURDATE(),adddate) as rxdays, adddate FROM medsdata WHERE medzid=$zid AND termflag=0 ORDER BY drugname";
$result = $mysqli->query($sql);
$nummeds = $result->num_rows;
$medlist = ""; //set null
$medlistv2 = ""; //set null
$changedflag=FALSE;
while($row = $result->fetch_assoc()) {
//	$recentchange = ($row["rxdays"]<15) ? TRUE : FALSE ;
	if ($row["rxdays"]<15 && $row["adddate"]) {
		$changedflag=TRUE; //to display *explanation below meds
		$medlist .= "<b>".$row['drugname'] . " " . $row['dose'] . " " . $row['route'] . " " . $row['freq'] . "</b>* [".dmy($row["adddate"])."]\n";
	} else {
		$medlist .= $row['drugname'] . " " . $row['dose'] . " " . $row['route'] . " " . $row['freq'] . "\n";
	}
}
if ($changedflag) {
	$medlist .= "<small>* added or dose changed within last 14 days</small>";
}
//get numhistmeds
$sql= "SELECT drugname FROM medsdata WHERE medzid=$zid";
$result = $mysqli->query($sql);
$numhistmeds = $result->num_rows;
//get probs
$sql= "SELECT problem FROM problemdata WHERE probzid=$zid ORDER BY problem_id";
$result = $mysqli->query($sql);
$numprobs = $result->num_rows;
$problist = "";
while($row = $result->fetch_assoc()){
	$problist .= $row['problem'] . "\n";
}
