<?php
//----Tue 15 Feb 2011----mrsatestdate fix
//to add height in vw; may expand to others
if ($get_update=="renaldata")
	{
	include 'run/renaldata_update.php';
} // end update IF
if ($_GET['update']=="death")
	{
	$deathDate = $mysqli->real_escape_string($_POST["deathDate"]);
	$deathnotes = $mysqli->real_escape_string($_POST["deathnotes"]);
	$deathDate = fixDate($deathDate);	
	$deathCauseEDTA1 = $_POST["deathCauseEDTA1"];
	$deathCauseEDTA2 = $_POST["deathCauseEDTA2"];
	//get death cause text
	if ( $deathCauseEDTA1 )
	{
	$sql= "SELECT edtacause FROM edtadeathcodes WHERE edtacode='$deathCauseEDTA1'";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$deathcausetext1=$row["edtacause"];
	}
	if ( $deathCauseEDTA2 )
	{
	$sql= "SELECT edtacause FROM edtadeathcodes WHERE edtacode='$deathCauseEDTA2'";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$deathcausetext2=$row["edtacause"];
	}
	//update the table
	//nb deathdate no longer in renaldata Tue Mar 21 09:09:44 JST 2006
	$tables = 'renaldata';
	$where = "WHERE renalzid=$zid";
	$updatefields = "deathCauseEDTA1='$deathCauseEDTA1', deathCauseEDTA2='$deathCauseEDTA2', deathCauseText1='$deathcausetext1',  deathCauseText2='$deathcausetext2', deathnotes='$deathnotes'";
	$sql= "UPDATE $tables SET $updatefields $where";
	$result = $mysqli->query($sql);
//log the event
	$eventtype="Patient Renal Death Data entered";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
//update patientdata
$tables = 'renalware.patientdata';
$where = "WHERE patzid=$zid";
$updatefields = "deathdate='$deathDate'";
$sql= "UPDATE $tables SET $updatefields $where";
$result = $mysqli->query($sql);
//move to modals page
header("Location: ../pat/patient.php?vw=modals&zid=$zid");
} // end update IF

