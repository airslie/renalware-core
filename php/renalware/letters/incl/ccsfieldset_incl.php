	<p class="hilite">Note: All non-GP letters are CCed to GP by default. Remove manually in special cases.</p>
	<?php if (strlen($cctext)>5): ?>
		<p><label>Clear all CCs?</label><input type="checkbox" name="clearccs" value="Y" id="clearccs">Yes (after refresh/save)</p>
	<?php endif ?>
	<textarea name="cctext" id="cctextarea" rows="15" cols="70" ><?php echo $cctext; ?></textarea><br>
<?php
//display eCCs list
$sql = "SELECT lettercc_id, recip_uid, authorsig, position FROM letterccdata JOIN userdata ON recip_uid=uid WHERE ccletter_id=$letter_id ORDER BY userlast, userfirst";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	echo '<b>Current Electronic CCs</b><br><ul class="none">';
	while($row = $result->fetch_assoc())
		{
			echo '<li>Delete CC?<input type="checkbox" name="deletecc_'.$row["lettercc_id"].'" value="'.$row["lettercc_id"].'" />&nbsp;&nbsp;<b>'.$row["authorsig"].'</b>, '.$row["position"].'</li>';
		}
	echo '</ul>';
}

?>
<input type="checkbox" onclick='$("#editdefaultccsdiv").toggle();' />edit/update/Copy &amp; Paste from Default CCs <br>
<div id="editdefaultccsdiv" style="display: none">
	<b>You may edit this patient's "Default CCs" here</b><br><i>Note this will not update/affect the CC field above</i><br>
	<textarea style="background: #fff;" id="editdefaultccs" name="editdefaultccs" rows="15" cols="50" ><?php echo $defaultccs; ?></textarea>
</div>
<p><input type="checkbox" onclick='$("#addelectrccsdiv").toggle();' />Add "Electronic CCs" [To KRU staff only]</p>
<div id="addelectrccsdiv" style="display: none">
	<b>Select staff for electronic CCs (Use control-click [Mac: command-click] to add more than one)</b><br>
	<select name="electrccs[]" id="electrccs" multiple size="6">
<?php
//CCs
//get prior CCs for this zid
$sql = "SELECT DISTINCT recip_uid, CONCAT(userlast,', ',userfirst) as stafflastfirst, position FROM letterccdata JOIN userdata ON recip_uid=uid WHERE cczid=$zid AND expiredflag='0' ORDER BY userlast,userfirst";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	echo '<optgroup label="Previous patient CCs">';
	while($row = $result->fetch_assoc())
		{
			echo '<option value="'.$row["recip_uid"].'">'.$row["stafflastfirst"].', '.$row["position"].'</option>';
		}
	echo '</optgroup>';
}
$result->close();
//get prior CCs for this user
$sql = "SELECT DISTINCT recip_uid, CONCAT(userlast,', ',userfirst) as stafflastfirst, position FROM letterccdata JOIN userdata ON recip_uid=uid WHERE cc_uid=$uid AND expiredflag='0' ORDER BY userlast,userfirst";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	echo '<optgroup label="Previous '.$user.' CCs">';
	while($row = $result->fetch_assoc())
		{
			echo '<option value="'.$row["recip_uid"].'">'.$row["stafflastfirst"].', '.$row["position"].'</option>';
		}
	echo '</optgroup>';
}
$result->close();
$sql = "SELECT uid, userlast, userfirst, position FROM userdata WHERE expiredflag='0' ORDER BY userlast, userfirst";
$result = $mysqli->query($sql);
echo '<optgroup label="Current '.$siteshort.' Staff">';

while($row = $result->fetch_assoc())
	{
		echo '<option value="'.$row["uid"].'">'.$row["userlast"].', '.$row["userfirst"].', '.$row["position"].'</option>';
	}
$result->close();
echo '</optgroup>';
?>	
	</select>
</div>