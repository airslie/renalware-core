<?php
//Fri Jul 24 00:16:56 JST 2009 add 105 to popup
//if updated
if ($_GET['mode']=="update")
	{
	$accessCurrent = $mysqli->real_escape_string($_POST["accessCurrent"]);
	$accessCurrDate = $mysqli->real_escape_string($_POST["accessCurrDate"]);
	$accessPlan = $_POST["accessPlan"];
	$accessPlanner = $mysqli->real_escape_string($_POST["accessPlanner"]);
	$accessPlandate = $mysqli->real_escape_string($_POST["accessPlandate"]);
	$accessCurrDate = fixDate($accessCurrDate);
	$accessPlandate = fixDate($accessPlandate);
	//update the table
	$updatefields = "accessCurrent='$accessCurrent', accessCurrDate='$accessCurrDate', accessPlan='$accessPlan', accessPlanner='$accessPlanner', accessPlandate='$accessPlandate'";
	$sql= "UPDATE renaldata SET $updatefields, renalmodifstamp=NOW() WHERE renalzid=$zid";
$result = $mysqli->query($sql);
//log the event
	$eventtype="Patient Access Data updated -- $accessCurrent";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";

} // end update IF
//refresh data
$fields = "accessCurrent,accessCurrDate,accessPlandate,accessPlan,accessPlanner,accessLastAssessdate,accessRxDecision,accessSurveillance,accessAssessOutcome";
$sql= "SELECT $fields FROM renaldata WHERE renalzid=$zid";
include "$rwarepath/incl/runparsesinglerow.php";
	//handle access proced update
if (isset($_GET['updateproced_id']))
	{
	$accessprocdata_id=$_GET['updateproced_id'];
	$outcome = $mysqli->real_escape_string($_POST["outcome"]);
	$firstused_date = $mysqli->real_escape_string($_POST["firstused_date"]);
	$failuredate = $mysqli->real_escape_string($_POST["failuredate"]);
	$cathetermake = $mysqli->real_escape_string($_POST["cathetermake"]);
	$catheterlotno = $mysqli->real_escape_string($_POST["catheterlotno"]);
	$firstused_date=fixDate($firstused_date);
	$failuredate=fixDate($failuredate);
	$updatefields = "outcome='$outcome', firstused_date='$firstused_date', failuredate='$failuredate',cathetermake='$cathetermake',catheterlotno='$catheterlotno'";
	$sql= "UPDATE accessprocdata SET $updatefields, modifstamp=NOW() WHERE accessprocdata_id=$accessprocdata_id";
//    echo "TEST $sql <br>";
	$result = $mysqli->query($sql);
	//log the event
		$eventtype="Patient Access Procedure Data ID $accessprocdata_id updated";
		$eventtext=$mysqli->real_escape_string($updatefields);
		include "$rwarepath/run/logevent.php";
	}
?>
<div id="uitabs">
	<ul>
		<li><a href="#accessinfodiv">Current Access info</a></li>
		<li><a href="#accessinfoformdiv">Update Info</a></li>
		<li><a href="#accessfxndataformdiv">Add Assessment</a></li>
		<li><a href="#accessprocdataformdiv">Add Procedure</a></li>
		<li><a href="#accessclinicsformdiv">Add Access Clinic info</a></li>
	</ul>
	<div id="accessinfodiv">
		<ul class="portal">
		<li><b>Access:</b> <?php echo $accessCurrent; ?> &nbsp;&nbsp;<b>Date Formed:</b>  <?php echo $accessCurrDate; ?>&nbsp;&nbsp;</li>
		<li><b>Access Plan:</b> <?php echo $accessPlan; ?> &nbsp;&nbsp;<b>Decided by:</b> <?php echo $accessPlanner; ?> &nbsp;&nbsp;<b>Plan Date:</b>  <?php echo $accessPlandate; ?>&nbsp;&nbsp;</li>
		<li>
			<b>Latest Assessment Date:</b> <?php echo $accessLastAssessdate ?>&nbsp;&nbsp;
			<b>Rx Decision:</b> <?php echo $accessRxDecision ?>&nbsp;&nbsp;
			<b>Surveillance:</b> <?php echo $accessSurveillance ?>&nbsp;&nbsp;
			<b>Outcome:</b> <?php echo $accessAssessOutcome ?>&nbsp;&nbsp;
		</li>
		</ul>
		<?php
		include('access/accessfxndata_incl.php');
		include('access/accessprocdata_incl.php');
		include('access/accessclinics_incl.php');
		//include('access/vesseldata_incl.php');
		?>
	</div>
	<div id="accessinfoformdiv">
		<?php
		include('access/accessinfoform.html');
		?>
	</div>
	<!--  form here -->
	<div id="accessfxndataformdiv">
	<?php
	$addtable='accessfxndata';
	$addtablename='Duplex Ultrasound Assessments';
	$addlabel='Add new assessment';
	include('access/accessfxndataform.html');
	?>
	</div>
	<!-- end  form -->
	<!--  form here -->
	<div id="accessprocdataformdiv">
	<?php
	$addtable='accessprocdata';
	$addtablename='Access Procedures';
	$addlabel='Add new procedure';
	include('access/accessprocdataform.html');
	?>
	</div>
	<!-- end  form -->
	<!--  form here -->
	<div id="accessclinicsformdiv">
	<?php
	$addtable='accessclinics';
	$addtablename='Access Clinics';
	$addlabel='Add new access clinic';
	include('access/accessclinicsform.html');
	?>
	</div>
	<!-- end  form -->
</div> <!-- end uidiv -->