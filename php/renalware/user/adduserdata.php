<?php
include '../req/confcheckfxns.php';
$formname="FORMNAME";
$pagetitle= "Add $formname for $user";
//get header
include '../parts/head.php';
if ($_GET['mode']=="entry")
	{
	include('forms/' . $formname . 'form.html');
	}
if ($_GET['mode']=="add")
	{
	include('incl/' . $formname . 'add.php');
	}
?>
</body>
</html>