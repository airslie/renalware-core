<?php
//----Tue 19 Feb 2013----
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Admissions List";
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
echo '<div class="buttonsdiv">
<a style="color: #333;" href="admissions/inpatientlist">Current Inpats and Discharge Form</a> 
<a style="color: #333;" href="admissions/admissionslist.php?status=disch">Discharged Only</a> 
<a style="color: #333;" href="admissions/dischargesummlist.php">Discharge Summ Mgt</a> 
<a style="color: green; background: white;" href="admissions/wardreport.php" >Print Curr Inpatients Report</a> 
<a style="color: green; background: white;" href="admissions/fortnightly.php" >Print Last Fortnight&rquo;s Admissions</a> 
</div>';
//get total
$q = ""; //default
$displaycount=50;
$limit = $displaycount; // How many results should be shown at a time
$scroll = '10'; // How many elements to the record bar are shown at a time
$where = ""; // default
$displaytext = "$siteshort admissions"; //default
if($_GET["status"]=="curr")
	{
	$limit = 70;
	$where = "WHERE admittedflag=1";
	$q="admittedflag=1&amp;";
	$displaytext = "current renal inpatients";
	}
if($_GET["patsearch"])
	{
	$limit = 70;
	$patsearch = $_GET["patsearch"];
	$where = "WHERE (lower(lastname) LIKE lower('$patsearch%') OR admhospno1 = '$patsearch')";
	$displaytext = "admitted patients matching <b>$patsearch</b>";
	}
if($_GET["status"]=="disch")
	{
	$limit = 200;
	$where = "WHERE admittedflag=0";
	$q="admittedflag=0&amp;";
	$displaytext = "<b>discharged</b> renal patients";
	}
if($_GET["status"]=="create")
	{
	$limit = 70;
	$where = "WHERE dischsummstatus='create'";
	$displaytext = "discharged renal patients without TTAs";
	}
if($_GET["status"]=="edit")
	{
	$limit = 70;
	$where = "WHERE dischsummstatus='edit'";
	$displaytext = "unfinished TTAs";
	}
if($_GET["wardcode"])
	{
	$limit = 70;
	$ward=$_GET['wardcode'];
	$where = "WHERE admward='$ward'";
	$q="admward=$ward&amp;";
	$displaytext = "admitted to $ward";
	}
$xnav_sql = "SELECT admission_id FROM admissiondata $where";
$xnavresult = $mysqli->query($xnav_sql);
$numtotal=$xnavresult->num_rows;
//include xnav calc
include('../navs/xnavstartasc.php');
$displaytime = date("D j M Y  G:i:s");
$fields = "admission_id, admzid, admhospno1, admmodal, admdate, admward, consultant, admtype, reason, dischdate, dischdest, admstatus, if(admittedflag=0, admdays, datediff(NOW(), admdate)) as LOS, lastname, firstnames, birthdate, sex, (SELECT count(admzid) FROM admissiondata WHERE admzid=patzid) as count_admissions, dischsummstatus";
$orderby = "ORDER BY admdate DESC, lastname, firstnames";
//see above for list WHEREs
$sql= "SELECT $fields FROM admissiondata LEFT JOIN patientdata ON (patzid=admzid) $where $orderby LIMIT $start, $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
$showrows = ($numrows) ? "$numtotal $displaytext ($numrows displayed). Click on headers to sort displayed data." : "There are no $displaytext" ;
echo "<p class=\"header\">$showrows</p>";
	if ($numrows) {
		include "$rwarepath/navs/xnavbar.php";
		$theaders='<th>HospNo</th>
		<th>patient</th>
		<th>sex</th>
		<th>DOB</th>
		<th>admmodal</th>
		<th>adm date</th>
		<th>adm ward</th>
		<th>consultant</th>
		<th>discharged</th>
		<th>adm status</th>
		<th>LOS</th>
		<th>adm hist</th>';
		if ($wardclerkflag) {
			$theaders.= '<th>options</td>';
		}
	echo '<table class="datatable" style="width: 100%"><thead><tr>'.$theaders.'</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$admission_id=$row["admission_id"];
		//use dischsummstatus to determine link :) -- create/edit/view
		$showdisch = dmy($row["dischdate"]) . ' to ' . $row["dischdest"]; //default when discharged
		if ($row["admstatus"]=="Admitted")
			{
			$showdisch="";
			$dischsummlink="";
			}
		$trclass = ($row["admstatus"]=="Admitted") ? "trhilite" : "" ;
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["admzid"] . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["admzid"] . '">' . $row["admhospno1"] . '</a>';
		echo '<tr class="'.$trclass.'">';
		echo "<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["sex"] . "</td>
		<td>" . dmyyyy($row["birthdate"]) . "</td>
		<td>" . $row["admmodal"] . "</td>
		<td>" . dmyyyy($row["admdate"]) . '</td>
		<td>' . $row["admward"] . "</td>
		<td>" . $row["consultant"] . "</td>
		<td>$showdisch</td>
		<td>" . $row["admstatus"] . "</td>
		<td>" . $row["LOS"] . "</td>
		<td><a href=\"pat/patient.php?vw=admissions&amp;zid=" . $row["admzid"] . "\">" . $row["count_admissions"] . " adm</a></td>";
		if ($wardclerkflag) {
			echo '<td><a href="admissions/updateadmission.php?admid=' . $row["admission_id"] . '">edit</a>&nbsp;&nbsp;<a href="admissions/deleteadmission.php?admid=' . $row["admission_id"] . '">delete</a></td>';
		}
        echo "</tr>";
		}
	echo '</tbody></table>';
	include('../navs/xnavbar.php');
	}
//paging stuff
include '../parts/footer.php';
?>
<script>
$('.datatable').dataTable( {
	"bPaginate": false,
	"bLengthChange": false,
	"bJQueryUI": false,
	//"sPaginationType": "full_numbers",
	"bFilter": false,
	"aaSorting": [[ 1, "asc" ]],
	"iDisplayLength": 100,
	//"aLengthMenu": [[10,20,40, 50, 100, -1], [10,20,40, 50, 100, "All"]],
	"bSort": true,
	"bInfo": true,
	"bAutoWidth": false,
	"bStateSave": true
} );
</script>
