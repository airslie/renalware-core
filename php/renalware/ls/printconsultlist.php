<?php
//----Fri 28 Feb 2014----streamlining and sorts
//Fri Oct 24 10:33:25 IST 2008
//----Sun 16 Oct 2011----upgr to datatable
include '/Users/lat/projects/renalwarev2/tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
$thislistgroupname = "Renal Consults List";
$thislist = "activelist";
$thislistname="Active $get_site Patients";
$thislistfolder="consultlists";
$thislistbase="consultlist";
$listitems="Consult patients";
//get datatable header
include '../parts/head_datatbl.php';
//get main navbar
//include '../navs/mainnav.php';
//navbar
echo '<div class="buttonsdiv noprint">';
echo "<button onclick=\"location.href='ls/consultlist.php?list=activelist&amp;site=$get_site'\">Return to $get_site Active List</button>&nbsp;&nbsp;";
echo "</div>";
?>
	<?php
	$table="consultdata JOIN patientdata ON consultzid=patzid";
	$fieldslist=array(
		'consultsite' => 'Site/Ward/Bleep',
		'consultward' => 'Ward',
		'sitehospno'=>'Hosp No',
		"concat(lastname,', ',firstnames) as patient"=>'Patient',
		'birthdate'=>'DOB',
		'age'=>'Age',
		'sex'=>'Sex',
		'consultmodal' => 'Modal',
		'consultstartdate' => 'Start date',
		'contactbleep' => 'Contact',
		'consultstaffname' => 'Staff name',
		'consultdescr' => 'Problems/description'
		);
	$where="WHERE activeflag ='Y'";
	if ($get_site) {
		$where="WHERE activeflag ='Y' AND consultsite='$get_site'";
	}
	$omitfields=array('consult_id','consultzid','activeflag','consultdescr','consultward','contactbleep');
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
    //show total in header
    $pagetitle= "$thislistgroupname -- $numrows $thislistname";
    
    echo '<div id="pagetitlediv"><h1>'.$pagetitle.' ('.date("D d/m/Y H:i").')</h1></div>';
    
	//showInfo("$numrows $listitems found","$listnotes");
	?>
    <div id="datatablediv">
	<table class="printlist" style="width: 90%;">
		<thead><tr><?php echo $theaders ?></tr></thead>
		<tbody>
	<?php
    //do KCH first
    $orderby="ORDER BY consultward, consultstartdate, lastname";
    $where.=" AND consultsite='KCH'";
	$sql = "SELECT $fields FROM $table $where $orderby";
	$result = $mysqli->query($sql);    
	while($row = $result->fetch_assoc())
		{
		echo '<tr>
		<td class="f"><b>' . $row["consultsite"] . '</b></td>
        <td>' . $row["sitehospno"] . '</td>
		<td><b>' . $row["patient"] . '</b></td>
		<td>' . dmyyyy($row["birthdate"]) . '</td>
		<td>' . $row["age"] . '</td>
		<td>' . $row["sex"] . '</td>
		<td>' . $row["consultmodal"] . '</td>
		<td>' . dmyyyy($row["consultstartdate"]) . '</td>
		<td>' . $row["consultstaffname"] . '</td></tr>
		<tr><td class="f btm">' . $row["consultward"].' '. $row["contactbleep"] . '</td>
		<td colspan="9" class="btm">'.$row["consultdescr"].'</td></tr>';
		}
        //non-KCH
    	$where="WHERE activeflag ='Y'";
    	if ($get_site) {
    		$where="WHERE activeflag ='Y' AND consultsite='$get_site'";
    	}
        $orderby="ORDER BY consultsite, consultward, consultstartdate, lastname";
        $where.=" AND consultsite != 'KCH'";
    	$sql = "SELECT $fields FROM $table $where $orderby";
    	$result = $mysqli->query($sql);    
    	while($row = $result->fetch_assoc())
    		{
    		echo '<tr>
    		<td class="f"><b>' . $row["consultsite"] . '</b></td>
            <td>' . $row["sitehospno"] . '</td>
    		<td><b>' . $row["patient"] . '</b></td>
    		<td>' . dmyyyy($row["birthdate"]) . '</td>
    		<td>' . $row["age"] . '</td>
    		<td>' . $row["sex"] . '</td>
    		<td>' . $row["consultmodal"] . '</td>
    		<td>' . dmyyyy($row["consultstartdate"]) . '</td>
 		<td>' . $row["consultstaffname"] . '</td></tr>
		<tr><td class="f btm">' . $row["consultward"].' '. $row["contactbleep"] . '</td>
   		<td colspan="9" class="btm">'.$row["consultdescr"].'</td></tr>';
    		}
		?>
		</tbody>
	</table>
</div>
<p id="printfooter">Printed by <b><?php echo $user; ?></b> with Renalware v.<?php echo $versionno ?> at <?php echo date('Y m d H:i:s', time()); ?></p><!-- /printfooter -->
</div> <!-- /content -->
</body>
</html>