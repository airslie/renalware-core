<?php
//----Wed 06 Aug 2014----uses proper MDRD col not EGFR
//----Sun 03 Aug 2014----EGFR change prev $mdrd = ($row["CRE"] && $row["resultsage"]) ? round(186*(pow(($row["CRE"]/88.4),-1.154))*pow($row["resultsage"],-.203)*$row["sexfactor"]*$row["blackfactor"]) : "" ;
//----Thu 31 Oct 2013----HGB fixes
//Sat Nov 28 18:58:52 CET 2009 LIKES-->IN()
//----Wed 08 Sep 2010----PD_assistedAPD added
include '../req/confcheckfxns.php';
//extr
//extract($_GET,EXTR_PREFIX_ALL,'get');
$screenitems = array(
	'lowclear_patients' => "LCC (By Urea date)", 
	'lowclear_URE' => "LCC (Urea&gt;30)", 
	'lowclear_lowHGB' => "LCC (HGB&lt;100)", 
	'lowclear_hiHGB' => "LCC (HGB&gt;130)", 
//	'lowclear_MDRD' => "LCC (MDRD&lt;15)", 
	'lowclear_worryboard' => "LCC &ldquo;Worry Board&rdquo;", 
	'lowclear_txcandidates' => "LCC &ldquo;Tx Candidates&rdquo;", 
	'tx_patients' => "Transplant Pats", 
	'pd_patients' => "PD Pats", 
	);
$thisscreen = ($get_s) ? $get_s : "lowclear_URE";
$thisscreenname=$screenitems["$thisscreen"];
$pagetitle= "$siteshort Patient Screens -- $thisscreenname";
//get header
include '../parts/head_datatbl.php';
if (!$get_zid) {
	include '../navs/mainnav.php';
	echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
	//subnav
	$baseurl="renal/screens.php";
	echo '<div class="buttonsdiv">';
	foreach ($screenitems as $key => $value) {
		$style = ($key==$thisscreen) ? 'class="hilit"' : "" ;
		echo '<button '.$style.' onclick="location.href=\''.$baseurl . '?s=' . $key . '\'">' . $value . '</button> ';
		}
		echo "</div>";
} //end hide stuff if patient on view ($get_zid)
//end nav
$theaders="<th>Patient</th>
<th>HospNo</th>
<th>age</th>
<th>sex</th>
<th>HGB</th>
<th>HGB Date</th>
<th>URE</th>
<th>URE Date</th>
<th>CRE</th>
<th>CRE Date</th>
<th>MDRD</th>
<th>ESRF</th>
<th>MRSA date</th>
<th>MRSA site</th>
<th>MRSA result (date)</th>
<th>Wait List Status</th>";
//$fields = "patzid, hospno1, lastname, firstnames, age, sex, endstagedate,txWaitListStatus,HB, DATE(HBstamp) as HBdate, URE, DATE(UREstamp) as UREdate,CRE,DATE(CREstamp) as CREdate, FLOOR(DATEDIFF(DATE(CREstamp),birthdate)/365) as resultsage,IF(sex='F',.742,1) as sexfactor, IF(ethnicity IN ('Black Caribbean','Black African','Black/other/non-mixed'),1.21,1) as blackfactor, swabdate,swabsite,swabresult,resultdate";
//now use pathol_results EGFR
$fields = "patzid, hospno1, lastname, firstnames, age, sex, endstagedate,txWaitListStatus,HB, DATE(HBstamp) as HBdate, URE, DATE(UREstamp) as UREdate,CRE,DATE(CREstamp) as CREdate, MDRD, swabdate,swabsite,swabresult,resultdate";
switch ($thisscreen)
	{
	case 'lowclear_patients':
		$where= "WHERE modalcode='lowclear'";
		$orderby = "ORDER BY UREstamp DESC";
		$aasort='7, "desc"';
		$screen_incl = "lowclearscreen"; //may be shared by more than one
		$screentitle = "Low Clearance Screen"; //may be shared by more than one
		break;
	case 'lowclear_txcandidates':
		$where= "WHERE modalcode='lowclear' AND txWaitListStatus NOT LIKE '%perm%'";
		$orderby = "ORDER BY UREstamp DESC";
		$aasort='7, "desc"';
		$screen_incl = "lowclearscreen"; //may be shared by more than one
		$screentitle = "Low Clearance Screen"; //may be shared by more than one
		break;
	case 'lowclear_worryboard':
		$where= "WHERE modalcode='lowclear' AND alertflag='Y'";
		$orderby = "ORDER BY UREstamp DESC";
		$aasort='7, "desc"';
		$screen_incl = "lowclearscreen"; //may be shared by more than one
		$screentitle = "Low Clearance Screen"; //may be shared by more than one
		break;
	case 'lowclear_URE':
		$where= "WHERE modalcode='lowclear' AND URE > 30";
		$orderby = "ORDER BY URE DESC";
		$aasort='6, "desc"';
		$screen_incl = "lowclearscreen"; //may be shared by more than one
		$screentitle = "Low Clearance Screen"; //may be shared by more than one
		break;
	case 'lowclear_MDRD':
		$where= "WHERE modalcode='lowclear' AND CRE > 30";
		//----Sun 31 Jul 2011----IMPORTANT NOTE ifelse in WHILE below
		$orderby = "ORDER BY CRE DESC";
		$aasort='8, "desc"';
		$screen_incl = "lowclearscreen"; //may be shared by more than one
		$screentitle = "Low Clearance Screen"; //may be shared by more than one
		break;
	case 'lowclear_lowHGB':
		$where= "WHERE modalcode='lowclear' AND HB < 10";
		$orderby = "ORDER BY HB ASC";
		$aasort='4, "asc"';
		$screen_incl = "lowclearscreen";
		$screentitle = "Low Clearance Screen"; //may be shared by more than one
		break;
	case 'lowclear_hiHGB':
		$where= "WHERE modalcode='lowclear' AND HB > 13";
		$orderby = "ORDER BY HB DESC";
		$aasort='4, "desc"';
		$screen_incl = "lowclearscreen";
		$screentitle = "Low Clearance Screen"; //may be shared by more than one
		break;
	case 'tx_patients':
		$where= "WHERE modalcode IN ('Tx_first','Tx_subs')"; //Sat Nov 28 18:57:37 CET 2009
		$orderby = "ORDER BY HB ASC";
		$aasort='4, "asc"';
		$screen_incl = "txscreen";
		$screentitle = "Transplant Screen"; //may be shared by more than one
		break;
	case 'pd_patients':
		$where= "WHERE modalcode IN ('PD_APD','PD_CAPD','PD_assistedAPD')";
		$orderby = "ORDER BY HBstamp DESC";
		$aasort='5, "desc"';
		$screen_incl = "pdscreen";
		$screentitle = "PD Screen"; //may be shared by more than one
		break;
	}
