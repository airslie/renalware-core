<?php
//display portal with updateable session form
if ( $_GET['sess'] )
	{
	$sesslimit=$_GET['sess'];
	}
if ($_GET['add']=="hdsession" )
	{
	$schedule = $currsched . '-' . $currslot;
	$weightchange = $wt_post-$wt_pre;
	include "$rwarepath/renal/hd/run/run_insertsessiondata.php";
	}
//for updateable listing
include "$rwarepath/renal/hd/sessions_portal.php";
