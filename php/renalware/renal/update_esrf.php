<?php
//----Fri 05 Sep 2014----split from esrf.php
//----Wed 06 Aug 2014----handle new RReg PRD codes/terms
//----Thu 27 Jun 2013----EpisodeHrtDis added
//refresh data
include '../data/esrfdata.php';
?>
<h3>Update ESRF Information</h3>
<p><a href="renal/renal.php?zid=<?php echo $zid ?>&amp;scr=esrf">Return to ESRF Summary</a></p>
<div>
	<form action="renal/run/update_endstagedate.php" method="post">
	    <input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
	<fieldset>
		<legend>ESRF Date</legend>
	<ul class="form">
	<li><label>ESRF date</label>&nbsp;&nbsp;<input type="text" name="endstagedate" value="<?php echo $endstagedate; ?>" size="12" class="datepicker"/></li>
	</ul>
	<input type="submit" class="btn btn-small btn-success" value="Enter ESRF Date" />
	</fieldset>
	</form>
    <form action="renal/renal.php" method="get" accept-charset="utf-8">
    <input type="hidden" name="zid" value="<?php echo $zid ?>" />
    <input type="hidden" name="scr" value="update_esrf" />
    <fieldset>
    	<legend>Filter new Renal Reg PRD codes</legend>
    	<label for="prdkeyword">Term or keyword (e.g. <tt>HIV</tt> or <tt>diabetes</tt>)</label><input type="text" name="prdkeyword" id="prdkeyword" size="24" value="<?php echo $get_prdkeyword ?>" /><br>
    		<input type="submit" style="color: green;" value="Filter PRD Codes" />
    </fieldset>
    </form>
	<?php if ($esrfflag OR $endstagedate): ?>
	<form action="renal/run/update_esrfdata.php" method="post">
	    <input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
	   <input type="hidden" name="EDTAcode" value="<?php echo $EDTAcode ?>" id="edtacode" />
	<fieldset>
		<legend>Core ESRF data</legend>
	<ul class="form">
	<li><label>Date First Seen</label>&nbsp;&nbsp;<input type="text" name="firstseendate" value="<?php echo $firstseendate ?>" size="12" class="datepicker"/></li>
	<li><label>Weight at First Rx</label>&nbsp;&nbsp;<input type="text" name="esrfweight" value="<?php echo $esrfweight; ?>" size="4" /> <i>kg</i></li>
	<li><label>Old EDTA code (DEPR)</label>&nbsp;&nbsp;<?php echo $EDTAtext ?></li>
    	<li><label>New PRD code (RenalReg)</label>&nbsp;&nbsp;<select name="rreg_prdcode">
    		<?php if ($rreg_prdcode): ?>
    			<option value="<?php echo $rreg_prdcode ?>"><?php echo $prdterm ?></option>
    		<?php else: ?>
    			<option value="">Select Primary Renal Disease (PRD)</option>
    		<?php endif ?>
    		<?php
            //handle filter
            $where="";
            if ($get_prdkeyword) {
            	$keyword = $mysqli->real_escape_string($get_prdkeyword);
                $where = "WHERE prdterm LIKE '%$keyword%'";
            }
    		$sql= "SELECT * FROM rreg_prdcodes $where ORDER BY id";
    		$result = $mysqli->query($sql);
    		while($row = $result->fetch_assoc()) {
    		echo '<option value="' . $row['prdcode'] . '">'.$row["prdcode"].'--' . $row['prdterm'] . "</option>";
    		}
    		?></select></li>
	</ul>
	<input type="submit" class="btn btn-small btn-success" value="Update core ESRF Details" /><br><br>
    <a class="btn btn-small btn-success" onclick='$("#problemsdiv").toggle();'>Toggle Problem List</a>
     <div id ="problemsdiv" style="display: none; border: 1px solid #333; margin: 3px;">
    <?php
    include '../portals/problemsportal.php';
    ?>
     </div>
	</fieldset>
	</form>
	<form action="renal/run/run_comorbidityupdate.php" method="post">
	    <input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
	<fieldset>
	<legend>Comorbidity Data (Defaults=NO)</legend>
	<ul class="form">
<?php
//----Thu 27 Jun 2013----scripted
$comorbidcodes = array(
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
    if ($codeval=='Y') {
        echo '<li><label>'.$code.'</label>&nbsp;&nbsp;<input type="radio" name="'.$code.'" value="N" />No &nbsp; &nbsp; <input type="radio" name="'.$code.'" checked="checked" value="Y" />Yes</li>';
    } else {
        echo '<li><label>'.$code.'</label>&nbsp;&nbsp;<input type="radio" name="'.$code.'" checked="checked" value="N" />No &nbsp; &nbsp; <input type="radio" name="'.$code.'" value="Y" />Yes</li>';
    }
}
?>
	</ul>
	<input type="submit" class="btn btn-small btn-success" value="Update comorbidity fields" />
	</fieldset>
	</form>
	<?php endif ?>
</div>

