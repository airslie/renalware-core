<?php
//----Tue 24 Jul 2012----run add data now incl in file
include "$rwarepath/data/currentclindata.php";
//-------SET FORM VARS--------
$thisvw="bpwtdata";
$addtype="bpwtdata";
//-------HANDLE FORMS--------
$pagevw="pat/patient.php?zid=$zid&amp;vw=$thisvw";
if ($get_run=='addbpwt') { 
    //----Tue 24 Jul 2012----
    $insertfields="bpwtzid, bpwtuid, bpwtstamp, bpwtmodal,bpwtdate,bpwttype";
    $insertvalues="$zid, $uid, NOW(), '$modalcode','$bpwtdate','$bpwttype'";
    if ($bpwtweight) {
    	$insertfields.=",weight";
    	$insertvalues.=",$bpwtweight";
    }
    if ($bpwtsyst && $bpwtdiast) {
    	$syst=(int)$bpwtsyst;
    	$diast=(int)$bpwtdiast;
    	$insertfields.=",bpsyst,bpdiast";
    	$insertvalues.=",$syst,$diast";
    }
    $newBMI=FALSE;
    if ($Height && $bpwtweight)
    	{
    	$newBMI=round($bpwtweight/$Height/$Height,1);
    	$insertfields.=",height,BMI";
    	$insertvalues.=",$Height,$newBMI";
    	}
    $table = "bpwtdata";
    //run INSERT
    $sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
    $result = $mysqli->query($sql);
    showAlert("Your data have been recorded!");
    //update currentclindata
    //sigh... fix if no wt
    //assume no wt
    $updatefields = "currentstamp=NOW(),currentadddate=NOW(), BPsyst=$syst, BPdiast=$diast, BPdate='$bpwtdate'";
    if ( $bpwtweight )
    	{
    	$updatefields .= ", Weight=$bpwtweight, Weightdate='$bpwtdate'";
    	}
    if ($newBMI) {
    	$updatefields .= ",BMI=$newBMI";
    }
    $tables = 'currentclindata';
    $where = "WHERE currentclinzid=$zid";
    $sql = "UPDATE $tables SET $updatefields $where";
    $result = $mysqli->query($sql);
    //log the event
    $eventtype="NEW BP/Wt DATA ADDED $syst/$diast $bpwtweight kg";
    $eventtext=$mysqli->real_escape_string($sql);
    include "$rwarepath/run/logevent.php";
    //end logging
    //incr
    incrStat('bpwts',$zid);
    //set pat modifstamp
    stampPat($zid);
    //refresh
    include "$rwarepath/data/currentclindata.php";
	}
//-------END HANDLE FORMS--------
	//for heights
	if ( $get_mode=='addht' )
		{
			//insert new data
			foreach ($_POST as $key => $value) {
					$escvalue=$mysqli->real_escape_string($value);
					${$key} = (substr($key,-4)=="date") ? fixDate($escvalue) : $escvalue ;
			}
			//try validation
			if ( $newheight>2 or !$newheight)
			{
				echo '<p class="alertsmall">Please check your HEIGHT data entry and try again.</p>';
			}
			else
			{
			//update currentclindata
			$updatefields = "currentstamp=NOW(), Height=$newheight, Heightdate='$newheightdate'";
			$eventtype="NEW Height DATA ADDED = $newheight meters";
			if ($Weight) {
				$BMI=round($Weight/$newheight/$newheight,1);
                $updatefields.=", BMI=$BMI";
				$eventtype="NEW Height DATA ADDED = $newheight meters; Weight $Weight BMI $BMI";
			}
			$tables = 'currentclindata';
			$where = "WHERE currentclinzid=$zid";
			$sql= "UPDATE $tables SET $updatefields $where";
			$result = $mysqli->query($sql);
			//log the event
			$eventtext=$mysqli->real_escape_string($sql);
			include "$rwarepath/run/logevent.php";
			//end logging
			//set pat modifstamp
			stampPat($zid);
            //refresh
            include "$rwarepath/data/currentclindata.php";
			}
		}
