<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//default view only:
$procedoptions = "<a href=\"index.php?vw=proced&amp;scr=view&amp;zid=$zid&amp;pid=$pid&mode=popup\" target=\"new\">view</a>";
$schedoptions = "<a href=\"index.php?vw=proced&amp;scr=view&amp;zid=$zid&amp;pid=$pid&mode=popup\" target=\"new\">view</a>";
$patviewlink="<a href=\"index.php?vw=pat&amp;scr=patview&amp;zid=$zid\">patview</a>";
if ( $bedmgrflag=='1' ) {
	$diaryoptions = '<a href="index.php?vw=proced&amp;scr=update&amp;zid=' . $zid . '&amp;pid=' . $pid . '&reqdate=' . $searchday . '">add to ' . $diarydate_ddmy . '</a>';
	$procedoptions = '<a href="index.php?vw=proced&amp;scr=update&amp;zid=' . $zid . '&amp;pid=' . $pid . '">sched</a>&nbsp;&nbsp;<a href="index.php?vw=proced&amp;scr=cancel&amp;zid=' . $zid . '&amp;pid=' . $pid .'">cancel</a>';
	$schedoptions = '<a href="index.php?vw=proced&amp;scr=update&amp;zid=' . $zid . '&amp;pid=' . $pid . '">update</a>&nbsp;&nbsp;<a href="index.php?vw=proced&amp;scr=cancel&amp;zid=' . $zid . '&amp;pid=' . $pid .'">cancel</a>';
}
if ( $row["status"]=='Canc' ) {
    $procedoptions = "<a href=\"index.php?vw=proced&amp;scr=view&amp;zid=$zid&amp;pid=$pid&mode=popup\" target=\"new\">view cancelled</a>";
    $schedoptions = "<a href=\"index.php?vw=proced&amp;scr=view&amp;zid=$zid&amp;pid=$pid&mode=popup\" target=\"new\">view cancelled</a>";
}
//hide for printing
if ($mode=='print') {
    $diaryoptions = "";
    $procedoptions ="";
    $schedoptions = "";
    $patviewlink = "";
}
