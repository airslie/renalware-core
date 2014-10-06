<?php
//----Mon 23 Sep 2013----HGB fix
//----Fri 05 Aug 2011----datatables version
include '../req/confcheckfxns.php';
//menu array
$thissite = ($get_site) ? $get_site : "KRU";
//$thissched = "MonWedThu";
//$thisslot = "AM";
$thissss=$thissite;
$thissitename="HD-$thissite";
$pagetitle= "$siteshort HD Sites -- $thissite patients";
$q="site=$get_site&amp;";
$where= "WHERE modalcode LIKE 'HD%' AND modalsite='$thissite'";
//end defaults
if ($get_sched) {
	$thissched=$get_sched;
	$thissss.="&amp;sched=$get_sched";
	$thissitename.=": $thissched";
	$page.=": $thissched";
	$where.=" AND currsched='$thissched'";
}
if ($get_slot) {
	$thisslot=$get_slot;
	$thissss.="&amp;slot=$get_slot";
	$thissitename.=" ($thisslot)";
	$page.=" ($thisslot)";
	$where.=" AND currslot='$thisslot'";
}
//get header
include '../parts/head_datatbl.php';
if (!$get_z) {
	include '../navs/mainnav.php';
	echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
	//subnav
	$baseurl="renal/hdscreens.php";
	echo '<div class="buttonsdiv">';
	$sql="SELECT COUNT(patzid) as sitecount, modalsite FROM patientdata WHERE modalcode LIKE 'HD%' GROUP BY modalsite";
	$result = $mysqli->query($sql);
	while ($row = $result->fetch_assoc())
	{
		$modalsite=$row["modalsite"];
		$sitecount=$row["sitecount"];
		$label="HD-$modalsite ($sitecount)";
		$style = ($modalsite==$thissite) ? "color: red; background: yellow" : "#333" ;
		echo '<a style="'.$style.'" href="' . $baseurl . '?site=' . $modalsite . '">' . $label . '</a>&nbsp;&nbsp;';
		}
		echo '<br>';
	$scheds=array('MonWedFri','TueThuSat');
	foreach ($scheds as $key => $value) {
		$style = ($value==$get_sched) ? "color: red; background: yellow" : "#333" ;
		echo '<a style="'.$style.'" href="' . $baseurl . '?site=' . $thissite . '&amp;sched='.$value.'">'.$thissite.': ' . $value . '</a>&nbsp;&nbsp;';
	}
	if ($get_sched) {
		$slots=array('AM','PM','Eve');
		foreach ($slots as $key => $value) {
			$style = ($value==$get_slot) ? "color: red; background: yellow" : "#333" ;
			echo '<a style="'.$style.'" href="' . $baseurl . '?site=' . $thissite . '&amp;sched='.$get_sched.'&amp;slot='.$value.'">' . $value . '</a>&nbsp;&nbsp;';
		}
	}
	echo '</div>';
} //end hide stuff
//end nav
//get screen patlist
//---------------Sun Apr 18 18:24:14 CEST 2010--------------- WHERE now set above based on sched/slot choice
//$fields = "patzid, lastname, firstnames, age, sex, HB, HBstamp,accessCurrent,endstagedate,currsite,currsched,currslot,namednurse,txWaitListStatus,transportflag,lastavg_syst,lastavg_diast,mrsadate,mrsasite";
$fields = "patzid, lastname, firstnames, age, sex, HB, HBstamp,accessCurrent,endstagedate,currsite,currsched,currslot,namednurse,txWaitListStatus,transportflag,lastavg_syst,lastavg_diast,swabdate,swabsite,swabresult,resultdate";
$orderby = "ORDER BY HB ASC";
$screen_incl = "hdsitescreen"; //may be shared by more than one
$screentitle = "HD Patient Screen"; //may be shared by more than one
$sql= "SELECT $fields FROM patientdata LEFT JOIN hl7data.pathol_current ON hospno1=currentpid JOIN hdpatdata ON patzid=hdpatzid JOIN renaldata ON patzid=renalzid LEFT JOIN mrsadata ON mrsalast_id=mrsa_id $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($get_showsql && $adminflag) { showInfo("SQL","$sql"); }
$listnotes="Notes: Click on Headers to sort.Transp=Transport needed. *BPs are last mean pre-dialysis BPs over previous 30 days.";
?>
<?php if (!$get_z): ?>
	<script type="text/javascript">
		$('#tablediv').show();
	</script>
