<?php
include '../req/confcheckfxns.php';
$admid=$_GET['admid'];
$pagetitle= "Edit Admission ID $admid";
include '../navs/topnonav.php';
//get data
$fields = "
admdate,
admward,
consultant,
admtype,
reason,
transferward,
a.transferdate,
dischdate,
dischdest,
lastname,
firstnames,
currward,
admmodal";
$tables = "admissiondata a JOIN patientdata p on admzid=patzid";
$where = "WHERE admission_id=$admid";
$sql= "SELECT $fields FROM $tables $where LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
	$admdate=dmy($row["admdate"]);
	$admward=$row["admward"];
	$admmodal=$row["admmodal"];
	$currward=$row["currward"];
	$consultant=$row["consultant"];
	$admtype=$row["admtype"];
	$reason=$row["reason"];
	$transferward=$row["transferward"];
	$transferdate=dmy($row["transferdate"]);
	$dischdate=dmy($row["dischdate"]);
	$dischdest=$row["dischdest"];
	$lastname=$row["lastname"];
	$firstnames=$row["firstnames"];
?>
<?php if ($wardclerkflag): ?>
	<form action="admissions/run/run_updadmission.php" method="post">
	<fieldset>
		<legend>Update admission details</legend>
<ul class="form">
<li>	<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p>	
</li>		<input type="hidden" name="admid" value="<?php echo $admid; ?>" />
		<input type="hidden" name="currward" value="<?php echo $currward; ?>" />
		<li><label>Admission ID</label>&nbsp;&nbsp;<?php echo $admid; ?></li>
		<li><label>patient</label>&nbsp;&nbsp;<?php echo "$firstnames $lastname"; ?></li>
		<li><label>curr ward</label>&nbsp;&nbsp;<?php echo $currward; ?></li>
		<li><label>adm date</label>&nbsp;&nbsp;<input type="text" name="admdate" value="<?php echo $admdate; ?>" size="12" class="datepicker" /></li>
		<li><label>Adm modal/code*</label>&nbsp;&nbsp;<input type="text" name="admmodal" value="<?php echo $admmodal; ?>" size="12" /> <i>Note: changing modality/code here does not update main patient Modality</i></li>
		<li><label>admward</label>&nbsp;&nbsp;<input type="text" name="admward" value="<?php echo $admward; ?>" size="12" /></li>
		<li><label>consultant</label>&nbsp;&nbsp;
			<select name="consultant">
				<?php
				if ($consultant)
				{
				echo '<option>' . $consultant . '</option>';
				}
				else
				{
				echo '<option value="">Consultant</option>';
				}	
				?>
			<?php
			$popcode="userlast";
			$popname="userlast";
			$popwhere="consultantflag=1";
			$poptable="userdata";
			include('../incl/limitedoptions.php');
			?>
			</select></li>
		<li><label>Type</label>&nbsp;&nbsp;
			<select name="admtype">
			<option value="<?php echo $admtype; ?>"><?php echo $admtype; ?></option>
			<option value="Emergency">Emergency</option>
			<option value="A&amp;E">A&amp;E</option>
			<option value="Elective">Elective</option>
			<option value="Referral">Referral</option>
			<option value="ward">Other Ward</option>
			<option value="hospital">Other Hosp</option>
			<option value="ARF">ARF</option>
			<option value="Day">Day Case</option>
			<option value="Other">Other</option>
			</select></li>
		<li><label>reason</label>&nbsp;&nbsp;<input type="text" name="reason" value="<?php echo $reason; ?>" size="12" /></li>
			<li><label>TRANSFER?</label>&nbsp;&nbsp;<input type="radio" name="transferflag" value="1" />Yes &nbsp; &nbsp; <input type="radio" name="transferflag" value="0" />No</li>
			<li><label>transfer ward</label>&nbsp;&nbsp;
			<select name="transferward">
			<option value="<?php echo $transferward; ?>"><?php echo $transferward; ?></option>
			<option value="ITU">ITU</option>
			<?php
			$popcode="wardcode";
			$popname="ward";
			$poptable="wardlist";
			include('../incl/simpleoptions.php');
			?>
            <option value="fiskcheere">Fisk Ward</option>
            <option value="VPU">Victor Parsons Unit</option>
			</select>
			&nbsp;&nbsp;<b>Other ward:</b> <input type="text" name="transferwardother" size="12" /></li>
		<li><label>transfer date</label>&nbsp;&nbsp;<input type="text" name="transferdate" value="<?php echo $transferdate; ?>" size="12" class="datepicker" /></li>
		<li><label>disch date</label>&nbsp;&nbsp;<input type="text" name="dischdate" value="<?php echo $dischdate; ?>" size="12" class="datepicker" /></li>
		<li><label>destination</label>&nbsp;&nbsp;<input type="text" name="dischdest" value="<?php echo $dischdest; ?>" size="12" /></li>
		<li class="submit"><input type="submit" style="color: green;" value="Update Admission" /></li>
	</ul>
	</fieldset>
	</form>
<?php else: ?>
	<p>Apologies, you do not have access to this screen!</p>
<?php endif ?>
<?php
include '../parts/footer.php';
?>