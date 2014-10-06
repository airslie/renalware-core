<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//$hostname="localhost";
//$hostname="renalweb.kingsch.nhs.uk";
//misc local options here
//show mini-cal in dayview? TRUE or FALSE
$showminical=TRUE;
date_default_timezone_set('Europe/London');
//to display mgtintents
$mgtintents=array(
	'Inpatient'=>'Inpatient--Fisk &amp; Cheere',
	'Renal Day Surgery'=>'Renal Day Surgery',
	);
//'23h Ward Stay'=>'23h Ward Stay--Matthew Whiting', ----Thu 16 Dec 2010----
//----Tue 06 Dec 2011----number of days in future to show in popups (prev 60)
$limitdays=90;
?>