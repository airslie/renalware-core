<?php
//----Fri 08 Mar 2013----col switch
//----Wed 06 Mar 2013----datatable
require '../../config_incl.php';
require '../../incl/check.php';
include '../../fxns/fxns.php';
include '../../fxns/formfxns.php';
$pagetitle= $siteshort . " Transplant Operations List";
//get header
include '../../parts/head_datatbl.php';
//get main navbar
include '../../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//get total
$displaytext = "$siteshort Transplant Operations"; //default
$where = "";  // default
if($_GET["zid"])
	{
	$zid=$_GET['zid'];
	$where = "WHERE txopzid=$zid";
	}
$orderby = "ORDER BY lastname, firstnames";
$fields="txopzid,
hospno1,
lastname,
firstnames,
sex,
birthdate,
age,
DATE_FORMAT(FROM_DAYS(TO_DAYS(txopdate)-TO_DAYS(birthdate)), '%y') AS age_at_op,
modalcode,
txop_id,
txopdate,
txopno,
txoptype,
donortype,
txsite,
graftfxn,
failureflag,
failuredate,
stentremovaldate
";
$sql= "SELECT $fields FROM txops LEFT JOIN patientdata ON txopzid=patzid $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">$numtotal $displaytext ($numrows displayed).</p>";
echo '<table id="txoplist" class="display"><thead>
<tr>
<th>options</th>
<th>Hosp No</th>
<th>patient</th>
<th>sex</th>
<th>age</th>
<th>curr modal</th>
<th>Tx date</th>
<th>Tx No</th>
<th>type</th>
<th>age at op</th>
<th>donor type</th>
<th>site</th>
<th>function</th>
<th>failure<br>date</th>
<th>stent<br>removed</th>
</tr></thead><tbody>';
while($row = $result->fetch_assoc())
	{
	$bg = (!$row["stentremovaldate"]) ? '#ff9' : '#fff' ;
	$bg = ($row["failureflag"]) ? '#ccc' : '#fff' ;
	$zid = $row["txopzid"];
	$showage = ($row["modalcode"]=='death') ? '&nbsp;' : $row["age"];
	$patient = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
//	$patlink = '<a href="renal/renal.php?zid=' . $zid . '">' . $patient . '</a>';
	$screenlink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txscreenview">Tx Screen</a>';
	$viewlink = '<a href="renal/txop/view_txop.php?zid='.$zid.'&amp;id='.$row["txop_id"].'">View Op</a>';
//	$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
	echo "<tr bgcolor=\"$bg\">
	<td>" . $viewlink . '&nbsp;&nbsp;' . $screenlink . "</td>
	<td>" . $row["hospno1"] . "</td>
	<td>" . $patient . "</td>
	<td>" . $row["sex"] . "</td>
	<td>" . $showage . "</td>
	<td>" . $row["modalcode"] . "</td>
	<td>" . dmy($row["txopdate"]) . "</td>
	<td>" . $row["txopno"] . "</td>
	<td>" . $row["txoptype"] . "</td>
	<td>" . $row["age_at_op"] . "</td>
	<td>" . $row["donortype"] . "</td>
	<td>" . $row["txsite"] . "</td>
	<td>" . $row["graftfxn"] . "</td>
	<td>" . dmy($row["failuredate"]) . "</td>
	<td>" . dmy($row["stentremovaldate"]) . "</td>
	</tr>";
}
echo '</tbody></table>';
?>
<script>
$('#txoplist').dataTable( {
	"bPaginate": true,
	"bLengthChange": false,
	"bJQueryUI": false,
	"sPaginationType": "full_numbers",
    "aoColumnDefs": [
        { "bSortable": false, "aTargets": [ 0 , 1] }
      ],
    "aaSorting": [ [3,'asc'] ],
	"bFilter": true,
	"iDisplayLength": 30,
	"bSort": true,
	"bInfo": false,
	"bAutoWidth": false,
	"bStateSave": true
} );
</script>
<?php
include '../parts/footer.php';
?>
