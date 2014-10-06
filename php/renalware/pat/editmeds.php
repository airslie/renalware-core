<?php
//run any changes and display msg
?>
<h3>Edit/Delete/Add Medications</h3>
<?php
$pagevw="pat/patient.php?zid=$zid&amp;vw=editmeds";
if ($get_menu=="hide") {
	echo '<a class="ui-state-default" style="color: white; background: red; border: red;"  href="javascript:history.go(-1)">Cancel [Return to previous page]</a><br>';
}
if ($get_letter_id) {
	echo "&nbsp;&nbsp;<a class=\"ui-state-default\" style=\"color: green;\" href=\"letters/editletter.php?zid=$zid&amp;letter_id=$get_letter_id\">Return to Letter #$get_letter_id</a>";
	$pagevw="pat/patient.php?zid=$zid&amp;vw=editmeds&amp;letter_id=$get_letter_id&amp;menu=hide";
}
if ($get_mode=="addmed") {
		include( 'forms/addnewdrugform.html');
}
?>
<br>
<?php if ($get_addtype): ?>
	<form action="pat/patient.php" method="get" accept-charset="utf-8">
		<input type="hidden" name="vw" value="editmeds" id="vw" />
		<input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
	<?php if ($get_letter_id): ?>
		<input type="hidden" name="letter_id" value="<?php echo $get_letter_id ?>" id="letter_id" />
	<?php endif ?>
		<input type="submit" style="color: white; background: red; border: red;" value="Cancel">
	</form>
<?php endif ?>
<div id="immunosuppformdiv" style="display: none;">
	<?php
	include( 'forms/addnewimmunosuppform.html');
	?>
	<button class="ui-state-default" style="color: white; background: red;" onclick="flipImmunosupp();">Cancel Immunosuppressant</button>
</div>
<div id="esaformdiv" style="display: none;">
	<?php
include( 'forms/addnewesaform.html');
	?>
	<button class="ui-state-default" style="color: white; background: red;" onclick="flipESA();">Cancel ESA</button>
</div>

<?php
//--------Page Content Here----------
$sql = "SELECT medsdata_id, drugname, dose, route, freq, drugnotes, adddate, medmodal, esdflag,immunosuppflag, modifstamp,provider, DATEDIFF(CURDATE(),adddate) as drugdays FROM medsdata WHERE medzid=$zid AND termflag=0 ORDER BY drugname";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">Current Medications ($numrows)</p>";
if (!$numrows) {
	makeAlert("None found","No current medications entered for this patient.");
} else {
echo '<table id="currentmedslist" class="list2"><thead>
<tr>
<th>Update?</th>
<th>added <i>(days ago)</i></th>
<th>prescription <i>[provider]</i></th>
</tr></thead><tbody>';
$esaexistflag=FALSE;
$esaexistmsg="";
$esasubmitcolor="green";
while($row = $result->fetch_assoc())
	{
	$trclass="";
	$adddate=dmy($row["adddate"]);
	$updatecol='<form action="'.$pagevw.'" method="post"><input type="hidden" name="runtype" value="updatemed" /><input type="hidden" name="medsdata_id" value="'.$row["medsdata_id"].'" id="medsdata_id_'.$row["medsdata_id"].'" /><input type="text" name="newdose" size="10" value="'.$row["dose"].'" id="newdose_'.$row["medsdata_id"].'" /><input type="text" name="newfreq" size="20" value="'.$row["freq"].'" /><input type="submit" style="color: green;" value="Update dose/freq" /></form>';
	if ($row['esdflag']==1)
		{
		$trclass = 'esa'; //flag ESAs
		$updatecol='<i>Please delete ESA and then add below</i>';
		$esaexistflag=TRUE;
		}
		if ($row['immunosuppflag']==1)
			{
			$trclass = 'immunosupp'; //flag immunosupps
			}
		$showprovider = ($row["provider"]) ? "<i> [" . $row["provider"].']</i>' : "";
		$shownotes = ($row["drugnotes"]) ? "<br><i>" . $row["drugnotes"].'</i>' : "";
		echo '<tr class="' . $trclass . '"><td><button type="button" class="ui-state-default" onclick="$(\'#updrow_'.$row["medsdata_id"].'\').toggle()">Update/Delete</button></td>
		<td>' . $adddate . ' <i>('.$row["drugdays"].' d)</i></td>
		<td><b>' . $row['drugname'] . '</b> ' . $row['dose'] . ' ' . $row['route'] . ' ' . $row['freq'] . $showprovider.$shownotes . '
		<div id="updrow_'.$row["medsdata_id"].'" style="display: none;">'.$updatecol.'<form action="'.$pagevw.'" method="post" style="display: inline;"><input type="hidden" name="runtype" value="deletemed" /><input type="hidden" name="medsdata_id" value="'.$row["medsdata_id"].'" /><input type="hidden" name="zid" value="'.$zid.'" />Delete? <input type="checkbox" name="confirmdelete" value="Y" />Y&nbsp;<input type="submit" style="color: white; background: red; border: red;"  value="Delete" /></form></div></td></tr>';
		}
		echo '</tbody></table>';
	}
?>
<br><div id="medoptionsdiv" style="padding: 3px; border: thin solid purple;">
	<button class="ui-state-default" style="color: green;" onclick="flipImmunosupp();">Add Immunosuppressant</button>
	<?php if ($esaexistflag): ?>
		<?php
		spanAlert("ESA Unavailable!","You must discontinue the existing ESA drug before adding a new one!");
		?>
	<?php else: ?>
		<button class="ui-state-default" style="color: green;" onclick="flipESA();">Add ESA</button>
		<?php
		spanAlert("Important!","ESA agents only available with Add ESA option.");
		?>
	<?php endif ?>
</div>
<br>
<?php if (!$get_addtype): ?>
	<div id="standardmedsdiv">
		<form action="pat/patient.php" method="get" accept-charset="utf-8">
<fieldset>
	<legend>Add Standard (Non-ESA, Non-Immunosuppressant) Medication</legend>
	<input type="hidden" name="vw" value="editmeds" id="vw" />
		<input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
		<input type="hidden" name="mode" value="addmed" id="mode" />
	<?php if ($get_letter_id): ?>
		<input type="hidden" name="letter_id" value="<?php echo $get_letter_id ?>" id="letter_id" />
	<?php endif ?>
	<label for="medinits">Drug name/inits</label><input type="text" name="medinits" value="" id="medinits" size="12" />&nbsp;&nbsp; Optional--<i>(E.g. "<b>sodium</b>" to find all Sodium... drugs or "<b>m</b>" to find those starting with M.)</i><br>
		<input type="submit" style="color: green;" name="addtype" value="Add Med" />
</fieldset>
</form>
</div>
<?php endif ?>

<script charset="utf-8">
	function flipImmunosupp () {
		$('#standardmedsdiv').toggle();
		$('#immunosuppformdiv').toggle();
	}
	function flipESA () {
		$('#standardmedsdiv').toggle();
		$('#esaformdiv').toggle();
	}
	
</script>