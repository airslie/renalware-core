<?php
//versionstamp Mon Oct 20 16:18:59 IST 2008
include '../req/confcheckfxns.php';
// Retrieve data from Query String
$ajaxsearchfix = $mysqli->real_escape_string($_GET["ajaxsearch"]);
$name_or_hospno = strtolower($ajaxsearchfix); //nb hospno may be entered in lc as well
if(strstr($name_or_hospno,",")) //firstname entered and NOT hospno
	{
	$lastfirst = explode(",",$name_or_hospno);
	$ln = trim($lastfirst[0]);
	$fn = trim($lastfirst[1]);
	$where = "WHERE LOWER(lastname) LIKE '$ln%' AND LOWER(firstnames) LIKE '$fn%'";
	$showwhere="where name contains <b>$ln and $fn</b>";
	}
else
	{
		$strtest=ereg_replace("[A-Za-z]", "", $name_or_hospno); //only lc at this point gives NUMERIC only
		$searchtype = (strlen($strtest)>0) ? "hospno" : "lastname";
	//assume name
	$where = "WHERE LOWER(lastname) LIKE '$name_or_hospno%'";
	$showwhere="where the lastname starts with '<b>$name_or_hospno</b>'";
	if ($searchtype=="hospno") {
		$where = "WHERE LOWER(hospno1) = '$name_or_hospno'";
		$showwhere="where $hospno1label number matches <b>'$name_or_hospno'</b>";
		}
	}
$fields="patzid,hospno1,lastname,firstnames,sex,birthdate,age,modalcode";
$headers="ZID,KCH No,lastname,firstname(s),sex,DOB,age,modalcode";
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
	echo "<p class=\"alertsmall\">Sorry, no matches for patients matching <tt>$name_or_hospno</tt> in Renalware were found.</p>";	
}
echo '<p><a class="ui-state-default" style="color: green;" href="pat/addconsultpatient.php">Use this simplified form to add a new Consult Patient to Renalware</a></p>';
?>