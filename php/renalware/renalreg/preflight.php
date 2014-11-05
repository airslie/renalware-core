<?php
//----Fri 05 Sep 2014----link to update_esrf.php
//----Wed 06 Aug 2014----handle PRD
//----Fri 30 May 2014----formatting
//----Thu 27 Jun 2013----new qtrmodals
//--Mon Oct 15 09:31:35 SGT 2012--
//Sun Dec 21 11:26:09 SGT 2008
//--Fri Jun  8 13:33:38 CEST 2012--
$thistab="preflight.php";
require '../config_incl.php';
require '../incl/check.php';
$pagetitle="Renal Reg Export: Preflight data checks";
include '../parts/head_bs.php';
include 'incl/renalreg_config.php';
include 'incl/rregmaps_incl.php';
include 'incl/navbar_incl.php';
echo '<h1><small>'.$pagetitle.'</small></h1></div>';
$flighttypes=array(
	'ethnicity'=>'Check ESRF Patient Ethnicity data',
	'firstseendate'=>'Check ESRF Patient First Seen dates',
	'newesrfpats'=>'New ESRF patients (no Renal Reg Nos)',
	'nullprdpats'=>'No PRD patients (missing new PRD code)',
	'departed'=>'ESRF Death/Transfers Out',
	'qtrmodals'=>'NEW! Qtr Modality Changes',
	);
$type = ($_GET['type']) ? $_GET['type'] : false ;
$preflighttype = ($type) ? $flighttypes[$type] : "Select desired operation" ;
echo '<h2><small>'.$preflighttype.'</small></h2>
<ul class="nav nav-pills">';
foreach($flighttypes as $typecode => $label) {
	echo '<li><a class="btn btn-mini" href="renalreg/preflight.php?type='.$typecode.'">'.$label.'</a></li>';
}
echo '</ul>';
$where="WHERE endstagedate is not NULL AND modalcode NOT IN ('death','transferout')";
$excludeflag="excludes";
if ($type) {
    if ($type=='qtrmodals') {
    	//run SQL
        $where="WHERE modaldate BETWEEN '$thisstartdate' AND '$thisenddate' OR modaltermdate BETWEEN '$thisstartdate' AND '$thisenddate'";
    	$fields="rregno,patient,sex,birthdate,deathdate,hospno1,modaldate,modalcode,modalsitecode,rrmodalcode,modaltermdate";
    	$headers="RReg No,patient,sex,DOB,DoDeath,KCH No,ModalDate,Modal,Site,RR Code,TermDate";
    	$fieldsarray=explode(',',$fields);
    	$headersarray=explode(',',$headers);
    	$sql="SELECT patzid, rregno, CONCAT(lastname,', ', firstnames) as patient, sex, birthdate,deathdate, hospno1, modaldata.*
    	FROM renalware.patientdata JOIN renalware.modaldata ON patzid=modalzid $where ORDER BY endstagedate DESC";
    	$result = $mysqli->query($sql);
    	if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
    	$numrows=$result->num_rows;
    	if ($numrows) {
    		echo "<p class=\"text-info\">$numrows patients found $where. Click on headers to sort.</p>";
    		echo '<table class="table table-bordered table-condensed datatable"><thead><tr><th>&nbsp;</th>';
    		foreach ($headersarray as $key => $header) {
    			echo "<th>$header</th>";
    		}
    		echo "</tr></thead><tbody>"; //end header row
    		while($row = $result->fetch_assoc())
    			{
    			echo '<tr><td>';
    			echo '<a href="pat/patient.php?scr=modals&amp;zid='.$row["patzid"].'" >modals</a></td>';
    			foreach ($fieldsarray as $key => $field) {
    				echo '<td>'.$row["$field"].'</td>';
    			}
    			echo "</tr>";
    			}
    		echo "</tbody></table>";
    	} else {
    		echo "<br><br>No modality changes found!";
    	}
        
    } else {
    	switch ($type) {
    		case 'ethnicity':
    			$where.=" AND ethnicityreadcode is NULL";
    			break;
    		case 'firstseendate':
    			$where.=" AND firstseendate is NULL";
    			break;
    		case 'newesrfpats':
    			$where.=" AND rregno is NULL";
    			break;
        	case 'nullprdpats':
        		$where.=" AND rreg_prdcode is NULL";
        		break;
    		case 'departed':
    		$excludeflag="includes";
    		$where="WHERE endstagedate is not NULL AND modalcode IN ('death','transferout')";
    			break;
    	}
    	//run SQL
    	$fields="rregno,patient,sex,birthdate,deathdate,hospno1,modalcode,modalsite,
        firstseendate,endstagedate,edtacode,rreg_prdcode,ethnicity,ethnicityreadcode";
    	$headers="RReg No,patient,sex,DOB,DODeath,KCH No,modal,site,first seen,
        ESRFdate,EDTAcode,PRDcode,ethnicity,EthnicCode";
    	$fieldsarray=explode(',',$fields);
    	$headersarray=explode(',',$headers);
    	$sql="SELECT patzid, rregno, CONCAT(lastname,', ', firstnames) as patient, sex, 
        birthdate,deathdate, hospno1, modalcode, modalsite, ethnicity, firstseendate, 
        endstagedate, EDTAcode as edtacode, rreg_prdcode, ethnicityreadcode
    	FROM renalware.patientdata JOIN renalware.renaldata ON patzid=renalzid 
        JOIN renalware.esrfdata ON patzid=esrfzid 
        LEFT JOIN renalreg.ethnicreadcodes ON ethnicity=ethnicityname 
        $where ORDER BY endstagedate DESC";
    	$result = $mysqli->query($sql);
    	if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
    	$numrows=$result->num_rows;
    	if ($numrows) {
    		echo "<p class=\"text-info\">$numrows patients found (NB $excludeflag DEATH and TRANSFER OUT patients). 
            Click on headers to sort. Links open in new window.</p>";
    		echo '<table class="table table-bordered table-condensed datatable"><thead><tr><th>&nbsp;</th>';
    		foreach ($headersarray as $key => $header) {
    			echo "<th>$header</th>";
    		}
    		echo "</tr></thead><tbody>"; //end header row
    		while($row = $result->fetch_assoc())
    			{
    			echo '<tr><td>';
    			echo '<a href="renal/renal.php?scr=update_esrf&amp;zid='.$row["patzid"].'" >ESRF</a></td>';
    			foreach ($fieldsarray as $key => $field) {
    				echo '<td>'.$row["$field"].'</td>';
    			}
    			echo "</tr>";
    			}
    		echo "</tbody></table>";
    	} else {
    		echo "<br><br>No such ESRF patients found!";
    	}
    }
}
include 'incl/footer_incl.php';
?>
<script>
	$(document).ready(function() {
		$('.datatable').dataTable( {
			"bFilter": true,
			"bLengthChange": true,
			"bInfo": true,
        	"iDisplayLength": 50,
        	"aLengthMenu": [[10,20,40, 50, 100, -1], [10,20,40, 50, 100, "All"]],
			"bPaginate": true,
			"sPaginationType": "bootstrap"
		});
	} );
</script>