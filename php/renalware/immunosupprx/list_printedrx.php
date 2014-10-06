<?php
//--Tue Nov 26 15:08:47 EST 2013--
//start page config
$thispage="list_printedrx";
//include fxns and config
require 'req_fxnsconfig.php';
$pagetitle= $pagetitles["$thispage"];
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=true;
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/immunosupprx_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
//set tables incl JOINs
$table="immunosupprxforms JOIN patientdata ON rxformzid=patzid";
//set fields and preferred labels/headers
//use patzid to build options
$fieldslist=array(
	'rxform_id'=>'ID',
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'rxformdate'=>'form date',
	'rxformuser'=>'printed by',
	'rxformmeds'=>'prescription(s)',
);
$where="WHERE DATEDIFF(CURDATE(),rxformdate)<31";
$listnotes="Includes Immunosuppressant Rx Forms printed in last 30 days."; //appears before "Last run"
$omitfields=array('patzid','rxform_id');
$listnotes.=" Click on headers to sort; search operates across all fields"; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	"immunosupprx/view_pat.php?ls=$thispage" => "view pat", 
    "immunosupprx/view_rxform.php?ls=$thispage" => "view form", 
);
//---------------------------------------------------special rendering needed------------------------
$fields="";
$theaders="<th>options</th>";
foreach ($fieldslist as $key => $value) {
	$fields.=", $key";
	if (!in_array($key,$omitfields)) {
	$theaders.='<th>'.$value. "</th>\r";
	}
}
//remove leading commas
$fields=substr($fields,1);
$sql = "SELECT $fields FROM $table $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($showsql) {
	echo "<p class=\"alertsmall\">$sql</p>";
}
if ($numrows) {
	showInfo("$numrows $listitems found","$listnotes");
} else {
	showAlert("No matching records located!");
}
if ($numrows) {
    echo '<table class="table table-bordered datatable">
	<thead><tr>'.$theaders.'</tr></thead>
	<tbody>';
	while($row = $result->fetch_assoc())
		{
		$zid=$row["patzid"];
		echo "<tr>";
		//options links
		echo '<td>';
        //based on if printed or not
		echo '<a href="immunosupprx/view_rxform.php?id='.$row["rxform_id"].'&amp;ls='.$thispage.'">View Rx Form</a></td>'; //end options
		foreach ($row as $key => $value) {
			if (!in_array($key,$omitfields)) {
				$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
				echo '<td>'.$tdval.'</td>';
			}
		}
		echo '</tr>';
		}
    }
    echo '</tbody>
</table>';
?>
<?php if ($numrows): ?>
<script>
	$('#datatable').dataTable( {
		"bPaginate": true,
		"bLengthChange": true,
		"bJQueryUI": false,
		//"sPaginationType": "full_numbers",
		"bFilter": true,
		"aaSorting": [[ 1, "asc" ]],
		"iDisplayLength": 40,
		"aLengthMenu": [[10,20,40, 50, 100, -1], [10,20,40, 50, 100, "All"]],
        "aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 0 ] }
          ],
		"bSort": true,
		"bInfo": true,
		"bAutoWidth": true,
		"bStateSave": true
	} );
</script>
<?php endif ?>