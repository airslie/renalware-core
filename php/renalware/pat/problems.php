<?php
if ($get_delete=="yes" && $post_confirmdelete=="Y")
	{
		foreach ($_POST as $key => $value) {
			if (substr($key,0,7)=="delete_")
				{
				$delete_id=explode("_",$key);
				$deleteprobtext=$value;
				$deleteprob_id=$delete_id[1];
				$sql = "DELETE FROM problemdata WHERE problem_id=$deleteprob_id LIMIT 1";
				$result = $mysqli->query($sql);
				//log the event
				$eventtype="Problem ID $deleteprob_id ($deleteprobtext) deleted";
				$eventtext=$mysqli->real_escape_string($sql);
				include "$rwarepath/run/logevent.php";
				//incr/decr
				decrStat('problems',$zid);
				//set pat modifstamp
				stampPat($zid);
				showAlert("Problem ID: ' . $deleteprob_id . ' (<b>'. $deleteprobtext . '</b>) has been deleted!");
				}
		}
	}
//-------SET FORM VARS--------
$thisvw="problems";
$addtype="problem";
//-------HANDLE FORMS--------
$pagevw="pat/patient.php?zid=$zid&amp;vw=$thisvw";
if ($get_letter_id) {
	$pagevw.="&amp;letter_id=$get_letter_id&amp;menu=hide";
}
$returntoletter="";
if ($get_letter_id) {
	echo "&nbsp;&nbsp;<a class=\"ui-state-default\" style=\"color: green;\" href=\"letters/editletter.php?zid=$zid&amp;letter_id=$get_letter_id\">Return to Letter #$get_letter_id</a>";
}
//handle adds
if (isset($get_run)) {
	include 'run/'.$get_run.'.php';
	}
//-------END HANDLE FORMS--------
echo '<form action="'.$pagevw.'&amp;delete=yes" method="post">';
$sql = "SELECT probdate, problem_id, probuser, problem, probnotes FROM problemdata WHERE probzid=$zid ORDER BY problem_id";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo '<p class="header">'.$numrows.' problems recorded. <button type="button" class="ui-state-default" onclick="$(\'#adddataform\').toggle(\'slow\')">Add problem(s)</button></p>';
echo '<table class="tablesorter">
<thead><tr>
<th>problem</th>
<th>added</th>
<th>recorded by</th>
<th>delete?*</th>
</tr></thead><tbody>';
while($row = $result->fetch_assoc())
	{
	echo '<tr>
	<td>' . $row["problem"] . '</td>
	<td>' . dmyyyy($row['probdate']) . '</td>
	<td>' . $row['probuser'] . '</td>
	<td><input type="checkbox" name="delete_'.$row['problem_id'].'" value="'.$row["problem"].'" onclick="$(\'#deldiv\').show()" /></td></tr>';
	}
echo '</tbody></table>
<div id="deldiv" style="display: none;">
<p class="alert">*CAUTION: Deleted problems cannot be retrieved. You must click the "Confirm delete(s)" box to proceed.</p>
<fieldset>
<input type="checkbox" name="confirmdelete" value="Y" id="confirmdelete" />Confirm delete(s)&nbsp;<input type="submit" style="color: white; background: red; border: red;" value="delete problem(s)" /></fieldset>
</form>
</div>
';
?>
<div id="adddataform" style="display: none;">
	<form action="<?php echo $pagevw ?>&amp;run=addproblems" method="post">
	<fieldset>
	<legend>Add new Problem(s) for <?php echo $firstnames . ' ' . $lastname; ?></legend>
	<button type="button" class="ui-state-default" style="color: white; background: red; border: red;" onclick="$('#adddataform').hide('slow')">Cancel</button>
<ul class="form"><li>Extremely important: <b>Use only one line per problem. Please be concise</b>.</i></li>
<li><textarea id="problemblock" name="problemblock" rows="10" cols="100"></textarea></li>
<li class="submit"><input type="submit" style="color: green;" value="add new problem(s)" /></li>
</ul></fieldset>
	</form>
	<form action="<?php echo $pagevw ?>&amp;run=addrenaldx" method="post">
	<fieldset>
	<legend>Add ICD-10 Renal Diagnosis</legend>
<ul class="form">
	<li><label for="icd10renal">ICD 10 (renal)</label>&nbsp;<select name="icd10renal"><option value="">Select ICD10 renal diagnosis</option>
<?php include('../optionlists/icd10renaldxs.html'); ?>
</select></li>
<li><label for="icd10freetext">Append free text</label>&nbsp;<input type="text" id="icd10freetext" name="icd10freetext" size="60" />
</li><li class="submit"><input type="submit" style="color: green;" value="add new renal diagnosis" /></li></ul>
</fieldset>
</form>
</div>