<?php
//Fri Oct 24 10:33:25 IST 2008
//----Sun 16 Oct 2011----upgr to datatable
include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
include '../req/confcheckfxns.php';
$thislistgroupname = "Renal Consults List";
$thislist = "activelist";
$thislistname="Active $get_site Patients";
$thislistfolder="consultlists";
$thislistbase="consultlist";
$listitems="Consult patients";
$pagetitle= $thislistgroupname . ' -- ' . $thislistname;
//get datatable header
include '../parts/head_datatbl.php';
//get main navbar
//include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.' ('.date("D d/m/Y H:i").')</h1></div>';
//navbar
echo '<div class="buttonsdiv noprint">';
echo "<button onclick=\"location.href='ls/consultlist.php?list=activelist&amp;site=$get_site'\">Return to $get_site Active List</button>&nbsp;&nbsp;";
echo "</div>";
?>
<div id="datatablediv">
	<?php
	$table="consultdata JOIN patientdata ON consultzid=patzid";
	$fieldslist=array(
		'sitehospno'=>'HospNo',
		"concat(lastname,', ',firstnames) as patient"=>'patient',
		'age'=>'age',
		'sex'=>'sex',
		'consultsite' => 'site',
		'consultmodal' => 'modal',
		'consultstartdate' => 'startdate',
		'consulttype' => 'type',
		'consultward' => 'consult ward',
		'contactbleep' => 'Contact',
		'consultstaffname' => 'staff name',
		'consultdescr' => 'problems/description'
			);
	$where="WHERE activeflag ='Y'";
	if ($get_site) {
		$where="WHERE activeflag ='Y' AND consultsite='$get_site'";
	}
	$omitfields=array('consult_id','consultzid','activeflag','consultdescr');

	$fields="";
	$theaders="";
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
	$sql = "SELECT $fields FROM $table $where $orderby";
	$result = $mysqli->query($sql);
	$numrows=$result->num_rows;
	showInfo("$numrows $listitems found","$listnotes");
	?>
	<table class="printlist" style="width: 90%;">
		<thead><tr><?php echo $theaders ?></tr></thead>
		<tbody>
	<?php
	while($row = $result->fetch_assoc())
		{
		echo '<tr>
		<td class="f">' . $row["sitehospno"] . '</td>
		<td><b>' . $row["patient"] . '</b></td>
		<td>' . $row["age"] . '</td>
		<td>' . $row["sex"] . '</td>
		<td>' . $row["consultsite"] . '</td>
		<td>' . $row["consultmodal"] . '</td>
		<td>' . $row["consultstartdate"] . '</td>
		<td>' . $row["consulttype"] . '</td>
		<td>' . $row["consultward"] . '</td>
		<td>' . $row["contactbleep"] . '</td>
		<td>' . $row["consultstaffname"] . '</td></tr>
		<tr><td colspan="11" class="btm">'.$row["consultdescr"].'</td></tr>';
		}
		?>
		</tbody>
	</table>
</div>
<p id="printfooter">Printed by <b><?php echo $user; ?></b> with Renalware v.<?php echo $versionno ?> at <?php echo date('Y m d H:i:s', time()); ?></p>
<!-- /printfooter -->
</div> <!-- /content -->
</body>
</html>