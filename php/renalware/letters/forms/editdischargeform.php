<?php
$legend= "Edit Discharge Summary ID $letter_id ($lettdescr)";
?>
<form action="letters/rundischedit.php" method="post">
<fieldset class="letter">
<legend><?php echo $legend ?></legend>
<input type="hidden" name="letterzid" value="<?php echo $zid; ?>" />
<input type="hidden" name="letter_id" value="<?php echo $letter_id; ?>" />
<input type="hidden" name="admissionid" value="<?php echo $admissionid; ?>" />
<input type="hidden" name="lettertype" value="discharge" />
<br>
<p><label>Letter Date:</label> <?php echo $letterdate; ?></p>
<p><label>Admitted Date:</label> <?php echo $admdate; ?></p>
<p><label>Discharge Date:</label> <?php echo $dischdate; ?></p>
<p><label>Description:</label> DISCHARGE SUMMARY</p>
<p><label>Author:</label> <?php echo $authorsig; ?></p>
<p><label>Change Author:</label> <select name="authorid">
<?php
	echo '<option value="' . $authorid . '">' . $authorlastfirst . '</option>';
//fill author list
	$sql= "SELECT uid, userlast, userfirst FROM userdata WHERE authorflag=1 ORDER BY userlast, userfirst";
$result = $mysqli->query($sql);
	while ($row = $result->fetch_array(MYSQLI_NUM)) {
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
<p><input type="text" name="salut" size="50" value="<?php echo $salutvalue; ?>" /></p>
<p><b><u><?php echo $patref; ?><br>
<?php echo $pataddr; ?></u></b></p>
<p><input type="submit" style="color: purple;" value="SAVE/REFRESH DRAFT if desired" /></p>
<?php
include "$rwarepath/letters/incl/probsmedspath_links.php";
include "$rwarepath/letters/incl/showprobsmeds_incl.php";
?>
<p><label>Recent Investigations (IMPORTANT: Results displayed below only appear in KCH letters)</label>: <i>Add/edit as needed</i></p>
<textarea name="lettresults" rows="4" cols="100">
<?php echo $lettresults; ?>
</textarea><br>
<p><label>Allergies</label>: <?php echo $lettallergies; ?></p>
<p><label>Reason For Admission</label></p>
<textarea name="reason" rows="3" cols="100">
<?php echo $reason; ?>
</textarea>
<p><label for="ltext">Letter text</label></p>
<textarea name="ltext" id="ltext" rows="40" cols="100"><?php echo $ltext; ?></textarea>
<br>
<p><input type="submit" style="color: purple;" value="SAVE/REFRESH DRAFT if desired (and return here)" /></p>
Yours sincerely,
<br><br>
<?php echo "<b>$authorsig</b><br>$position"; ?>
<?php
include "$rwarepath/letters/incl/ccsfieldset_incl.php";
include "$rwarepath/letters/incl/statusfieldset_incl.php";
?>
<input type="submit" style="color: green;" value="CONTINUE" />
</fieldset>
</form>