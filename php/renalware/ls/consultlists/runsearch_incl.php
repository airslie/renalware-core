<?php
//--Thu Apr 24 09:22:57 BST 2014--
$searchfix = $mysqli->real_escape_string($get_search);
$searchstring_lc = strtolower($searchfix); //nb hospno may be entered in lc as well
if(strstr($searchstring_lc,",")) //firstname entered and NOT hospno
	{
	$lastfirst = explode(",",$searchstring_lc);
	$ln = trim($lastfirst[0]);
	$fn = trim($lastfirst[1]);
	$where = "WHERE LOWER(lastname) LIKE '$ln%' AND LOWER(firstnames) LIKE '$fn%'";
	$showwhere="where name contains <b>$ln and $fn</b>";
	}
else
	{
		$strtest=ereg_replace("[A-Za-z]", "", $searchstring_lc); //only lc at this point gives NUMERIC only
		$searchtype = (strlen($strtest)) ? "hospno" : "lastname";
	//assume name
	$where = "WHERE LOWER(lastname) LIKE '$searchstring_lc%'";
	$showwhere="where the lastname starts with '<b>$searchstring_lc</b>'";
	if ($searchtype=="hospno") {
        $where="WHERE LOWER(hospno1) = '$searchstring_lc' OR LOWER(hospno2) = '$searchstring_lc' OR LOWER(hospno3) = '$searchstring_lc' OR LOWER(hospno4) = '$searchstring_lc' OR LOWER(hospno5) = '$searchstring_lc' OR nhsno='$searchstring_lc'";
		$showwhere="where any hospital number or NHS No matches <b>'$searchstring_lc'</b>";
		}
	}
$fields="patzid,hospno1,hospno2,hospno3,hospno4,lastname,firstnames,nhsno,sex,birthdate,age,modalcode";
$headers="ZID,$hosp1label,$hosp2label,$hosp3label,$hosp4label,lastname,firstname(s),NHS No,sex,DOB,age,modalcode";
$fieldsarray=explode(",",$fields);
$headersarray=explode(",",$headers);
	//build query
$db = "renalware";
$sql = "SELECT $fields FROM renalware.patientdata $where ORDER BY lastname, firstnames";
	//Execute query
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
	//Build Result String
$display_string = '<table class="tablesorter">';
$display_string .= "<tr>";
foreach ($headersarray as $key => $value) {
	$display_string .= "<th>$value</th>";
}
$display_string .= "<th>options</th><th>view (in new window)</th></tr>";
	while($row = $result->fetch_assoc())
		{
	$display_string .= "<tr>";
	foreach ($fieldsarray as $key => $value) {
		$display_string .= "<td>".$row["$value"]."</td>";
	}
	$display_string .= '<td class="links"><a href="pat/patient.php?vw=addconsultform&amp;zid='.$row["patzid"].'">add consult</a></td>';
	$display_string .= '<td class="links"><a href="pat/patient.php?vw=clinsumm&amp;zid='.$row["patzid"].'" target="new">view clin summ</a> (new window)</td>';
	$display_string .= "</tr>";
}
$display_string .= "</table>";
$toomany = ($numrows>25) ? "You may wish to limit your search and try again!" : "" ;
if ($numrows) {
	$resultsflag=TRUE;
	echo "<p class=\"header\">$numrows $siteshort patients found $showwhere. $toomany</p>";
	echo "<h3>Step 2: Select Desired Renalware Patient</h3>";
	echo $display_string;
} else {
	$resultsflag=FALSE;
	//echo "Sorry, no lastnames matching <tt>$lastname</tt> were found. <br><b>[$sql]</b>";
	echo "<p class=\"alert\">Sorry, no matches for patients matching <tt>$searchstring_lc</tt> in Renalware were found.</p>";	
}
echo '<p><a href="pat/addconsultpatient.php">Click here to add a new Consult Patient to Renalware</a> if the patient is not in the system.</p>';
