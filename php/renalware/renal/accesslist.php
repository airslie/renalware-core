<?php
//----Wed 06 Aug 2014----uses proper MDRD col not EGFR
//----Sun 03 Aug 2014----EGFR change
//--Tue Sep  4 13:57:59 CEST 2012--add return to $get_site prn for HD pats
//Sat Nov 28 18:58:52 CET 2009 LIKES-->IN()
//----Wed 08 Sep 2010----PD_assistedAPD added
include '../req/confcheckfxns.php';
//extr
$screenitems = array(
	'lowclear_access' => "LCC Patients", 
	'hd_access' => "HD Patients", 
	);
$thisscreen = ($get_s) ? $get_s : "lowclear_access";
$thisscreenname=$screenitems["$thisscreen"];
$pagetitle= "$siteshort Access Review -- $thisscreenname";
$thissite='';
//----Mon 23 Jul 2012----only HD pats
if ($thisscreen=='hd_access') {
    //----Sun 22 Jul 2012----for filter
    $thissite = ($get_site) ? $get_site : "All";
    $sitelist="All,KRU,QE,Dart,DSU,Syd,ward,Brom,home";
    $sitelistitems=explode(",",$sitelist);
    $pagetitle.=": $thissite";
 }
$thislistname="accesslist";
//get header
include '../parts/head_datatbl.php';
if (!$get_zid) {
	include '../navs/mainnav.php';
	echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
	//subnav
	$baseurl="renal/accesslist.php";
	echo '<div class="buttonsdiv">';
	foreach ($screenitems as $key => $value) {
		$style = ($key==$thisscreen) ? 'class="hilit"' : "" ;
		echo '<button '.$style.' onclick="location.href=\''.$baseurl . '?s=' . $key . '\'">' . $value . '</button> ';
		}
		echo "</div>";
        //for sites prn
        if ($thissite) {
        	echo '<div class="buttonsdiv">';
        	foreach ($sitelistitems as $key => $value) {
        		$style = ($value==$thissite) ? 'class="hilit"' : "" ;
        		echo '<button '.$style.' onclick="location.href=\''.$baseurl . '?s=' . $thisscreen .'&amp;site='.$value. '\'">' . $value . '</button> ';
        		}
        	echo "</div>";
        }
} //end hide stuff if patient on view ($get_zid)
//end nav
//$fields = "patzid, lastname, firstnames, age, sex, modalsite,URE, DATE(UREstamp) as UREdate,CRE,DATE(CREstamp) as CREdate, FLOOR(DATEDIFF(DATE(CREstamp),birthdate)/365) as resultsage,IF(sex='F',.742,1) as sexfactor, IF(ethnicity IN ('Black Caribbean','Black African','Black/other/non-mixed'),1.21,1) as blackfactor, mrsadate,mrsaflag,accessCurrent,accessCurrDate,accessPlan,accessPlanDate";
$fields = "patzid, lastname, firstnames, age, sex, modalsite,URE, DATE(UREstamp) as UREdate,CRE,DATE(CREstamp) as CREdate, MDRD, mrsadate,mrsaflag,accessCurrent,accessCurrDate,accessPlan,accessPlanDate";
$theaders="<th>Patient</th>
<th>age</th>
<th>sex</th>
<th>site</th>
<th>URE</th>
<th>URE Date</th>
<th>CRE</th>
<th>CRE Date</th>
<th>MDRD</th>
<th>MRSA <br>date</th>
<th>MRSA <br>Pos?</th>
<th>Curr Access</th>
<th>Access Date</th>
<th>Access Plan</th>
<th>Plan Date</th>";
switch ($thisscreen)
	{
		/* 
        ----Sun 22 Jul 2012----for sorting ref
		$aasort='7, "desc"'; //col number [starts at 0] then asc or desc
		*/
	case 'lowclear_access':
			$where= "WHERE modalcode='lowclear' AND AccessCurrDate is not NULL";
			$orderby = "ORDER BY URE DESC";
			$aasort='4, "desc"';
			$screen_incl = "lowclearscreen";
			$screentitle = "Low Clearance Screen"; //may be shared by more than one
			break;
	case 'hd_access':
			$where= "WHERE modalcode LIKE 'HD%'";
			$orderby = "ORDER BY URE DESC";
			$aasort='4, "desc"';
			$screen_incl = "hdsitescreen";
			$screentitle = "HD Screen"; //may be shared by more than one
			break;
	}
    //for modalsite
    if ($thissite and $thissite!="All") {
        $where .=" AND modalsite='$thissite'";
    }
//assumes we use a path result
$sql= "SELECT $fields FROM renalware.patientdata JOIN renalware.renaldata ON patzid=renalzid LEFT JOIN hl7data.pathol_current ON hospno1=currentpid $where $orderby";
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
	<div id="tablediv" style="display: <?php echo $liststatus ?>; width: 100%;">
		<?php
		if ($numrows) {
			showInfo("$numrows $thissite &rsquo;$thisscreenname&lsquo; found.","$listnotes");
		} else {
			showAlert("No $thissite $thisscreenname patients located!");
		}
		?>
	<table id="<?php echo $thisscreen ?>" class="ui-corner-all" style="width: 100%;">
		<thead>
			<tr><?php echo $theaders ?></tr>
		</thead>
		<tbody>
			<?php
				while ($row = $result->fetch_assoc())
					{
                    $sitelink = ($get_site) ? "&amp;site=$get_site" : '' ;
					$rowzid = $row["patzid"];
					$tr = '<tr id="tr'.$rowzid.'">';
					$mdrd = $row["EGFR"] ;
					echo $tr.'
					<td><a href="renal/accesslist.php?s='.$thisscreen.'&amp;zid=' . $rowzid . $sitelink. '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a></td>
					<td>'.$row["age"].'</td>
					<td>'.$row["sex"].'</td>
					<td>'.$row["modalsite"].'</td>
					<td class="tn">'.$row["URE"].'</td>
					<td>' . $row["UREdate"].'</td>
					<td class="tn">'.$row["CRE"].'</td>
					<td>' . $row["CREdate"].'</td>
					<td class="tn">'.$mdrd.'</td>
					<td>'.$row["mrsadate"].'</td>
					<td>'.$row["mrsaflag"].'</td>
					<td>'.$row["accessCurrent"].'</td>
					<td>'.$row["accessCurrDate"].'</td>
					<td>'.$row["accessPlan"].'</td>
					<td>'.$row["accessPlanDate"].'</td>
					</tr>';
					}
			?>
			</tbody>
		</table>
		<?php if ($get_lastzid): ?>
			<script type="text/javascript">
				$("#tr<?php echo $get_lastzid ?>").addClass("lolite");
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
				<button class="ui-state-default" style="color: green;" onclick="self.location='<?php echo "renal/$thislistname.php?s=$get_s&amp;lastzid=$get_zid&amp;site=$get_site" ?>'">Return to &rsquo;<?php echo "$thisscreenname $get_site"; ?>&lsquo; List</button>
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