//assumes we use a path result
//2011-12-19 for latest MRSA data cf hdscreens
$sql= "SELECT $fields FROM renalware.patientdata JOIN renalware.renaldata ON patzid=renalzid LEFT JOIN hl7data.pathol_current ON hospno1=currentpid LEFT JOIN mrsadata ON mrsalast_id=mrsa_id $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($get_showsql && $adminflag) {
	showInfo("SQL","$sql");
}
$listnotes="Notes: Click on headers to sort. The Search operates across all fields.<br>Pathology results displayed are latest available.";
?>
<?php if (!$get_zid): ?>
	<script type="text/javascript">
		$('#tablediv').show();
	</script>
<?php endif ?>
<div class="clear">
	<div id="tablediv" style="display: <?php echo $liststatus ?>;">
		<?php
		if ($numrows) {
			showInfo("$numrows &rsquo;$thisscreenname&lsquo; found.","$listnotes");
		} else {
			showAlert("No $thisscreenname patients located!");
		}
		?>
	<table id="<?php echo $thisscreen ?>" class="display" style="width: 100%;">
		<thead>
			<tr><?php echo $theaders ?></tr>
		</thead>
		<tbody>
			<?php
				while ($row = $result->fetch_assoc())
					{
                    $HGB = ($row["HB"]) ? 10*$row["HB"] : '' ;
					$rowzid = $row["patzid"];
					$tr = '<tr id="tr'.$rowzid.'">';
					echo $tr.'
					<td><a href="renal/screens.php?s='.$thisscreen.'&amp;zid=' . $rowzid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a></td>
					<td>'.$row["hospno1"]. '</td>
					<td>'.$row["age"].'</td>
					<td>'.$row["sex"].'</td>
					<td class="tn">'.$HGB.'</td>
					<td>' . dmy($row["HBdate"]).'</td>
					<td class="tn">'.$row["URE"].'</td>
					<td>' . dmy($row["UREdate"]).'</td>
					<td class="tn">'.$row["CRE"].'</td>
					<td>' . dmy($row["CREdate"]).'</td>
					<td class="tn">'.$row["EGFR"].'</td>
					<td>'.dmyyyy($row["endstagedate"]).'</td>
					<td>'.$row["swabdate"].'</td>
					<td>'.$row["swabsite"].'</td>
					<td>'.$row["swabresult"]. ' '.dmy($row["resultdate"]).'</td>
					<td>'.$row["txWaitListStatus"].'</td>
					</tr>';
					}
			?>
			</tbody>
		</table>
		<?php if ($get_lastzid): ?>
			<script type="text/javascript">
				$("#tr<?php echo $get_lastzid ?>").addClass("hilite");
			</script>
		<?php endif ?>
		</div>
		<!-- //"bStateSave": true, -->
		<script type="text/javascript">
		$('#<?php echo $thisscreen ?>').dataTable( {
			"aaSorting": [[ <?php echo $aasort ?> ]],
			"bStateSave": true,
			"iDisplayLength": 25,
			"aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
				"bPaginate": true,
				"bLengthChange": true,
				"bJQueryUI": false,
			//	"sPaginationType": "scrolling",
				"bFilter": true,
				"bSort": true,
				"bInfo": true,
				"bAutoWidth": true,
				"aoColumnDefs": [
				{ "sWidth": "20%", "aTargets": [ 0 ] },
				{ "sType": "html", "aTargets": [ 0 ] },
				]
		} );
		</script>		
		<?php if ($get_zid): ?>
			<script type="text/javascript">
				$('#tablediv').hide();
			</script>
			<div id="screeninfodiv">
				<button class="ui-state-default" style="color: green;" onclick="self.location='renal/screens.php?s=<?php echo $get_s ?>&amp;lastzid=<?php echo $get_zid ?>'">Return to &rsquo;<?php echo $thisscreenname ?>&lsquo; List</button>
			<?php
			$zid=$get_zid;
			include "$rwarepath/data/patientdata.php";
			include "$rwarepath/data/renaldata.php";
			include "$rwarepath/data/currentclindata.php";
			echo "<h3>$screentitle for $firstnames $lastname ($age $sex KCH No $hospno1) -- $modalcode</h3>";
			makeInfo("Tip","Use the &ldquo;right-click&rdquo; option to open these patient screens in a new window to preserve the display below and link above to the current list.");
			echo '<div class="buttonsdiv">';
				include '../navs/patnavarray.php';
				include "$rwarepath/renal/screens/$screen_incl.php";
			echo '</div>';
			?>
			</div>
		<?php endif ?>
</div>
<?php
	include '../parts/footer.php';
?>