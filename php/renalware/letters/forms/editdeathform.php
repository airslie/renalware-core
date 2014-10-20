<?php
$legend="Edit DEATH NOTIFICATION ID $letter_id";
?>
<form action="letters/rundischedit.php" method="post">
	<fieldset class="letter">
<legend><?php echo $legend ?></legend>
<input type="hidden" name="letterzid" value="<?php echo $zid; ?>" />
<input type="hidden" name="letter_id" value="<?php echo $letter_id; ?>" />
<input type="hidden" name="admissionid" value="<?php echo $admissionid; ?>" />
<input type="hidden" name="lettertype" value="death" />
<br>
<p><label>Letter Date:</label> <?php echo $letterdate; ?></p>
<p><label>Admitted Date:</label> <?php echo $admdate; ?></p>
<p><label>Date of Death:</label> <?php echo $dischdate; ?></p>
<p><label>Description:</label> DEATH NOTIFICATION</p>
<p><label>Author:</label> <?php echo $authorsig; ?></p>
<p><label>Change Author:</label> <select name="authorid">
<?php
	echo '<option value="' . $authorid . '">' . $authorlastfirst . '</option>';
//fill author list
	$sql= "SELECT uid, userlast, userfirst FROM userdata WHERE authorflag=1 ORDER BY userlast, userfirst";
	$result = $mysqli->query($sql);
	while ($row = $result->fetch_row()) {
	echo '<option value="' . $row['0'] . '">' . $row['1'] . ', ' . $row['2'] . "</option>";
	}
?>
</select></p>
<?php
//fix salut
$namewords = explode(" ", $recipname);
$no_namewords = count($namewords) - 1;
$title_lastname = $namewords[0] . ' ' . $namewords[$no_namewords]; //??!!
if (!$salut)
	{
	$salutvalue = "Dear " . $recipname;
	}
else
	{
	$salutvalue = $salut;
	}
?>
<p><label>Recipient (GP):</label></p>
<textarea name="recipient" rows="6" cols="50">
<?php echo $recipient; ?>
</textarea>
<br>
<p><input type="text" name="salut" size="30" value="<?php echo $salutvalue; ?>" /></p>
<p><b><u><?php echo $patref; ?><br>
<?php echo $pataddr; ?></u></b></p>
<input type="submit" style="color: purple;" value="SAVE/REFRESH DRAFT if desired" />
<table border="0" cellpadding="4"><tr>
<td class="lttr"><b>Problem List</b> &nbsp; &nbsp;<i><a href="pat/patient.php?vw=problems&amp;menu=hide&amp;win=new&amp;zid=<?php echo $zid; ?>" >update</a></i><br><?php echo nl2br($problist); ?></td>
</tr></table>
<p><label>Recent Investigations (IMPORTANT: Results displayed below only appear in KCH letters)</label>: <i>Add/edit as needed</i></p>
<textarea name="lettresults" rows="6" cols="100">
<?php echo $lettresults; ?>
</textarea><br>
<p><label>Allergies</label>: <?php echo $lettallergies; ?></p>
<br>
<p><label>Reason For Admission</label></p>
<textarea name="reason" rows="3" cols="100">
<?php echo $reason; ?>
</textarea><br>
<p><label>Cause of Death</label></p>
<textarea name="deathcause" rows="3" cols="100">
<?php echo $deathcause; ?>
</textarea>
<br>
<p><label for="ltext">Letter Text</label></p>
<textarea name="ltext" id="ltext" rows="40" cols="100"><?php echo $ltext; ?></textarea>
<br>
<input type="submit" style="color: purple;" value="SAVE/REFRESH DRAFT if desired (and return here)" /><br>
Yours sincerely,
<br><br>
<?php echo "<b>$authorsig</b> <br>$position"; ?>
<?php
include "$rwarepath/letters/incl/ccsfieldset_incl.php";
include "$rwarepath/letters/incl/statusfieldset_incl.php";
?>
<input type="submit" style="color: green;" value="CONTINUE" />
</fieldset>
</form>