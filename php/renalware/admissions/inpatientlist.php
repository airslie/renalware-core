<?php
//----Tue 19 Feb 2013----
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Inpatients List";
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
echo '<p>
    <a class="ui-state-default" style="color: #333;" href="admissions/admissionslist.php?status=disch">View Discharged Only</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: #333;" href="admissions/dischargesummlist.php">Discharge Summary Mgt</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: green" href="admissions/wardreport.php" target="new">Current Ward Report</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: green" href="admissions/fortnightly.php" target="new">Fortnight Admission Rpt</a>&nbsp;&nbsp;
</p>';
//run discharge
if($_POST["mode"]=="dischargepat")
	{
	//update admissions
	$dest = trim($dest_select . " " . str_replace("other destin","",$dest_text));
	$sql= "UPDATE admissiondata SET admstatus='Discharged', dischdest='$dest', dischdate='$dischdate', admittedflag=0, dischsummstatus='create', admdays=(DATEDIFF(dischdate,admdate)+1) WHERE admission_id=$admissid";
	$result = $mysqli->query($sql);
	$eventtype="DISCHARGE: $dest";
	//need to set RID
	$zid=$dischzid;
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	echo "<p class=\"alert\">Patient ".strtoupper($firstlast)." has been discharged to $dest!</p>";
	}
//get total
$displaytext = "$siteshort inpatients"; //default
$fields = "admission_id, admzid, admhospno1, admmodal, admdate, admward, ward, currward, consultant, admtype, reason, dischdate, dischdest, admstatus, if(admittedflag=0, admdays, datediff(NOW(), admdate)) as LOS, lastname, firstnames, birthdate, sex, age, (SELECT count(admzid) FROM admissiondata WHERE admzid=patzid) as count_admissions, dischsummstatus";
$orderby = "ORDER BY lastname, firstnames"; //default
$sql= "SELECT $fields FROM admissiondata JOIN patientdata ON (patzid=admzid) LEFT JOIN wardlist ON admward=wardcode WHERE admittedflag=1 $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else
	{
	echo "<div id=\"datatablediv\">
    <p class=\"header\">$numrows $displaytext. (Click on headers to sort)</p>";
	echo '<table class="datatable" style="width: 100%"><thead>
	<tr>
	<th>'.$hosp1label.'</th>
	<th>patient</th>
	<th>sex</th>
	<th>age</th>
	<th>DOB</th>
	<th>modality</th>
	<th>Adm Date</th>
	<th>Curr Ward</th>
	<th>consultant</th>
	<th>LOS</th>
	<th>adm hist</th>';
	if ($wardclerkflag) {
		echo '<th>wardclerk options</th>';
	}
	echo '</thead></tr><tbody>';
	//dates for popup?
	$today_1 = date("d/m/Y", mktime(0, 0, 0, date("m")  , date("d")-1, date("Y")));
	while ($row = $result->fetch_assoc()) {
		$admission_id=$row["admission_id"];
		$showdisch = "<a class=\"tg\" onclick=\"toggl('adm$admission_id');\">discharge</a>";
		$canceldisch = '<a class="ui-state-default" style="color: red;" href="javascript:toggl(\'adm'.$admission_id.'\');">cancel disch</a>';
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["admzid"] . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["admzid"] . '">' . $row["admhospno1"] . '</a>';
		$editlink = ($wardclerkflag) ? ' <a href="admissions/updateadmission.php?admid=' . $row["admission_id"] . '">upd/transfer</a>' : '' ;
		$deletelink = ($wardclerkflag) ? ' <a href="admissions/deleteadmission.php?admid=' . $row["admission_id"] . '">delete/cancel</a>' : '' ;
		echo '<tr>';
		echo '<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . $row["sex"] . '</td>
		<td>' . $row["age"] . '</td>
		<td>' . dmyyyy($row["birthdate"]) . '</td>
		<td>' . $row["admmodal"] . '</td>
		<td>' . dmyyyy($row["admdate"]) . '</td>
		<td>' . $row["currward"] . '</td>
		<td>' . $row["consultant"] . '</td>
		<td>' . $row["LOS"] . '</td>
		<td><a href="pat/patient.php?vw=admissions&amp;zid=' . $row["admzid"] . '">' . $row["count_admissions"] . ' adms</a></td>';
		if ($wardclerkflag) {
			echo '<td>' . $editlink .'&nbsp;&nbsp;' . $deletelink .'&nbsp;&nbsp;'. $showdisch .'<form id="adm'.$admission_id.'" style="display:none;padding:3px;background-color:#ff9;" action="admissions/inpatientlist.php" method="post">
		<input type="hidden" name="mode" value="dischargepat" />
		<input type="hidden" name="admissid" value="' . $admission_id .'" />
		<input type="hidden" name="firstlast" value="' .$row["firstnames"] . ' '.$row["lastname"] .'" />
		<input type="hidden" name="dischzid" value="' . $row["admzid"] .'" /> Discharge '.$row["firstnames"].' '.$row["lastname"] .' to <select name="dest_select">
		<option value="">Destination...</option>
		<option value="Home">Home</option>
		<option value="ITU">ITU</option>
		<option value="Other Ward">Other Ward (non-Renal)</option>
		<option value="Other Hosp">Other Hosp</option>
		<option value="Ward">Ward (Specify)</option>
		<option value="Death">Death</option>
		<option value="Other">Other (Specify)</option></select> 
		<input type="text" name="dest_text" size="12" title ="other destin" /> on 
		<input type="text" name="dischdate" size="12" value="'.$today_1.'" class="datepicker" /> 
		<input type="submit" style="color: green;" value="discharge" /> '. $canceldisch .'</form></td>';
		}
		echo '</tr>';
	}
	echo '</tbody></table>
    </div>';
	}
 include '../parts/footer.php';
?>
<script>
$('.datatable').dataTable( {
	"bPaginate": false,
	"bJQueryUI": false,
	"bFilter": true,
	"aaSorting": [[ 1, "asc" ]],
	"iDisplayLength": 100,
	"bSort": true,
	"bInfo": true,
	"bAutoWidth": false,
	"bStateSave": true
} );
</script>