<?php
//----Mon 13 Jan 2014----poporderby fix
$pzid=(int)$_GET['zid'];
$zid=(int)$_GET['zid'];
if ( $_GET["reqdate"] )
{
$reqdate = $_GET["reqdate"];
}
//mode=cancel, schedule, archive etc?
//disable for now; cancel->cancelproced
//$mode=$_GET['mode'];
//get opdata
//try sending to VIEW if ARCH Mon Dec 17 17:42:36 CET 2007 OVERRULED now archived can be updated
if (!$bedmgrflag)
	{
	header ("Location: index.php?vw=proced&scr=view&zid=$zid&pid=$pid");
	}
$legend="Update procedure for $patientref";
$showpriority=strtoupper($priority);
echo "<div class=\"$priority\">$proced -- Priority $showpriority (Status: $status)</div>";
?>
<table border="0" cellspacing="5" cellpadding="5">
<tr><td valign="top">
<form action="run/runupdate.php" method="post">
	<fieldset>
		<legend><?php echo $legend ?></legend>
<input type="hidden" name="pid" value="<?php echo $pid; ?>" id="pid" />
<input type="hidden" name="pzid" value="<?php echo $pzid; ?>" id="pzid" />
<table>
<tr><td class="fldview">Listed Date</td><td class="data"><?php echo $listeddate; ?> <b>Days on List:</b> <?php echo $daysonlist; ?> <i>days</i></td></tr>
<tr><td class="fldview">Consultant</td><td class="data">
<select name="consultant">
<option><?php echo $consultant; ?></option>
<?php
$popcode="userlast";
$popname="CONCAT (userlast,', ',userfirst)";
$popwhere="consultantflag=1";
$poporderby="ORDER BY userlast, userfirst";
$poptable="renalware.userdata";
include('incl/limitedoptions.php');
?>
</select>
</td></tr>
<tr><td class="fldview">Surgeon</td><td class="data">
<select name="surg_id">
<?php
if ($surg_id)
	{
	echo "<option value=\"$surg_id\">$surgeon</option>";
	}
	else
	{
	echo "<option value=\"\">Select...</option>";
	}
$popcode="surg_id";
$popname="CONCAT(surglast, ', ', surgfirst) as surgeon";
$poptable="surgeons";
$where="";
$orderby="ORDER BY surglast, surgfirst";
include('incl/showoptions.php');
?>
</select>
</td></tr>
<tr><td class="fldview">Priority</td><td class="data">
<input type="radio" name="priority" value="Routine" <?php if($priority=='Routine') {echo 'checked="checked"';} ?> />Routine--6 wks plus &nbsp; &nbsp; <input type="radio" name="priority" value="Soon" <?php if($priority=='Soon') {echo 'checked="checked"';} ?> />Soon--within 4 weeks &nbsp; &nbsp; <input type="radio" name="priority" value="Urgent" <?php if($priority=='Urgent') {echo 'checked="checked"';} ?> />URGENT--within 2 wks</td></tr>
<tr><td class="fldview">Procedure</td><td class="data">
<select name="procedtype_id">
<?php
echo "<option value=\"$procedtype_id\">$proced</option>";
$popcode="procedtype_id";
$popname="CONCAT(proced, ' (', upper(category), ')')";
$poptable="procedtypes";
$where="";
$orderby="ORDER BY category, proced";
include('incl/showoptions.php');
?>
</select>
</td></tr>

