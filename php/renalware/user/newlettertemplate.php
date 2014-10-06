<?php
include '../req/confcheckfxns.php';
$formname="lettertemplate";
$pagetitle= "Add New Letter Template for $user";
//get header
include '../parts/head.php';
if ($_GET['mode']=="entry")
	{
	include('forms/' . $formname . 'form.html');
	}
if ($_GET['mode']=="add")
	{
	$templatename = $mysqli->real_escape_string($_POST["templatename"]);
	$templatetext = $mysqli->real_escape_string($_POST["templatetext"]);
	$insertfields = 'templateuid, templatename, templatetext, templatestamp';
	$values="'$uid', '$templatename', '$templatetext', NOW()";
	$table = "lettertemplates";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
	//log the event
	$eventtype="NEW LETTER TEMPLATE: $templatename";
	$eventtext=$templatetext;
	include "$rwarepath/run/logevent.php";
	//end logging
	echo '<p class="alert">The letter template has been added!</p><br>
	<small><a href="javascript:window.close();">You may now close this window.</a></small>';
	}
?>
</body>
</html>