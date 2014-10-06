<?php
//Sat Dec  8 11:01:36 CET 2007 Mon May 11 15:38:39 CEST 2009
if ($_GET['mode']=="updateinactive")
	{
	$inactiveassessor = $mysqli->real_escape_string($_POST["inactiveassessor"]);
	$inactivereason1 = $_POST["inactivereason1"];
	$inactivereason2 = $_POST["inactivereason2"];
	//update the table
	//insert new txwaitlistdata
	$sql= "INSERT INTO txinactivepatdata (assessstamp,assessdate,assessor,reason1,reason2,txinactivepatzid,assessuid) VALUES (NOW(), NOW(),'$inactiveassessor', '$inactivereason1','$inactivereason2',$zid,$uid)";
	$result = $mysqli->query($sql);
	} // end update IF

if ($_GET['mode']=="updatetxstatus")
	{
	foreach ($_POST as $k => $v) {
		$vfix = $mysqli->real_escape_string($v);
		$$k = (substr(strtolower($k),-4)=="date") ? fixDate($vfix) : $vfix ;
	}
	//update the table
	$updatefields = "TxNHBconsent='$TxNHBconsent',TxNHBconsentstaff='$TxNHBconsentstaff',TxNHBconsentdate='$TxNHBconsentdate',txWaitListEntryDate='$txWaitListEntryDate', txWaitListNotes='$txWaitListNotes', txWaitListStatus='$txWaitListStatus', txAbsHighest='$txAbsHighest', txAbsHighestDate='$txAbsHighestDate', txAbsLatest='$txAbsLatest', txAbsLatestDate='$txAbsLatestDate', txBloodGroup='$txBloodGroup', txHLAType='$txHLAType', txHLATypeDate='$txHLATypeDate', txNoGrafts='$txNoGrafts', txSensStatus='$txSensStatus', txTransplType='$txTransplType', txWaitListContact='$txWaitListContact',txRejectionRisk='$txRejectionRisk'";
	$sql= "UPDATE renalware.renaldata SET $updatefields, txWaitListModifDate=NOW(),renalmodifstamp=NOW() WHERE renalzid=$zid";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Patient Transplant Wait List Data updated (Status=$txWaitListStatus)";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
	//insert new txwaitlistdata
	$sql= "INSERT INTO txwaitlistdata (eventstamp, type, eventtext, txwaitzid) VALUES (NOW(), '$eventtype', '$eventtext',$zid)";
	$result = $mysqli->query($sql);
	
	} // end update IF
//refresh data
$fields = "
txWaitListEntryDate, 
txWaitListModifDate, 
txWaitListNotes,
txWaitListStatus,
txAbsHighest,
txAbsHighestDate, 
txAbsLatest,
txAbsLatestDate, 
txBloodGroup,
txHLAType,
txHLATypeDate, 
txNoGrafts,
txSensStatus,
txTransplType,
txRejectionRisk,
txWaitListContact,
TxNHBconsent,
TxNHBconsentdate,
TxNHBconsentstaff
";
$sql= "SELECT $fields FROM renaldata WHERE renalzid=$zid";
include "$rwarepath/incl/runparsesinglerow.php";
//get optionlist
$sql = "SELECT listhtml FROM optionlists WHERE listname='tx_inactivestatus' LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$tx_inactivestatus_options= $row["listhtml"];
?>
<table>
    <tr>
    <td valign="top">
		<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=txstatus&amp;mode=updateinactive" method="post">
		<fieldset>
		<legend>Update Inactive Status reasons</legend>
		<ul>
			<li><label>Assessor</label> <input type="text" name="inactiveassessor" value="" size="12" /> <label>Reason 1:</label> <select name="inactivereason1">
            <?php
            echo '<option value="">Select reason 1...</option>';
            if ($BMI>24) {
                echo "<option>Overweight BMI: $BMI</option>";
            }
            echo $tx_inactivestatus_options;
            ?>
        </select>&nbsp;&nbsp;<b>Reason 2:</b> <select name="inactivereason2">
           <?php
           echo '<option value="">Select reason 2...</option>';
           if ($BMI>24) {
               echo "<option>Overweight BMI: $BMI</option>";
           }
           echo $tx_inactivestatus_options;
           ?>
		    </select></li>
		</ul>
		<input type="submit" style="color: green;" value="Update Reasons for Inactive status" />
		</fieldset>
		</form>

