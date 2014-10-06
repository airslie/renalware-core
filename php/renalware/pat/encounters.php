<?php
//-------SET FORM VARS--------
$thisvw="encounters";
$addtype="encounter";
//-------HANDLE FORMS--------
$pagevw="pat/patient.php?zid=$zid&amp;vw=$thisvw";
if ($get_run=='add') {
	include 'run/'.$addtype.'_add.php';
}
//-------END HANDLE FORMS--------
	//display results if !mode=add
	//get distinct encounterlist for popup
	$enctypelist="<option value=\"\">Select from $title $lastname&rsquo;s encounters</option>\n";
	$sql="SELECT enctype, count(encounter_id) as enccount FROM encounterdata WHERE enczid=$zid GROUP BY enctype";
	$result = $mysqli->query($sql);
	while($row = $result->fetch_assoc()) {
	$enctypelist.= '<option value="'.$row["enctype"].'">'. $row["enctype"]. ' ['.$row["enccount"]."]</option>\n";
	}
	$displaytext = "encounters for $firstnames $lastname"; //default
	$where = "WHERE enczid=$zid";
	$showall='<a class="ui-state-default" style="color: green;" href="pat/patient.php?vw=encounters&amp;zid='.$zid.'">Show all</a>';
	$searchedflag=FALSE;
	if ($get_enctype) {
		$searchedflag=TRUE;
		$where .= " AND enctype='$get_enctype'";
		$displaytext = "$get_enctype encounters for $title $lastname"; //default
		}
	if ($get_show=="mdms") {
		$searchedflag=TRUE;
		$where .= " AND enctype LIKE 'MDM%'";
		$displaytext = "MDM encounters for $title $lastname"; //default
		}
	if ($get_uidflag=='yes') {
		$searchedflag=TRUE;
			$where .= " AND encuser='$user'";
			$displaytext .= " entered by $user";
	}
	$tables = "encounterdata";
	$orderby = "ORDER BY encaddstamp DESC";
	$sql = "SELECT * FROM $tables $where $orderby";
	$result = $mysqli->query($sql);
	$numrows=$result->num_rows;
	$addmore= '<button type="button" class="ui-state-default" style="color: green" onclick="$(\'#adddataform\').toggle()">add new '.$addtype.'</button>';
	?>
	<?php if (!$numrows): ?>
		<p class="header"><?php echo "There are no $displaytext. &nbsp; $addmore" ?></p>
		<?php
		include 'forms/add_'.$addtype.'form.html';
		?>
		<?php else: ?>
	<?php
		$showsearch= '<button type="button" class="ui-state-default" style="color: purple" onclick="$(\'#searchform\').toggle()">toggle search</button>';
		echo "<p class=\"header\">$numrows $displaytext. &nbsp; $addmore &nbsp;&nbsp; $showsearch";
		if ($searchedflag) {
			echo '&nbsp;&nbsp;<a class="ui-state-default" style="color: green;" href="pat/patient.php?vw=encounters&amp;zid='.$zid.'">Show All</a>';
		}
		echo "</p>";
		?>
		<div id="searchform" style="display: none;">
			<form action="pat/patient.php" method="get">
			<input type="hidden" name="vw" value="encounters" id="vw" />
			<input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
			<fieldset>
			<select name="enctype"><?php echo $enctypelist; ?></select>&nbsp;&nbsp;<br>
			Show <b><?php echo $user ?></b>&rsquo;s encounters only? <input type="radio" name="uidflag" value="no" checked="checked" />no &nbsp; &nbsp; <input type="radio" name="uidflag" value="yes" />yes <br>
			<input type="submit" style="color: green;" value="Display selected encounters" /> &nbsp;&nbsp; <a class="ui-state-default" style="color: purple;" href="pat/patient.php?vw=encounters&amp;zid=<?php echo $zid ?>&amp;show=mdms">Show MDMs</a>
			</fieldset>
			</form>
		</div>
		<?php
		include 'forms/add_'.$addtype.'form.html';
		if ($numrows) {
		echo "<table class=\"tablesorter\" style=\"width: 900px;\"><thead>
		<tr>
		<th>added</th>
		<th>enc date</th>
		<th>user</th>
		<th>modal</th>
		<th>type--description (toggles text)</th>
		<th>time</th>
		<th>staffname</th>
		</tr></thead><tbody>";
		while($row = $result->fetch_assoc())
			{
			echo '<tr>
			<td>' . $row["encaddstamp"] . '</td>
			<td>' . dmy($row["encdate"]) . '</td>
			<td>' . $row["encuser"] . '</td>
			<td>' . $row["encmodal"] . '</td>
			<td style="width: 400px;"><a onclick="$(\'#enc_'.$row["encounter_id"].'\').toggle()">'.$row["enctype"].'--' . $row["encdescr"] . '</a><div id="enc_'.$row["encounter_id"].'" style="display: none; padding: 2px; background: yellow;"><br><i>'.$row["enctext"].'</div></td>
		<td>' . $row["enctime"] . '</td>
			<td>' . $row["staffname"] . '</td>
			</tr>';
			}
		echo '</tbody></table>';
		}
	?>
	<?php endif ?>