<?php endif ?>
<div class="clear">
	<div id="tablediv">
		<?php
		if ($numrows) {
			showInfo("$numrows &rsquo;$thissitename&lsquo; patients found.","$listnotes");
		} else {
			showAlert("No $thissitename patients located!");
		}
		?>
	<table id="hdscreen" class="ui-corner-all" style="width: 100%;">
			<thead><tr>
				<th>Patient (Click to view)</th>
				<th>age</th>
				<th>sex</th>
				<th>Last HGB</th>
				<th>HGB Date</th>
				<th>Curr Access</th>
				<th>ESRF date</th>
				<th>Named Nurse</th>
				<th>Tx WL Status</th>
				<th>Transp</th>
				<th>SBP</th>
				<th>DBP</th>
				<th>MRSA date</th>
				<th>MRSA site</th>
				<th>MRSA result (date)</th>
				<th>Site-Schedule-Slot</th>
			</tr></thead>
			<tbody>
		<?php
			while ($row = $result->fetch_assoc())
				{
                $HGB = ($row["HB"]) ? 10*$row["HB"] : '' ;
				echo '<tr id="tr'.$row["patzid"].'">
				<td><a href="renal/hdscreens.php?site='.$thissss.'&amp;z=' . $row["patzid"] . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a></td>
				<td>'.$row["age"]. '</td>
				<td>'.$row["sex"].'</td>
				<td>' . $HGB .'</td>
				<td>' . dmy(substr($row["HBstamp"],0,10)).'</td>
				<td>'.$row["accessCurrent"] . '</td>
				<td>'.dmy($row["endstagedate"]).'</td>
				<td>'.$row["namednurse"].'</td>
				<td>'.$row["txWaitListStatus"].'</td>
				<td>'.$row["transportflag"].'</td>
				<td>'.$row["lastavg_syst"].'</td>
				<td>'.$row["lastavg_diast"].'</td>
				<td>'.$row["swabdate"].'</td>
				<td>'.$row["swabsite"].'</td>
				<td>'.$row["swabresult"]. ' '.dmy($row["resultdate"]).'</td>
				<td>'.$row["currsite"].'-'.$row["currsched"].'-'.$row["currslot"].'</td>
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
	<script type="text/javascript">
			$('#hdscreen').dataTable( {
				"bStateSave": true,
					"bPaginate": false,
					"bLengthChange": false,
					"bJQueryUI": false,
					"sPaginationType": "scrolling",
					"bFilter": false,
					"bSort": true,
					"bInfo": true,
					"bAutoWidth": false,
					"aoColumnDefs": [
					{ "sWidth": "20%", "aTargets": [ 0 ] },
					{ "sType": "html", "aTargets": [ 0 ] },
					]
			} );
	</script>
	<?php if ($get_z): ?>
		<script type="text/javascript">
			$('#tablediv').hide();
		</script>
		<div id="screeninfodiv">
			<button class="ui-state-default" style="color: green;" onclick="self.location='renal/hdscreens.php?site=<?php echo $get_site ?>&amp;sched=<?php echo $get_sched ?>&amp;slot=<?php echo $get_slot ?>&amp;lastzid=<?php echo $get_z ?>'">Return to &rsquo;<?php echo $thissitename ?>&lsquo; List</button>
			<?php
			//if patient is selected...
			if ($get_z )
				{
				$zid=$get_z;
				include "$rwarepath/data/patientdata.php";
				include "$rwarepath/data/renaldata.php";
				//---------------Mon May  3 11:54:45 CEST 2010---------------add missing hospno
				echo "<h1>$screentitle for $firstnames $lastname ($age $sex) KCH No $hospno1 -- $modalcode</h1>";
				include "$rwarepath/navs/patnavarray.php";
				include "$rwarepath/navs/renalnav.php";
				include "$rwarepath/renal/screens/$screen_incl.php";
				}
			?>
		</div>
		<?php endif ?>
</div>
<?php
	include '../parts/footer.php';
?>