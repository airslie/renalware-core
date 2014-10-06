<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$vwslist = array(
	'glance' => 'Day at a Glance',
	'surgdiary' => 'Surg Diary',
	'admdiary' => 'Admissions Diary',
	'req' => 'Pending Proceds',
	'arch' => 'Archived Proceds',
	'user' => 'User Help'
	);
$vwsnav = array(
	'vw=glance&amp;scr=dayview' => 'Day at a Glance',
	'vw=surgdiary&amp;scr=surgdiarylist&amp;period=thisweek' => 'Surg Diary',
	'vw=admdiary&amp;scr=admdiarylist&amp;period=thismonth' => 'Admissions Diary',
	'vw=req&amp;scr=reqlist' => 'Pending Proceds',
	'vw=arch&amp;scr=archlist' => 'Archived Proceds',
	'vw=user&amp;scr=systemguide' => 'User Help'
	);
