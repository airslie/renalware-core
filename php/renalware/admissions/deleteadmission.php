<?php
//Thu Nov 19 15:30:50 CET 2009
include '../req/confcheckfxns.php';
$admid=$_GET['admid'];
$pagetitle= "Delete Admission ID $admid";
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
admmodal
";
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
	<form action="admissions/run/run_deleteadmission.php" method="post">
	<fieldset>
		<legend>Delete/Cancel Admission</legend>
		<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p>
		<p>Use this if a patient has duplicate admissions from the EPR feed.</p>
		<ul>
		<input type="hidden" name="admid" value="<?php echo $admid; ?>" />
		<li><label>Admission ID</label>&nbsp;&nbsp;<?php echo $admid; ?></li>
		<li><label>patient</label>&nbsp;&nbsp;<?php echo "$firstnames $lastname"; ?></li>
		<li><label>curr ward</label>&nbsp;&nbsp;<?php echo $currward; ?></li>
		<li><label>admdate</label>&nbsp;&nbsp;<?php echo $admdate; ?></li>
		<li><label>Adm modal/code*</label>&nbsp;&nbsp;<?php echo $admmodal; ?></li>
		<li><label>admward</label>&nbsp;&nbsp;<?php echo $admward; ?></li>
		<li><label>consultant</label>&nbsp;&nbsp;<?php echo $consultant ?></li>
		<li><label>Type</label>&nbsp;&nbsp;<?php echo $admtype; ?></li>
		<li><label>disch date</label>&nbsp;&nbsp;<?php echo $dischdate; ?></li>
		<li><label>destination</label>&nbsp;&nbsp;<?php echo $dischdest; ?></li>
		<li><label>Reason</label>&nbsp;&nbsp;<select name="admstatus" id="admstatus">
			<option value="Cancelled">Indicate whether Deleted/Cancelled (Default)</option>
			<option value="Deleted">Deleted--incorrect manual data entry</option>
			<option value="Cancelled">Cancelled--multiple EPR entries or Cancelled admission</option>
		</select></li>
		<li><label>Confirm</label>&nbsp;&nbsp;<input type="checkbox" name="deleteflag" value="yes" />Yes <i>DELETE/CANCEL-- CAUTION CANNOT BE UNDONE.</i></li>
		<li class="submit"><input type="submit" style="color: green;" value="Delete/Cancel Admission" /></li>
	</ul>
	</fieldset>
	</form>
<?php else: ?>
	<p>Apologies, you do not have access to this screen!</p>
<?php endif ?>
<?php
include '../parts/footer.php';
?>