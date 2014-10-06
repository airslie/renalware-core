<?php
//----Mon 23 Sep 2013----HGB fix
//----Sun 10 Mar 2013----adduser not prescriber
//----Mon 25 Feb 2013----ESA prescriber added
//Thu May 14 23:29:03 BST 2009 esddata
//if updated -- ONLY FE and COMMENTS
if ($_GET['mode']=="updateinfo")
	{
		$updatefields="esdmodifdt=NOW(),esdmodifdate=CURDATE()";
	foreach ($_POST as $field => $value) {
		$fieldvalue=$mysqli->real_escape_string($value);
		${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
		$updatefields .= ", $field='${$field}'";
	}	
	//update the table
	$sql= "UPDATE esddata SET $updatefields WHERE esdzid=$zid";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="ESA Prescriber/Administrator/Comments updated";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
} // end update IF
if ($_GET['mode']=="addirondose")
	{
	foreach ($_POST as $field => $value) {
		$fieldvalue=$mysqli->real_escape_string($value);
		${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
	}
	//update the esa table
	$sql= "UPDATE esddata SET esdmodifdt=NOW(),lastirondose='$irondose',lastirondosetype='$irondosetype',lastirondosedate='$irondosedate', lastirondosebatch='$irondosebatch' WHERE esdzid=$zid";
	$result = $mysqli->query($sql);
	//insert into data
	$table="irondosedata";
	$insertfields="irondosezid, irondoseuid, irondoseuser, irondosedate, irondosetype, irondose, irondosebatch, irondosecomments";
	$insertvalues="$zid, $uid, '$user', '$irondosedate', '$irondosetype', '$irondose', '$irondosebatch', '$irondosecomments'";
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Patient Fe Dose ($irondosetype $irondose)";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
} // end update IF

//refresh data
include "$rwarepath/data/esddata.php";
?>
<div id="uitabs">
	<ul>
		<li><a href="#esainfodiv">Anaemia/ESA info</a></li>
		<li><a href="#updateesaformdiv">Update Info</a></li>
		<li><a href="#irondoselogsdiv">Iron Dose Logs</a></li>
		<li><a href="#irondoseformdiv">Add Iron Dose</a></li>
	</ul>
	<div id="esainfodiv">
		<ul class="portal">
			<li><b>Status:</b>&nbsp;&nbsp;<?php echo $esdstatus; ?> 
				<b>Date Started:</b> <?php echo $esdstartdate; ?> 
				<b>Date Modif</b>:<?php echo $esdmodifdate; ?></li>
			<li><b>Curr Regime:</b> <?php echo $esdregime; ?> <b>Prescriber:</b> <?php echo $prescriber; ?> <b>Administrator:</b> <?php echo $administrator; ?></li>
			<li><b>Units/Week:</b> <?php echo $unitsperweek; ?> <b>Weight:</b> <?php echo $Weight; ?> <b>Units/Wk/Kg:</b> <?php echo $unitsperwkperkg; ?></li>
			<li><b>Last Fe Dose:</b> <?php echo $lastirondose; ?> <b>Last Fe Type:</b> <?php echo $lastirondosetype; ?> <b>Fe Dose Date:</b> <?php echo $lastirondosedate; ?> <b>Last Batch No:</b> <?php echo $lastirondosebatch; ?></li>
			<li><b>Comments:</b><br> <?php echo nl2br($esdcomments); ?></li>
		</ul>
		<div style="width: 30%; float: left; clear: none;">
		    <h3>Recent Haematology</h3>
		    <?php
		    $fields = "resultsdate, HB,
		    MCV,
		    MCH,
		    RETA,
		    HYPO,
		    FER";
		    $sql = "SELECT $fields FROM hl7data.pathol_results WHERE resultspid='$hospno1' AND (HB is not NULL OR FER is not NULL) ORDER BY resultsdate DESC LIMIT 12";
		    $result = $mysqli->query($sql);
		    $numrows=$result->num_rows;
		    if (!$numrows)
		    	{
		    	echo "<p class=\"headergray\">No Haematology results found!</p>";
		    	}
		    else
		    	{
		    	echo "<p class=\"header\">$numrows results displayed (Max 12)</p>";
		    	echo '<table class="list">
		    	<tr><th>date</th>
		    	<th><b>HGB</b></th>
		    	<th>MCV</th>
		    	<th>MCH</th>
		    	<th>RETA</th>
		    	<th>%HYPO</th>
		    	<th>FER</th>
		    	</tr>';
		    	while($row = $result->fetch_assoc()) {
		    		echo "<tr>
		    		<td><b>" . dmy($row["resultsdate"]) . "</b></td>
		    		<td>" . 10*$row["HB"] . "</td>
		    		<td>" . $row["MCV"] . "</td>
		    		<td>" . $row["MCH"] . "</td>
		    		<td>" . $row["RETA"] . "</td>
		    		<td>" . $row["HYPO"] . "</td>
		    		<td>" . $row["FER"] . "</td>
		    		</tr>";
		    		}
		    		echo "</table>";
		    	}
		    ?>
		</div>
		<div style="width: 70%; float: left;">
		<h3>ESA History</h3>
		<?php 
		$sql = "SELECT * FROM medsdata WHERE medzid=$zid AND esdflag=1 ORDER BY medsdata_id DESC";
		$result = $mysqli->query($sql);
		$numrows=$result->num_rows;
		if ($numrows) {
			echo "<p class=\"header\">Recorded ESA History ($numrows prescriptions) </p>
				<table class=\"list\">
				<tr>
				<th>ESA/dose route freq</th>
				<th>units/week</th>
				<th>prescriber</th>
				<th>started</th>
				<th>term date</th>
				<th>modality</th>
				</tr>";
			while($row = $result->fetch_assoc())
				{
				$trclass = ($row["termdate"]) ? "" : "hilite" ;
				$drugnotes = ($row["drugnotes"]) ? "<br /><i>".$row["drugnotes"]."</i>" : "" ;
				echo '<tr class="' . $trclass . '">
				<td>' . str_replace(" (Epoetin Alfa)","",$row['drugname']) . '<br />' . $row['dose'] . ' ' . $row['route'] . ' ' . $row['freq'] . $drugnotes. '</td>
				<td>' . $row['esdunitsperweek'] . '</td>
				<td>' . $row['adduser'] . '</td>
				<td class="start">' . dmy($row['adddate']) . '</td>
				<td class="term">' . dmy($row['termdate']) . '</td>
				<td>' . $row['medmodal'] . '</td>
				</tr>';
				}
			echo '</table>';
		} else {
			echo "<p class=\"headergray\">No ESA prescriptions located.</p>";
		}
		?>
		</div>
	</div>
	<div id="updateesaformdiv">
		<?php
		makeAlert("IMPORTANT","New ESA prescriptions can only be made in the Edit Meds screen. Info below for display only.");
		?>
		<ul class="portal">
			<li><b>Status:</b>&nbsp;&nbsp;<?php echo $esdstatus; ?> 
				<b>Date Started:</b> <?php echo $esdstartdate; ?> 
				<b>Date Modif</b>:<?php echo $esdmodifdate; ?></li>
			<li><b>Curr Regime:</b> <?php echo $esdregime; ?> <b>Prescriber:</b> <?php echo $prescriber; ?> <b>Administrator:</b> <?php echo $administrator; ?></li>
			<li><b>Units/Week:</b> <?php echo $unitsperweek; ?> <b>Weight:</b> <?php echo $Weight; ?> <b>Units/Wk/Kg:</b> <?php echo $unitsperwkperkg; ?></li>
		</ul>
		<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=esa&amp;mode=updateinfo" method="post">
		<fieldset>
		<ul>
		<li><label>Prescriber</label>&nbsp;&nbsp;
				<?php
				$prescribers = array('Hosp','GP','Home Delivery');		
				makeRadioItems('prescriber', $prescriber,$prescribers );
				?></li>
		<li><label>Administrator</label>&nbsp;&nbsp;
				<?php
				$administrators = array('HCP','Patient','Family');		
				makeRadioItems('administrator', $administrator,$administrators);
				?></li>
		<li><label>Comments</label>&nbsp;&nbsp;<br><textarea name="esdcomments" rows="8" cols="120"><?php echo $esdcomments; ?></textarea></li>
		</ul>
		<input type="submit" style="color: green;" value="Update ESA Details" />
		</fieldset>
		</form>
	</div>
	<div id="irondoselogsdiv">
        <h3>Iron Dose History</h3>
		<?php 
		$sql = "SELECT * FROM irondosedata WHERE irondosezid=$zid";
		$result = $mysqli->query($sql);
		$numrows=$result->num_rows;
		if ($numrows) {
			echo "<p class=\"header\">Recorded Fe Doses ($numrows prescriptions) </p>
			<table class=\"list\">
					<thead><tr>
					<th>Date Given</th>
					<th>Entered by</th>
					<th>Type</th>
					<th>Dose</th>
					<th>Batch No</th>
					<th>Comments</th>
					</tr></thead>";
			while($row = $result->fetch_assoc())
				{
				echo '<tr>
				<td>' . dmy($row['irondosedate']) . '</td>
				<td>' . $row['irondoseuser'] . '</td>
				<td>' . $row['irondosetype'] . '</td>
				<td>' . $row['irondose'] . '</td>
				<td>' . $row['irondosebatch'] . '</td>
				<td>' . $row['irondosecomments'] . '</td>
				</tr>';
				}
			echo '</table>';
		} else {
	    	echo "<p class=\"headergray\">No iron dose data found!</p>";
		}
		?>
	</div>
	<div id="irondoseformdiv">
		<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=esa&amp;mode=addirondose" method="post">
		<fieldset>
		<ul>
		<li><label>Date Given</label>: <input type="text" name="irondosedate" class="datepicker" value="<?php echo Date("d/m/Y") ?>" size="12" /></li>
		<li><label>Iron Type</label>&nbsp;&nbsp;<select name="irondosetype"><option value="">Select...</option>
		<?php
		$optionlistname='irondosetype';
		include '../optionlists/getoptionlist_incl.php';
		?>
		</select></li>
		<li><label>Iron Dose</label>&nbsp;&nbsp;<input type="text" name="irondose" size="10" /></li>
		<li><label>Batch No</label>&nbsp;&nbsp;<input type="text" name="irondosebatch" size="20" /></li>
		<li><label>Comments</label>&nbsp;&nbsp;<input type="text" name="irondosecomments" size="120" /></li>
		</ul>
		<input type="submit" style="color: green;" value="Submit Iron Dose Info" />
		</fieldset>
		</form>
	</div>
</div>