<tr><td class="fldview">Management Intent</td><td class="data">
Current:<input type="radio" name="mgtintent" value="<?php echo $mgtintent; ?>" checked="checked" /><?php echo $mgtintent; ?>&nbsp;&nbsp;UPDATE: <input type="radio" name="mgtintent" value="Inpatient" />Inpatient &nbsp; &nbsp; <input type="radio" name="mgtintent" value="Renal Day Surgery" />Renal Day Surgery
</td></tr>
<?php
//use reqdate if linked from diary
if ($reqdate)
	{
	$sql="SELECT diarydate, freeslots, DATE_FORMAT(diarydate, '%a %d/%m/%Y') AS diaryddmy, availslots, daysurgflag from diarydates where diarydate ='$reqdate' LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$diaryddmy=$row["diaryddmy"];
	$availslots=$row["availslots"];
	$daysurgflag=$row["daysurgflag"];
	echo "<tr><td class=\"fldview\">Surgery Date</td><td class=\"data\"><b>Chosen date:</b> <span class=\"alert\">$diaryddmy </span><br>
	<b>Available Slots:</b> $availslots <br>
	(NOTE: X,Y,Z are new Renal Day Surgery slots when available)<br><b>Select slot:</b> ";
	//set field!
	echo '<input type="hidden" name="surgdate" value="' .$reqdate . '" id="surgdate" />';
	//get rid of slot spaces:
	$slotstrim=str_replace(" ", "", $availslots);
	$slots = str_split($slotstrim);
	foreach( $slots as $key => $value )
		{
			echo '<input type="radio" name="surgslot" value="' . $value . '" />Slot ' . $value . ' &nbsp; &nbsp;';
		}
//	echo " <br><i>Please ignore slot options listed below</i><br>";
	}
else
	{
	//display popdown; may contain existing Surg Date
	echo '<tr><td class="fldview">Surgery Date <br><i>(next 60 days with free slots shown)</i></td><td class="data">
	<select name="surgdate">';
	if ($surgdate)
		{
		echo "<option value=\"$surgdate\">$surgdate_ddmy</option>";
		echo "<option value=\"\">CANCEL $surgdate_ddmy --leave UNBOOKED</option>";
		}
	else
		{
		echo '<option value="">Select available date...</option>';
		}
	$sql="SELECT diarydate, freeslots, DATE_FORMAT(diarydate, '%a %d/%m/%Y') AS diaryddmy, availslots from diarydates where freeslots>0 AND diarydate >=NOW() LIMIT $limitdays";
	$result = $mysqli->query($sql);
	while($row = mysqli_fetch_assoc($result))
		{
		echo '<option value="' . $row['diarydate'] . '">' . $row['diaryddmy'] . ' (' . $row["freeslots"] . ') ' . $row["availslots"] . '</option>';
		}
	echo "</select>";
	}
?>
<?php
//include 'showslotsform.php';
?>
<!-- <br>
<b>Cancel:</b> <input type="radio" name="surgslot" value="" /> Click here to deselect all slots</td></tr> -->
<?php
if ($surgdate)
	{
echo '<tr><td class="fldview">Clear Surgery Date/Slot (IMPORTANT)</td><td class="data">
<input type="checkbox" name="debookdata" value="' . $surgdate . '/' . $surgslot . '" id="debook" />CANCEL existing Date <b>' . $surgdate_ddmy . '/Slot ' . $surgslot . '</b></td</tr>';	
	}
?>
<tr><td class="fldview">Surgery Booked by</td><td class="data">
<select name="booker">
<?php
if ($booker)
	{
	echo "<option value=\"$booker\">$booker</option>";
	}
else
	{
	echo '<option value="">Select booker...</option>';
	}
