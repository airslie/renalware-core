<?php
//----Tue 05 Mar 2013----now mode style
//show probs, meds per specs
echo '</div>
<div class="clear">
	<table class="probsmeds"><tr><td>';
include '../portals/problemsportal.php';
echo '</td><td>';
include '../portals/currmedsportal.php';
echo '</td></tr></table>
</div>';
//maps
include 'aki/aki_config.php';
$akipatflag=false; //to flag those w akidata
//get latest AKI episode data unless GET show=id
$showlabel="Latest AKI Episode";
$sql = "SELECT * FROM akidata WHERE akizid=$zid ORDER BY episodedate DESC LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
    $akipatflag=true;
	$row = $result->fetch_assoc();
	foreach ($row as $key => $value) {
		$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
    $thisid=$aki_id;
    //display latest
    echo "<h3>$showlabel: $episodedate</h3>";
    include 'aki/incl_akinav.php';
    echo '<div id="episodesummdiv">';
 //   echo "<p>$update or $view this episode</p>";
    echo '<ul class="portal">';
    echo "<li><b>Entered:</b> $akistamp &nbsp;&nbsp;
<b>Updated:</b> $akimodifdt &nbsp;&nbsp;
<b>User:</b> $akiuser &nbsp;&nbsp;
<b>Episode date:</b> $episodedate &nbsp;&nbsp;
<b>referral date:</b> $referraldate &nbsp;&nbsp;
<b>admission method:</b> $admissionmethod </li>
<li>CURRENT RISK SCORE: $akiriskscore</li>
<li><b>elderly:</b> $elderlyflag &nbsp;&nbsp;
<b>Existing CDK:</b> $existingckdflag &nbsp;&nbsp;
<b>CKD Status:</b> $ckdstatus &nbsp;&nbsp;
<b>Cardiac Failure:</b> $cardiacfailureflag &nbsp;&nbsp;
<b>diabetes:</b> $diabetesflag &nbsp;&nbsp;
<b>liver disease:</b> $liverdiseaseflag &nbsp;&nbsp;
<b>vascular disease:</b> $vasculardiseaseflag &nbsp;&nbsp;
<b>nephrotoxic meds:</b> $nephrotoxicmedflag</li>";
/*
<b>cre_baseline:</b> $cre_baseline 
<b>cre_peak:</b> $cre_peak 
<b>egfr_baseline:</b> $egfr_baseline 
<b>urineoutput:</b> $urineoutput 
<b>urineblood:</b> $urineblood 
<b>urineprotein:</b> $urineprotein 
<b>akinstage:</b> $akinstage 
<b>stopdiagnosis:</b> $stopdiagnosis 
<b>stopsubtype:</b> $stopsubtype 
<b>stopsubtypenotes:</b> $stopsubtypenotes 
<b>akicode:</b> $akicode 
<b>ituflag:</b> $ituflag 
<b>itudate:</b> $itudate 
<b>renalunittx:</b> $renalunittx 
<b>renalunittxdate:</b> $renalunittxdate 
<b>itustepdownflag:</b> $itustepdownflag 
<b>renalunitrrt:</b> $renalunitrrt 
<b>rrttype:</b> $rrttype 
<b>rrtduration:</b> $rrtduration 
<b>mgtnotes:</b> $mgtnotes 
<b>akioutcome:</b> $akioutcome 
<b>ussflag:</b> $ussflag 
<b>ussdate:</b> $ussdate 
<b>ussnotes:</b> $ussnotes 
<b>biopsyflag:</b> $biopsyflag 
<b>biopsydate:</b> $biopsydate 
<b>biopsynotes:</b> $biopsynotes 
<b>otherix:</b> $otherix 
<b>akinotes:</b> $akinotes ";
*/
    echo '</ul>';
}
//end summdiv
echo '</div>
</div>';
//episodes portal -- allows selection of other than most recent episode
if ($akipatflag) {
    echo '<h3>AKI Episodes (latest at top)</h3>';
   include 'aki/akiepisodes_portal.php';
}
