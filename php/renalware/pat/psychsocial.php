<?php
//get data
//handle ADD
if ($get_add=="encounter") {
	$insertfields="encuser, enczid, encmodal";
	$insertvalues="'$user',$get_zid, '$modalcode'";
	foreach ($_POST as $key => $value) {
			$escvalue=$mysqli->real_escape_string($value);
			$valuefix = (substr($key,-4)=="date") ? fixDate($escvalue) : $escvalue ;
			if ($value) //omit nulls
			{
				$insertfields.=",$key";
				$insertvalues.=",'$valuefix'";
			}
	}
	$table = "psychsoc_encounterdata";
	//run INSERT
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	$eventtype="NEW PSYCH/SOCIAL ENCOUNTER: $encdate $enctime -- $enctype; $encdescr by $staffname";
	$eventtext=$enctext;
	include "$rwarepath/run/logevent.php";
	if ($publishflag=="1") {
		//add to gen'l encounters
		$insertfields="encaddstamp, encuser, enczid, encmodal,encdate,enctime,enctype,encdescr,enctext,staffname";
		$insertvalues="NOW(),'$user',$get_zid, '$modalcode','$encdate','$enctime','$enctype','$encdescr','$enctext','$staffname'";
		$sql = "INSERT INTO encounterdata ($insertfields) VALUES ($insertvalues)";
		$result = $mysqli->query($sql);
	}
}
$thisvw="psychsocial";
$addtype="encounter";
$pagevw="pat/patient.php?zid=$zid&amp;vw=$thisvw";
$fields="psychsoc_housing, psychsoc_socialnetwork, psychsoc_carepackage, psychsoc_other, psychsoc_stamp";
$sql = "SELECT $fields FROM renaldata WHERE renalzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>
<p class="header">Psych/Social Data (last updated: <?php echo $psychsoc_stamp ?>) <a href="pat/forms/psychsocialform.php?zid=<?php echo $zid ?>">Add/Update</a></p>
<table>
	<tr><th width="300">Housing</th><th width="300">Social Network</th><th width="300">Care Package</th><th width="300">Other</th></tr>
	<tr><td class="psychsoc"><?php echo nl2br($psychsoc_housing) ?></td><td class="psychsoc"><?php echo nl2br($psychsoc_socialnetwork) ?></td><td class="psychsoc"><?php echo nl2br($psychsoc_carepackage) ?></td><td class="psychsoc"><?php echo nl2br($psychsoc_other) ?></td></tr>
</table>
<hr />
<h3>Psych/Social Encounters</h3>
<a class="ui-state-default" style="color: green;" onclick='$("#adddataform").toggle();'>Add encounter</a><br>
<div id="adddataform" style="display:none">
	<form action="<?php echo $pagevw ?>&amp;add=encounter" method="post">
	<fieldset>
	<legend>Add new Psych/Social Encounter for <?php echo $firstnames . ' ' . $lastname; ?></legend>
	<a class="ui-state-default" style="color: white; background: red; border: red;" onclick='$("#adddataform").toggle();'>Cancel</a><br>
	<ul class="form">
	<li><label for="encdate">Encounter Date</label>&nbsp;<input type="text" name="encdate" id="encdate" value="<?php echo date("d/m/Y") ?>"class="datepicker" size="12" /></li>
	<li><label for="staffname">Entered by</label>&nbsp;<input type="text" id="staffname" name="staffname" size="30" /></li>
	<li><label for="enctype">Encounter type</label>&nbsp;<select id="enctype" name="enctype">
        <option>Counsellor Meeting</option>
        <option>Social Worker</option>
    </select></li>
	<li><label for="publishflag">Publish in Encounters?</label>&nbsp;<input type="radio" name="publishflag" value="1" checked="checked" />Yes (default) &nbsp; &nbsp; <input type="radio" name="publishflag" value="0" />No</li>
	<li><label for="encdescr">Description</label>&nbsp;<input type="" id="encdescr" name="encdescr" size="70" /></li>
	<li><label for="enctext">Notes</label><br>
	    <textarea id="enctext" name="enctext" rows="4" cols="100"></textarea></li>
    <li class="submit"><input type="submit" style="color: green;" value="add encounter" /></li>
    </ul>
    </fieldset>
	</form>
</div>
<div class="clear">
	<div class="wrap50pct">
		<?php
		include( 'portals/counsellorencs_portal.php' );
		?>
	</div>	
	<div class="wrap50pct">
		<?php
		include( 'portals/socialworkerencs_portal.php' );
		?>
	</div>
</div>