//refresh data
include "$rwarepath/data/renaldata.php";
include "$rwarepath/data/esddata.php";
$showheight = ($Height) ? $Height.'m' : "UNKNOWN" ;
?>
<div id="uitabs">
	<ul>
		<li><a href="#infodiv">Renal Summary</a></li>
		<li><a href="#updateformdiv">Update Info</a></li>
		<li><a href="#updatehtformdiv">Update Height</a></li>
		<li><a href="#updatedeathformdiv">Update Death Info</a></li>
	</ul>
	<div id="infodiv">
		<ul class="portalvert">
		<?php
		$basket = array(
			'clinAlcoholHx'=>'Alcohol Hx',
			'clinAllergies'=>'Allergies',
			'clinCormorbidity'=>'Cormorbidity',
			'clinFamilyHx'=>'Family Hx',
			'clinHLAType'=>'HLA Type',
			'clinMRSAstatus'=>'MRSA status',
			'clinMRSAtestDate'=>'MRSA test Date',
			'clinSmokingHx'=>'Smoking Hx',
			'clinSocialHx'=>'Social Hx',
			'diabetesflag'=>'Diabetes',
			'hivflag'=>'HIV',
			'hbvflag'=>'HBV',
			'hcvflag'=>'HCV',
		);
		foreach ($basket as $fld => $label) {
			$result=${$fld};
				echo "<li><b>$label:</b>&nbsp;&nbsp;$result</li>\n";
		}
		?>
			<li><b>death Date</b>&nbsp;&nbsp;<?php echo $deathdate; ?></li>
			<li><b>death CauseText1</b>&nbsp;&nbsp;<?php echo $deathCauseText1; ?></li>
			<li><b>death CauseText2</b>&nbsp;&nbsp;<?php echo $deathCauseText2; ?></li>
			<li><b>death notes</b>&nbsp;&nbsp;<?php echo $deathnotes; ?></li>
			<li><b>Current Access</b>&nbsp;&nbsp;<?php echo $accessCurrent; ?></li>
			<li><b>Date formed</b>&nbsp;&nbsp;<?php echo $accessCurrDate; ?></li>
			<li><b>ESA Status</b>&nbsp;&nbsp;<?php echo $esdstatus; ?></li>
			<li><b>ESA Date Modified</b>&nbsp;&nbsp;<?php echo $esdmodifdate; ?></li>
			<li><b>ESA regime</b>&nbsp;&nbsp;<?php echo $esdregime; ?></li>
			<li><b>ESRF date</b>&nbsp;&nbsp;<?php echo $endstagedate; ?></li>
			<li><b>ESRF cause</b>&nbsp;&nbsp;<?php echo $EDTAtext; ?></li>
			<li><b>Tx Wait List Status</b>&nbsp;&nbsp;<?php echo $txWaitListStatus; ?></li>
			<li><b>Wait List Entry Date</b>&nbsp;&nbsp;<?php echo $txWaitListEntryDate; ?></li>
			<li><b>CAPD Assessment</b>&nbsp;&nbsp;<?php
			include( '../renal/pd/getworkupdata.php' );
			$workupmode = ($workup_id) ? "view" : "create" ;
			echo '<a href="renal/pd/workup.php?zid=' . $zid . '&amp;mode='.$workupmode.'">'.$workupmode.' PD Assess '.$workupdate.'</a>';
		?></li>
		</ul>
	</div>
	<div id="updateformdiv">
	<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=renalsumm&amp;update=renaldata" method="post">
		<fieldset>
		<legend>Update renal/clinical data for <?php echo $title . ' ' . $lastname; ?></legend>
		<ul class="form">
		<?php
		inputText("clinAlcoholHx","Alcohol Hx",100,$clinAlcoholHx);
		inputText("clinAllergies","Allergies",100,$clinAllergies);
		inputText("clinCormorbidity","Cormorbidity",100,$clinCormorbidity);
		inputText("clinFamilyHx","Family Hx",100,$clinFamilyHx);
		inputText("clinHLAType","HLA Type",100,$clinHLAType);
		inputText("clinMRSAstatus","MRSA status",20,$clinMRSAstatus);
		pickupDate("clinMRSAtestDate","MRSA test date",$clinMRSAtestDate);
		inputText("clinSmokingHx","Smoking Hx",50,$clinSmokingHx);
		inputText("clinSocialHx","Social Hx",50,$clinSocialHx);
		makeRadios("diabetesflag","Diabetes?",$diabetesflag, $yesno);
		makeRadios("hivflag","HIV?",$hivflag, $yesno);
		makeRadios("hbvflag","HBV?",$hbvflag, $yesno);
		makeRadios("hcvflag","HCV?",$hcvflag, $yesno);
		?>
		<li class="submit"><input type="submit" style="color: green;" value="Update Data" /></li>
		</ul>
		</fieldset>
	</form>
	</div>
	<div id="updatehtformdiv">
	<form action="renal/renal.php?scr=renalsumm&amp;zid=<?php echo $zid; ?>&amp;update=height" method="post">
		<fieldset>
		<legend>Update Height</legend>
		<ul class="form">
		<li><label for="newheight">Height (m)</label><input type="text" size="4" name="newheight" value="<?php echo $Height; ?>"></li>
		<li><label for="newheightdate">Height Date</label><input type="text" size="14" name="newheightdate" value="<?php echo date("d/m/Y") ?>" class="datepicker" /></li>
		<li class="submit"><input type="submit" style="color: green;" value="Update Height" /></li>
		</ul>
		</fieldset>
	</form>
	</div>
	<div id="updatedeathformdiv">
		<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=renalsumm&amp;update=death" method="post">
		<fieldset>
			<legend>Edit Date &amp; Cause of Death</legend>
		<b>Note: After submitting these data you can update the modalities page if needed.</b><br>
		<ul class="form">
		<li><label for="deathdate">deathDate</label><input type="text" name="deathDate" size="12" value="<?php echo $deathdate; ?>" class="datepicker" /></li>
		<li><label for="deathCauseEDTA1">EDTA Cause of Death (1)</label><select name="deathCauseEDTA1">
			<?php
			//make single edtadeathcodes options
			$deathcauseoptions="";
			$sql= "SELECT edtacode, edtacause FROM edtadeathcodes";
			$result = $mysqli->query($sql);
			$numrows=$result->num_rows;
			while($row = $result->fetch_assoc())
				{
				$deathcauseoptions.='<option value="'.$row["edtacode"].'">'.$row["edtacause"].'</option>'."\r";
				}
			$result->close();
			
			if ( $deathCauseEDTA1 )
			{
			echo "<option value=\"$deathCauseEDTA1\">$deathCauseText1</option>";
			}
			else
			{
			echo "<option value=\"\">Select 1st EDTA Cause of Death</option>";	
			}
			echo "$deathcauseoptions";
			?>
		</select></li>
		<li><label for="deathCauseEDTA2">EDTA Cause of Death (2)</label><select name="deathCauseEDTA2">
			<?php
			if ( $deathCauseEDTA2 )
			{
			echo "<option value=\"$deathCauseEDTA2\">$deathCauseText2</option>";
			}
			else
			{
			echo "<option value=\"\">Select 2nd EDTA Cause of Death</option>";	
			}
			echo "$deathcauseoptions";
			?>
		</select></li>
		<li><label for="deathnotes">death notes</label><input type="text" name="deathnotes" size="100" /></li>
		<li class="submit"><input type="submit" style="color: green;" value="Update death info" /></li>
		</ul>
		</fieldset>
		</form>
	</div>
</div>
