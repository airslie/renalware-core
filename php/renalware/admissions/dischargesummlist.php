<?php
//----Tue 19 Feb 2013----
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Discharged Patients List";
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
echo '<p>
<a class="ui-state-default" style="color: red;" href="admissions/dischargesummlist.php?show=unreviewed">Unreviewed Disch Summs</a>&nbsp;&nbsp;
<a class="ui-state-default" style="color: red;" href="admissions/dischargesummlist.php?show=outstanding">Outstanding Disch Summs</a>&nbsp;&nbsp;';
if ($wardclerkflag) {
    echo '<a class="ui-state-default" style="color: purple;" href="admissions/dischargesummlist.php?show=outstanding&amp;dedupe=yes">Remove Duplicates</a>';
}
echo '</p>';
$show = ($get_show) ? $get_show : "outstanding" ;
switch ($show) {
	case 'unreviewed':
		$where="WHERE archiveflag=0 AND a.admittedflag=0 AND letter_id is not NULL";
		$displaytext = "$siteshort discharged patients with UNFINISHED discharge summaries"; //default
		break;
	case 'outstanding':
		$where="WHERE dischsummflag=0 AND a.admittedflag=0 AND letter_id is NULL AND admmodal != 'medical'";
		$displaytext = "$siteshort discharged patients WITHOUT discharge summaries"; //default
		break;
}
$sql = "SELECT dischsummflag,admission_id,letter_id,admzid, admhospno1, concat(lastname,', ',firstnames) as patientname, a.admdate, a.dischdate, a.dischdest, datediff(NOW(), a.dischdate) as days_since_disch,dischsummstatus, status,authorsig FROM admissiondata a LEFT JOIN letterdata l ON admission_id=admissionid JOIN patientdata ON admzid=patzid $where ORDER BY dischdate ASC";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<div id=\"datatablediv\">
<p class=\"header\">$numrows $displaytext located.</p>";
echo "<table class=\"datatable\" style=\"width: 100%\"><thead><tr>
<th>$hosp1label</th>
<th>patient</th>
<th>adm date</th>
<th>discharged</th>
<th>disch destin</th>
<th>days ago</th>
<th>disch summ status</th>";
if ($get_show=="unreviewed" or $get_dedupe) {
		echo "<th>lttr status</th>
		<th>author</th>";
	}
echo "</tr></thead><tbody>";
while ($row = $result->fetch_assoc()) {
	$admission_id=$row["admission_id"];
	$letter_id=$row["letter_id"];
	$status=$row["status"];
	//use dischsummstatus to determine link :) -- create/edit/view
	$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["admzid"] . '">' . $row["patientname"] . '</a>';
	$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["admzid"] . '">' . $row["admhospno1"] . '</a>';
	$dischsummlink = ($row["dischsummstatus"]=='create') ? '<a href="letters/createdischarge.php?zid=' . $row["admzid"] .'&amp;admissionid='.$admission_id.'">create Disch Summ</a>' : $row["dischsummstatus"] ;
	//use dischsummstatus to determine link :) -- create/edit/view
	if ($row["dischdest"]=="Death") {
		$dischsummlink = '<a href="letters/createdischarge.php?zid=' . $row["admzid"] .'&amp;admissionid='.$admission_id.'">create Death Notif</a>';
	}
	if ($get_show=="unreviewed" && $letter_id) {
		$dischsummlink = '<a href="letters/editletter.php?zid=' . $row["admzid"] .'&amp;letter_id='.$letter_id.'">update Disch Summ '.$letter_id.'</a>';
	}
	if ($get_dedupe=="yes") {
		$dischsummlink = '<a href="admissions/run/run_dedupe.php?duplicateid='.$admission_id.'">remove duplicate admission (CAUTION!)</a>';
		}
	if($row["dischsummflag"]==1)
	{
		$dischsummlink = $row["dischsummstatus"];
		//deflag those w/ summs; mark dead
		$bg = ($row["dischdest"]=="Death") ? '#ccc' : '#fff' ;
	}
	echo '<tr class="' . $status . '">'.
	"<td>$adminlink</td>
	<td>$patlink</td>
	<td>" . dmyyyy($row["admdate"]) . "</td>
	<td>" . dmyyyy($row["dischdate"]) . "</td>
	<td>" . $row["dischdest"] . "</td>
	<td>" . $row["days_since_disch"] . "</td>
	<td>" . $dischsummlink . "</td>";
	if ($get_show=="unreviewed" or $get_dedupe) {
		echo "<td>" . $row["status"] . "</td>
	<td>" . $row["authorsig"] . "</td>";
		}
	echo "</tr>";
	}
echo '</tbody></table>
</div>';
include '../parts/footer.php';
?>
<script>
$('.datatable').dataTable( {
	"bPaginate": true,
	"bLengthChange": false,
	"bJQueryUI": false,
	//"sPaginationType": "full_numbers",
	"bFilter": true,
	"aaSorting": [[ 1, "asc" ]],
	"iDisplayLength": 100,
	//"aLengthMenu": [[10,20,40, 50, 100, -1], [10,20,40, 50, 100, "All"]],
	"bSort": true,
	"bInfo": true,
	"bAutoWidth": false,
	"bStateSave": true
} );
</script>