<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=txstatus&amp;mode=updatetxstatus" method="post">
<fieldset>
<legend>Transplant Data</legend>
<ul>
	<li><label>WaitListEntryDate</label> <input type="text" name="txWaitListEntryDate" value="<?php echo $txWaitListEntryDate; ?>" size="12" />&nbsp;&nbsp;<label>WaitListStatus:</label> <select name="txWaitListStatus">
    <?php
    if (!$txWaitListStatus)
    	{
    	echo '<option value="">Select status...</option>';
    	}
    else
    	{
    	echo '<option value="' . $txWaitListStatus. '">' . $txWaitListStatus. '</option>';
    	}
	//----Sun 31 Jul 2011----
	$optionlistname='waitliststatus';
	include '../optionlists/getoptionlist_incl.php';
	?>
    </select></li>
	<li><label>cRF (ex-Ab)</label> Highest <input type="text" name="txAbsHighest" value="<?php echo $txAbsHighest; ?>" size="12" />&nbsp; &nbsp;
		 Highest Date: <input type="text" name="txAbsHighestDate" value="<?php echo $txAbsHighestDate; ?>" size="12" class="datepicker"/> &nbsp; &nbsp;
		 Latest <input type="text" name="txAbsLatest" value="<?php echo $txAbsLatest; ?>" size="12" />&nbsp; &nbsp;
		 Latest Date: <input type="text" name="txAbsLatestDate" value="<?php echo $txAbsLatestDate; ?>" size="12" class="datepicker" /></li>
	<li><label>BloodGroup</label> <input type="text" name="txBloodGroup" value="<?php echo $txBloodGroup; ?>" size="5" /></li>
	<li><label>HLA Type</label> <textarea name="txHLAType" rows="2" cols="100"><?php echo $txHLAType; ?></textarea></li>
    <li><label>HLA Type Date:</label><input type="text" name="txHLATypeDate" value="<?php echo $txHLATypeDate; ?>" size="12" class="datepicker" /></li>
	<li><label>No Prev Grafts</label> <input type="text" name="txNoGrafts" value="<?php echo $txNoGrafts; ?>" size="4" /></li>
	<li><label>Sens Status</label> <input type="text" name="txSensStatus" value="<?php echo $txSensStatus; ?>" size="12" /></li>
	<li><label>Tx Type</label> 
	<select name="txTransplType">
    <?php
    if (!$txTransplType)
    	{
    	echo '<option value="">Select planned transplant type...</option>';
    	}
    else
    	{
    	echo '<option value="' . $txTransplType. '">' . $txTransplType. '</option>';
    	}
    include '../optionlists/txtypes.html';
    ?>
    </select></li>
	<li><label>Rejection Risk</label> 
	<select name="txRejectionRisk">
    <?php
    if (!$txRejectionRisk)
    	{
    	echo '<option value="">Select risk level...</option>';
    	}
    else
    	{
    	echo "<option>$txRejectionRisk</option>";
    	}
    ?>
<option>Low</option>
<option>Standard</option>
<option>High</option>
<option>Individualised</option>
    </select></li>
	<li><label>NHB Consent</label> <select name="TxNHBconsent"><?php
		echo '<option value="' . $TxNHBconsent. '">' . $TxNHBconsent. '</option>';
	?>
	<option>Yes</option>
	<option>No</option>
	</select>&nbsp;&nbsp;<label>Date Consent Asked:</label> <input type="text" name="TxNHBconsentdate" value="<?php echo $TxNHBconsentdate; ?>" size="12" class="datepicker" />&nbsp;&nbsp;
	<label>Consent by:</label> <input type="text" name="TxNHBconsentstaff" value="<?php echo $TxNHBconsentstaff; ?>" size="12" /></li>
	<li><label>Wait List Contact</label> <textarea name="txWaitListContact" rows="2" cols="100"><?php echo $txWaitListContact; ?></textarea></li>
	<li><label>Wait List Notes</label> <textarea name="txWaitListNotes" rows="2" cols="100"><?php echo $txWaitListNotes; ?></textarea></li>
	<li><label>Last Updated</label> <?php echo $txWaitListModifDate; ?></li>
</ul>
<input type="submit" style="color: green;" value="Update Transplant Wait List Details" />
</fieldset>
</form>
</td>
<td valign="top">
    <p class="header">Inactive Status History</p>
    <table class="list">
    <tr>
    	<th>date</th>
    	<th>Assessor</th>
    	<th>Reason(s)</th>
    </tr>
    <?php
    $sql= "SELECT assessdate,assessor,reason1,reason2 FROM txinactivepatdata WHERE txinactivepatzid=$zid ORDER BY assessdate DESC LIMIT 8";
   $result = $mysqli->query($sql);
    while ($row = $result->fetch_assoc()) {
	$reasons=$row["reason1"];
	if ($row["reason2"]) {
		$reasons.="<br>".$row["reason2"];
	}
    		echo "<tr>
    			<td>" . dmyyyy($row["assessdate"]) . "</td>
    			<td>" . $row["assessor"] . "</td>
    			<td>$reasons</td>
    		</tr>";
    		}
    ?>
    </table>
</td>
</tr>
</table>
<hr />
<?php
include( 'portals/txopsportal.php' );
?>
<p class="header">Transplant Wait List History</p>
<?php
$fields = "DATE(eventstamp) AS eventdate, type, eventtext";
$tables = "txwaitlistdata";
$sql= "SELECT $fields FROM $tables WHERE txwaitzid=$zid";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
	echo '<table class="list"><tr>
	<th>date</th>
	<th>event (hover to view data)</th>
	</tr>';
	while ($row = $result->fetch_assoc()) {
		$descr = '<acronym title="' . $row["eventtext"] . '">' . $row["type"] . '</a>';
		echo "<tr>
		<td>" . $row["eventdate"] . "</td>
		<td>$descr</li>";
	}
	echo '</table>';
?>