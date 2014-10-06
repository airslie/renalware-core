<?php
//----Tue 04 Sep 2012----bugfix
//----Mon 27 Aug 2012----
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//Sun Sep 27 15:40:59 CEST 2009
include('letter/lettertypes_incl.php');
$showpriority=strtoupper($priority);
echo "<div class=\"$priority\">$proced -- Priority $showpriority (Status: $status)</div>";
	if ( $status!='Arch' )
	{
	echo "<p>Print (new window): ";
	foreach ($lettertypes as $type => $descr) {
		echo '<a href="letter.php?pid=' . $pid .'&amp;type='.$type.'" target="new">'.$descr.'</a> &nbsp;&nbsp;&nbsp;';
		}
	echo '</p>';
	}
echo "<h3>Procedure details -- $patientref</h3>";
if ( $status!='Arch' ){
    echo "<p>";
    include( 'incl/procedoptions_incl.php' );
    echo $schedoptions . '&nbsp;&nbsp;' . $patviewlink . '</p>';
}
echo '<table><tr><td valign="top">';
include "patinfotable_incl.php";
//include( 'incl/currmedsportal.php' );
echo '</td><td valign="top">
<table>
    <tr><td class="fldview">Procedure (Category)</td><td class="data">'.$proced.' ('.$category.')</td></tr>
    <tr><td class="fldview">Consultant</td><td class="data">'.$consultant.'</td></tr>
    <tr><td class="fldview">Surgeon</td><td class="data">'.$surgeon.'</td></tr>
    <tr><td class="fldview">Listed Date</td><td class="data">'.$listeddate.' Days on List: '.$daysonlist.' <i>days</i></td></tr>
    <tr><td class="fldview">Priority</td><td class="data"> '.$priority.'</td></tr>
    <tr><td class="fldview">TCI Date</td><td class="data">'.$tcidate_ddmy.'
    &nbsp;&nbsp;<b>TCI Time</b> <span class="data">'.$tcitime.'</span></td></tr>
    <tr><td class="fldview">Pre-Op Assessment Date</td><td class="data">'. $preopdate.'&nbsp;&nbsp;<b>Pre-Op Assess. Time</b> <span class="data">'.$preoptime.'</span></td></tr>
    <tr><td class="fldview">Surgery Date/Slot</td><td class="data">'.$surgdate_ddmy . ' <b>Slot:</b> ' . $surgslot.'
    <tr><td class="fldview">Notes/Comments</td><td class="data">'.$schednotes.'</td></tr>
    <tr><td class="fldview">Outcome</td><td class="data">'.$opoutcome.'</td></tr>
    <tr><td class="fldview">Cancellation reason</td><td class="data">'.$cancelreason.'</td></tr>
</table>
</td></tr>
</table>';
//allow edit here if not Archived
if ( $status!='Arch' ) {
    echo "<p>";
    include( 'incl/procedoptions_incl.php' );
    echo $schedoptions . '&nbsp;&nbsp;' . $patviewlink . '</p>';
}
include 'proced/procedhist_incl.php';