$popcode="user";
$popname="authorsig";
$popwhere="bedmanagerflag=1";
$poptable="renalware.userdata";
include('incl/limitedoptions.php');
?>
</select>
</td></tr>
<tr><td class="fldview">TCI Date --<br>REQUIRED for Adm Diary</td><td class="data">
Date: <input type="text" name="tcidate" value="<?php echo $tcidate_dmy; ?>" id="tcidate" size="12" />&nbsp;&nbsp;<b>TCI Time</b> (freetext)<span class="data"><input class="form" type="text" size="20" name="tcitime" value="<?php echo $tcitime; ?>" /></span>
</td></tr>
<tr><td class="fldview">Pre-Op Assessment Date (if applic)</td><td class="data">
Date: <input type="text" name="preopdate" value="<?php echo $preopdate_dmy; ?>" id="preopdate" size="12" />&nbsp;&nbsp;<b>Pre-Op Assess. Time</b> (freetext)<span class="data"><input class="form" type="text" size="20" name="preoptime" value="<?php echo $preoptime; ?>" /></span>
</td></tr>
<tr><td class="fldview">Suspended Date</td><td class="data">
Date: <input type="text" name="suspenddate" value="<?php echo $suspenddate_dmy; ?>" id="suspenddate" size="12" /></td></tr>
<tr><td class="fldview">Re-Listed Date</td><td class="data">
Date: <input type="text" name="relisteddate" value="<?php echo $relisteddate_dmy; ?>" id="relisteddate" size="12" /></td></tr>

<tr><td class="fldview">Infection Status</td><td class="data">
Edit as required: <input type="text" name="infxnstatus" value="<?php echo $infxnstatus; ?>" id="infxnstatus" size="75" />
</td</tr>
<tr><td class="fldview">Special Needs/Options</td><td class="data">
Anaesthetic: <input type="radio" name="anaesth" value="LA" <?php if($anaesth=='LA') {echo 'checked="checked"';} ?> />LA &nbsp; &nbsp; <input type="radio" name="anaesth" value="GA" <?php if($anaesth=='GA') {echo 'checked="checked"';} ?> />GA
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="shortnotice" value="OK" id="shortnotice" <?php if($shortnotice=='OK') {echo 'checked="checked"';} ?> />Short Notice OK?
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="no_shortnotice" value="X" id="no_shortnotice" <?php if($shortnotice=='X') {echo 'checked="checked"';} ?> />Not for Short Notice
</td</tr>
<tr><td class="fldview">Needs Transport?</td><td class="data">
<input type="radio" name="transportneed" value="N" <?php if($transportneed=='N') {echo 'checked="checked"';} ?> />No &nbsp;&nbsp;&nbsp; &nbsp; <input type="radio" name="transportneed" value="Y" <?php if($transportneed=='Y') {echo 'checked="checked"';} ?> />Yes
 &nbsp;&nbsp;If "Yes", <b>transport type</b>: <input type="text" name="transporttext" value="<?php echo $transporttext ?>" id="transporttext" size="40" />
</td</tr>

<tr><td class="fldview">Notes</td><td class="data"><textarea  class="form" name="schednotes" rows="7" cols="80"><?php echo $schednotes; ?></textarea></td></tr>
<tr><td class="fldview">Op Outcome</td><td class="data"><textarea  class="form" name="opoutcome" rows="7" cols="80"><?php echo $opoutcome; ?></textarea></td></tr>
<tr><td class="fldview">Update Status (IMPORTANT)</td><td class="data">
<select name="status">
<?php
echo "<option value=\"$status\">$status -- CURRENT</option>";
?>
<option value="Req">Requested/Pending</option>
<option value="Sched">Scheduled</option>
<option value="Susp">Suspended</option>
<option value="Arch">Archived (Done)</option>
</select>
</td</tr>
</table>
<input type="submit" name="submit" value="UPDATE Procedure for <?php echo $patient; ?>" id="submit" />
</fieldset>
</form>
<hr />
<form action="index.php" method="get">
<fieldset>
<input type="hidden" name="vw" value="pat" id="vw" />
<input type="hidden" name="scr" value="patview" id="scr" />
<input type="hidden" name="zid" value="<?php echo $zid; ?>" id="zid2" />
<input type="submit" name="submit" value="ABORT UPDATE -- RETAIN Current Procedure for <?php echo $patient; ?>" id="submit" />
</fieldset>
</form>
</td>
<td valign="top">
<?php
include "patinfotable_incl.php";
include( 'incl/currmedsportal.php' );
?>	
</td></tr>
</table>
<?php
include( 'proced/procedhist_incl.php' );
?>