?>
<div id="uitabs">
	<ul>
		<li><a href="#infodiv">Latest BP/Weight/Height</a></li>
		<li><a href="#add_bpwtdataformdiv">Add BP/Weight</a></li>
		<li><a href="#updateheightformdiv">Add Height</a></li>
	</ul>
	<div id="infodiv">
		<?php
		makeAlert("Note","Add new Height data before Weight (to get BMI). Clinic BP/Wts should be entered in Clinic Letters.</li>")
		?>
		<ul class="portal" >
		<?php
		$basket=array(
			'Height' => 'Current Height',
			'Heightdate' => 'Height Date',
			'Weight' => 'Current Weight',
			'Weightdate' => 'Weight Date',
			'BMI' => 'Current BMI',
			);
		echo "<li>";
		foreach ($basket as $fld => $lbl) {
					echo '<b>'.$lbl.':</b> '.${$fld}.' &nbsp;&nbsp;';
			}
		echo "</li>";
		?>
		</ul>
	</div>
	<div id="add_bpwtdataformdiv">
		<form action="<?php echo $pagevw ?>&amp;run=addbpwt" method="post">
		<fieldset>
		<legend>Add new BP/Weight data for <?php echo $firstnames . ' ' . $lastname; ?></legend>
		<ul class="form">
		<li><label for="bpwtdate">Date</label><input type="text" name="bpwtdate" value="<?php echo date("d/m/Y") ?>"class="datepicker" size="12" /></li>
		<li><label for="bpwttype">Type/Situation</label>&nbsp;<input type="text" id="bpwttype" name="bpwttype" size="30" /></li>
		<li><label for="bpwtsyst">BP</label>&nbsp;<input type="text" id="bpwtsyst" name="bpwtsyst" size="3" />/<input type="text" id="bpwtdiast" name="bpwtdiast" size="3" /></li>
		<li><label for="bpwtweight">Weight</label>&nbsp;<input type="text" id="bpwtweight" name="bpwtweight" size="5" /> kg</li>
	    <li class="submit"><input type="submit" style="color: green;" value="submit!" /></li>
	    </ul>
	    </fieldset>
	    </form>
	</div>
	<div id="updateheightformdiv">
	<form action="pat/patient.php?vw=bpwtdata&amp;zid=<?php echo $zid; ?>&amp;mode=addht" method="post">
	<fieldset>
		<legend>Update Height data</legend>
		<ul class="form">
		<li><label for="newheight">Add/Update Height</label>&nbsp;<input type="text" size="4" name="newheight" value="<?php echo $Height; ?>"> <i>meters</i></li>
		<li><label for="newheightdate">new measurement date:</label> <input type="text" name="newheightdate" id="newheightdate" value="<?php echo date("d/m/Y") ?>"class="datepicker" size="12" /></li>
	    <li class="submit"><input type="submit" style="color: green;" value="Update height" /></li>
	    </ul>
	    </fieldset>
	    </form>
	</div>
</div>
<?php
	$displaytext = "BP/Weight entries for $firstnames $lastname"; //default
	$sql = "SELECT * FROM bpwtdata WHERE bpwtzid=$zid AND (bpsyst is not NULL OR weight is not NULL)  ORDER BY bpwtdate DESC";
	$result = $mysqli->query($sql);
	$numrows=$result->num_rows;
	if ($numrows=='0')
		{
		echo "<p class=\"headergray\">There are no $displaytext! $addmore</p>";
		}
	else
		{
		echo "<h2>BP/Weight/Urine History</h2>
		<p class=\"header\">$numrows $displaytext</p>";
	echo '<table class="list" style="width: 65%; float: left;">
		<tr>
			<th>date</th>
	<th>type/source</th>
            <th>modal</th>
			<th>BP</th>
			<th>Wt</th>
			<th>Ht</th>
			<th>BMI</th>
			<th>U Protein</th>
			<th>U Blood</th>
		</tr>';
		while($row = $result->fetch_assoc())
			{
            $bp = ($row["bpsyst"]) ? $row["bpsyst"] . '/' . $row["bpdiast"] : '&nbsp;' ;
            $wt = ($row["weight"]) ? $row["weight"] : '&nbsp;' ;
			echo "<tr bgcolor=\"$bg\">
				<td>" . dmyyyy($row["bpwtdate"]) . "</td>
			<td>" . $row["bpwttype"] . "</td>
			<td>" . $row["bpwtmodal"] . "</td>
				<td>$bp</td>
				<td>$wt</td>
				<td>" . $row["height"] . "</td>
				<td>" . $row["BMI"] . "</td>
				<td>" . $row["urine_prot"] . "</td>
				<td>" . $row["urine_blood"] . "</td>
			</tr>";
			}
		echo '</table>';
		}
	echo '<div style="float: right; width: 30% "><img src="images/bmi_chart.gif" width="416" height="320" alt="Bmi Chart" /></div>';
?>
