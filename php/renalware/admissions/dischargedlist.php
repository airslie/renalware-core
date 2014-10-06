<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Discharged Patients List";
include "$rwarepath/navs/topsimplenav.php";
?>
<!--content here-->
<div id="navdiv">
    <p>
    <a class="ui-state-default" style="color: #333;" href="admissions/admissionslist.php?status=curr">Current Inpatients and Discharge Form</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: #333;" href="admissions/dischargedlist.php?summ=create">Discharged Patients without ARCHIVED Disch Summaries</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: #333;" href="admissions/dischargedlist.php?summ=create&amp;orderby=patlastfirst">w/o Disch Summaries--order by name</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: #333;" href="admissions/dischargedlist.php?dest=rip">Deceased Patients</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: #333;" href="admissions/dischargedlist.php">All Discharged Patients</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: #333;" href="admissions/dischargesummlist.php">Outstanding Disch Summs</a>&nbsp;&nbsp;
    </p>
</div>
<?php
//get total
$q = ""; //default
$limit = 100; // How many results should be shown at a time
$scroll = '10'; // How many elements to the record bar are shown at a time
$where = ""; // default
$displaytext = "$siteshort discharged patients"; //default
	$where = "WHERE admittedflag=0";
	$q="admittedflag=0&amp;";
	$displaytext = "<b>discharged</b> renal patients";
if ($get_summ=="create") {
	$where .=" AND dischsummstatus='create'";
	$q="admittedflag=0&amp;summ=create&amp;";
}
if ($get_dest=="rip") {
	$where .=" AND dischdest='Death'";
	$q="admittedflag=0&amp;dest=rip&amp;";
}

$xnav_sql = "SELECT admission_id FROM admissiondata $where";
$xnavresult = $mysqli->query($xnav_sql);
$numtotal=$xnavresult->num_rows;
//include xnav calc
$orderby = "ORDER BY dischdate DESC, lastname, firstnames";
if ($get_orderby=="patlastfirst") {
	$orderby = "ORDER BY lastname, firstnames";
	$q="admittedflag=0&amp;summ=create&amp;orderby=patlastfirst&amp;";
}

include('../navs/xnavstartasc.php');
$fields = "admission_id, admzid, admhospno1, admmodal, admdate, admward, consultant, admtype, dischdate, dischdest, admdays, datediff(NOW(), dischdate) as days_since_disch, lastname, firstnames, birthdate, sex, dischsummstatus";
//see above for list WHEREs
$sql= "SELECT $fields FROM admissiondata LEFT JOIN patientdata ON (patzid=admzid) $where $orderby LIMIT $start, $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
	echo "<p class=\"header\">$numtotal $displaytext ($numrows displayed). ";
	include "$rwarepath/navs/xnavbar.php";
	echo "</p>
	<table class=\"tablesorter\"><thead><tr>
	<th>$hosp1label</th>
	<th>patient</th>
	<th>sex</th>
	<th>DOB</th>
	<th>adm modal</th>
	<th>adm date</th>
	<th>adm ward</th>
	<th>consultant</th>
	<th>discharged</th>
	<th>days ago</th>
	<th>disch summ status</th>
	</tr></thead><tbody>";
	while ($row = $result->fetch_assoc()) {
		$bg = '#ffff00';
		$admission_id=$row["admission_id"];
		$dischsummlink = '<a href="letters/createdischarge.php?zid=' . $row["admzid"] .'&amp;admissionid='.$admission_id.'">create Disch Summ</a>';
		//use dischsummstatus to determine link :) -- create/edit/view
		if ($row["dischdest"]=="Death") {
			$bg = '#f60';
			$dischsummlink = '<a href="letters/createdischarge.php?zid=' . $row["admzid"] .'&amp;admissionid='.$admission_id.'">create <b>Death Notif</b>!</a>';
		}
		if($row["dischsummstatus"]!='create')
		{
			$dischsummlink = $row["dischsummstatus"];
			//deflag those w/ summs; mark dead
			$bg = ($row["dischdest"]=="Death") ? '#ccc' : '#fff' ;
		}
		$showdisch = dmy($row["dischdate"]) . ' to ' . $row["dischdest"]; //default when discharged
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["admzid"] . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["admzid"] . '">' . $row["admhospno1"] . '</a>';
		echo "<tr bgcolor=\"$bg\">
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["sex"] . "</td>
		<td>" . dmy($row["birthdate"]) . "</td>
		<td>" . $row["admmodal"] . "</td>
		<td>" . dmy($row["admdate"]) . ' <a href="admissions/updateadmission.php?admid=' . $row["admission_id"] . "\">edit</a></td>
		<td>" . $row["admward"] . "</td>
		<td>" . $row["consultant"] . "</td>
		<td>" . $showdisch."</td>
		<td>" . $row["days_since_disch"] . "</td>
		<td>" . $dischsummlink . "</td>
		</tr>";
		}
	echo '</tbody></table>';
//paging stuff
include('../navs/xnavbar.php');
include '../parts/footer.php';
?>