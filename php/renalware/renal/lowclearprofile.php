<?php
$form_data=array(
	'lowFirstseendate.d' => 'date first seen',
	'lowDialPlan.o' => 'dialysis plan',
	'lowDialPlandate.d' => 'dial plan date',
	'lowPredictedESRFdate.d' => 'predicted ESRF date',
	'lowReferralCRE.t5' => 'referral CRE',
	'lowReferralEGFR.t5' => 'referral eGFR',
	'lowReferredBy.t70' => 'referred by',
	'lowEducationType.s' => 'Education Type',
	'lowEducationStatus.s' => 'Education status',
	'lowAttendeddate.d' => 'Date Attended Educ',
	'lowDVD1.n' => '&rsquo;Your Kidneys&lsquo; DVD',
	'lowDVD2.n' => '&rsquo;Dial Choices&lsquo; DVD',
	'lowTxReferralflag.n' => 'Tx Team Referral',
	'lowTxReferraldate.d' => 'Referral date',
	'lowHomeHDflag.n' => 'Home HD',
	'lowSelfcareflag.n' => 'Self Care',
	'lowAccessnotes.a2x70' => 'Low Clearance Access notes',
	'alertflag.n' => 'MDM Alert/Worry Board?',
	);

$lowEducationType_options=array(
	'day',
	'evening'
	);
$lowEducationStatus_options=array(
	'invited',
	'attended',
	'declined',
	);
// ----Wed 16 Nov 2011----for optionlists usage
$sql = "SELECT listhtml FROM optionlists WHERE listname='lowdialplans' LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$lowDialPlan_optionlist= $row["listhtml"];

if ($mode=="runupdate")
	{
	$updatefields="renalmodifstamp=NOW()";
	foreach ($_POST as $key => $value) {
			${$key}=$mysqli->real_escape_string($value);
			if (substr($key,-4)=="date")
				{
				${$key} = fixDate($value);
				}
				if (substr($key,-3)!="_id")
					{
						$updatefields .= $value ? ", $key='".${$key}."'" : ", $key=NULL";
					}
		}
		//upd  the table
		$table = 'renaldata';
		$sql= "UPDATE $table SET $updatefields WHERE renalzid=$zid";
		$result = $mysqli->query($sql);
//log the event
	$eventtype="Patient Low Clearance Data updated";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
} // end update IF
//refresh data
include('../data/lowdata.php');
?>
<ul class="portal" >
<?php
$basket=array(
	'lowFirstseendate.d' => 'date first seen',
	'lowDialPlan.s' => 'dialysis plan',
	'lowDialPlandate.d' => 'dial plan date',
	'lowPredictedESRFdate.d' => 'predicted ESRF date',
	);
echo "<li>";
foreach ($basket as $fldtype => $lbl) {
			list($fld,$fldtype)=explode('.',$fldtype);
			echo '<b>'.$lbl.':</b> '.${$fld}.' &nbsp;&nbsp;';
	}
echo "</li>";
$basket=array(
	'lowReferralCRE.t5' => 'referral CRE',
	'lowReferralEGFR.t5' => 'referral eGFR',
	'lowReferredBy.t70' => 'referred by',
	'break2' => 'break',
	'lowEducationType.s' => 'Education Type',
	'lowEducationStatus.s' => 'Education status',
	'lowAttendeddate.d' => 'Date Attended Educ',
	'lowDVD1.yn' => '&rsquo;Your Kidneys&lsquo;',
	'lowDVD2.yn' => '&rsquo;Dialysis Choices&lsquo;',
	);
	echo "<li>";
	foreach ($basket as $fldtype => $lbl) {
				list($fld,$fldtype)=explode('.',$fldtype);
				echo '<b>'.$lbl.':</b> '.${$fld}.' &nbsp;&nbsp;';
		}
	echo "</li>";
	$basket=array(
		'lowTxReferralflag.n' => 'Tx Team Referral',
		'lowTxReferraldate.d' => 'Referral date',
		'lowHomeHDflag.n' => 'Home HD',
		'lowSelfcareflag.n' => 'Self Care',
		'alertflag.n' => 'MDM Alert/Worry Board?',
		);
	echo "<li>";
	foreach ($basket as $fldtype => $lbl) {
				list($fld,$fldtype)=explode('.',$fldtype);
				echo '<b>'.$lbl.':</b> '.${$fld}.' &nbsp;&nbsp;';
		}
	echo "</li>";
	echo "<li><b>Tx Wait List Status</b> $txWaitListStatus</li>";
	//----Thu 04 Aug 2011----
	if ($mrsaflag) {
		echo "<li><b>Last MRSA</b> $mrsadate <b>Swab site</b> $mrsasite <b>Positive?</b> $mrsaflag</li>";
	}
?>
</ul>
<br><b>LC Access Notes</b> <?php echo $lowAccessnotes ?>
</div>
<div id="updateformdiv" style="display: none;">
	<form action="<?php echo $thisurl ?>&amp;mode=runupdate" method="post" accept-charset="utf-8">	
	<fieldset>
	<legend>Update Low Clearance data</legend>
	<ul class="form">
	<?php
	include 'forms/makeformtable_incl.php';
	?>
	<li class="submit"><input type="submit" style="color: green;"  value="Update" />&nbsp;&nbsp;
	<input type="button" class="ui-state-default" style="color: white; background: red" value="Cancel" onclick="$('#updateformdiv').toggle()"/></li>
	</ul>
	</fieldset>
	</form>
</div>