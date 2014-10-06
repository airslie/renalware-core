<?php
//----Fri 05 Sep 2014----split update form off into update_esrf.php
//----Wed 06 Aug 2014----handle new RReg PRD codes/terms
//----Thu 27 Jun 2013----EpisodeHrtDis added
//refresh data
include '../data/esrfdata.php';
?>
<h3>ESRF Summary Info</h3>
<p><a href="renal/renal.php?zid=<?php echo $zid ?>&amp;scr=update_esrf">Update ESRF/Renal Reg Info (last updated: <?php echo $esrfmodifstamp ?>)</a></p>

<table class="datalist">
	<tr><td class="l">ESRF date</td><td>&nbsp;&nbsp;<?php echo $endstagedate; ?></td></tr>
	<tr><td class="l">ESRF cause (DEPR)</td><td>&nbsp;&nbsp;<?php echo $EDTAtext; ?></td></tr>
	<tr><td class="l">PRD code/text</td><td>&nbsp;&nbsp;<?php echo "$rreg_prdcode: $prdterm"; ?></td></tr>
    <?php
    //----Thu 27 Jun 2013----display curr data
    $comorbidcodes = array(
    'firstseendate',
    'esrfweight',
    'Angina',
    'PreviousMIlast90d',
    'PreviousMIover90d',
    'PreviousCAGB',
    'EpisodeHeartFailure',
    'Smoking',
    'COPD',
    'CVDsympt',
    'DiabetesNotCauseESRF',
    'Malignancy',
    'LiverDisease',
    'Claudication',
    'IschNeuropathUlcers',
    'AngioplastyNonCoron',
    'AmputationPVD',
    );
    foreach ($comorbidcodes as $code) {
        $codeval=${$code};
    echo '<tr><td class="l">'.$code.'</td><td>&nbsp;&nbsp;'.$codeval.'</td></tr>';
    }
    ?>
</table>
