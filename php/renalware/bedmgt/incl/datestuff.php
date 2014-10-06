<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$todayday=date("d");
$todayymd=date("Y-m-d");
$todaydmy=date("d/m/y");
$todayddmy=date("D j F Y");
$todayDayMonYear=date("j F Y");
//TODO fix these
$tomorrymd=date("Y-m-d", mktime(0, 0, 0, date("m")  , date("d")+1, date("Y")));
$tomorrdmy=date("d/m/y", mktime(0, 0, 0, date("m")  , date("d")+1, date("Y")));
$thisweekno=date("W");
$nextweekno=date("W", mktime(0, 0, 0, date("m")  , date("d")+7, date("Y")));
$thismonthno=date("m");
$thismonth=date("M");
$thisyear=date("Y");
$thismonthyy=date("M Y");
//next month
if ( $thismonthno!=12 )
{
	$nextmonthyy=date("M Y", mktime(0, 0, 0, date("m")+1  , date("d"), date("Y")));
	$nextmonthno=date("m", mktime(0, 0, 0, date("m")+1  , date("d"), date("Y")));
	$nextmonthyear=$thisyear;
}
else
{
	$nextmonthyy=date("M Y", mktime(0, 0, 0, 1 , date("d"), date("Y")+1));
	$nextmonthyear=$thisyear+1;
	$nextmonthno='01';
}
?>