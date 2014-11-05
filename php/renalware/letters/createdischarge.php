<?php
include '../req/confcheckfxns.php';
$zid = $_GET['zid'];
//get pat data
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/letters/data/letterpatdata.php";
include "$rwarepath/letters/data/letterpatholdata.php";
include "$rwarepath/data/currentclindata.php";
$pagetitle= "Create New Discharge Summary/Death Notif for $patfirstlast";
//get header
include '../parts/head.php';
?>
<form action="letters/run/runcreatedischarge.php" method="post">
	<fieldset class="letter">
		<legend>Create New Discharge Summary/Death Notif for <?php echo $patfirstlast ?></legend>
		<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p><br>
	<input type="hidden" name="zid" value="<?php echo $zid; ?>" />
	<p class="alertsmall">Note: DEATH NOTIFICATION is only an option for patients with a modality of "death"!</p>		
	<p><label>Letter Type</label><br>
	<input type="radio" name="lettertype" value="discharge" checked="checked" />Discharge Summary
	<?php if ($modalcode=="death"): ?>
		 or <br>
		<input type="radio" name="lettertype" value="death" />Death Notification for Admission: &nbsp;&nbsp;		
	<?php endif ?>
	<select name="admid">
	<?php if (!$get_admissionid): ?>
		<option value="">Select <?php echo $patfirstlast; ?> admission</option>
	<?php endif ?>
	<?php
	$where = ($get_admissionid) ? "WHERE admission_id=$get_admissionid LIMIT 1" : "WHERE admzid=$zid AND admittedflag=0" ;
	$sql="SELECT admission_id, admdate, dischdate, admward FROM admissiondata $where";
	$result = $mysqli->query($sql);
	while($row = $result->fetch_row()) {
	echo '<option value="' . $row['0'] . '">Adm ' . dmyyyy($row['1']) . " to " . $row['3'] . " &amp; disch on " . dmyyyy($row['2']) . "</option>";
	}
	?></select></p>
	<p><label>Letter Date:</label><input name="letterdate" id="" type="text" value="<?php echo date('d/m/Y'); ?>" /></p>
	<p><label>Author*:</label> <select name="authorid">
	<?php
	if ($sess_letterdetails)
		{
		echo '<option value="' . $_SESSION['authorid'] . '">' . $_SESSION['authorlastfirst'] . '</option>';
		}
	else
		{
		echo "<option value=\"$uid\">$user [default]</option>";
		}
	//fill author list
		$sql= "SELECT uid, userlast, userfirst FROM userdata WHERE authorflag=1 ORDER BY userlast, userfirst";
		$result = $mysqli->query($sql);
		while ($row = $result->fetch_array(MYSQLI_NUM)) {
		echo '<option value="' . $row['0'] . '">' . $row['1'] . ', ' . $row['2'] . "</option>";
		}
	?>
	</select></p>
	<p><label>Typist:</label><input type="hidden" name="typistid" value="<?php echo $uid; ?>" /><?php echo $user; ?> [default]</p>
	<p><label>Recipient (GP):</label> <i><a href="pat/form.php?f=update_patient&amp;zid=<?php echo $zid; ?>" >update GP/patient details</a> (new window)</i></p>
<textarea name="gpreciptext" rows="5" cols="30" ><?php echo $gpblock; ?></textarea><br>
	<p><b><u><?php echo $patref; ?><br>
	<?php echo $pataddrhoriz; ?></u></b></p>
<p><label>Reason for Admission:</label></p>
<textarea id="" name="reason" rows="2" cols="80" ></textarea><br><br>
<p><label>Cause of Death (if Death Notif):</label></p>
<textarea id="" name="deathcause" rows="2" cols="80" ></textarea><br><br>
<?php include 'incl/showprobsmeds_incl.php'; ?>
<input  type="submit" name="create" value="Continue to next screen (to edit probs/meds now)" /><br>
<p><label>Recent Investigations (IMPORTANT: Results displayed below only appear in KCH letters)</label>: <?php echo $current_lettresults; ?></p>
<p><label>Allergies</label>: <?php echo $allergies; ?></p>
<p><label>Use Template?</label>&nbsp;&nbsp;<select name="templateid">
<option value="">Select from <?php echo $user; ?>&rsquo;s templates...</option>
<?php
$popcode="template_id";
$popname="templatename";
$popwhere="templateuid=$uid";
$poptable="lettertemplates";
include('../incl/limitedoptions.php');
?>
</select></p>
	<textarea name="ltext" rows="30" cols="100" ></textarea>
	</fieldset><br>
<p><input  type="submit" name="create" value="Review Draft and add CCs..." /></p>
</form>
</body>
</html>
