<?php
//----Fri 15 Nov 2013----lettersite parsed here
//----Mon 23 Jul 2012----
//Sun Dec 20 13:08:00 JST 2009
$fields = "*,
DATE_FORMAT(clinicdate, '%a %d %b %Y') as clinicdate_ddmy,
clinicdate as clinicdateymd,
dischdate as dischdateymd";
$sql= "SELECT $fields FROM letterdata JOIN lettertextdata ON letter_id=lettertext_id WHERE letter_id=$letter_id LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
$patref=str_replace( "\r", "\n", $row["patref"]);
//try to retrieve from current PRN
if ( !$lettHeight && $Height)
{
	$lettHeight=$Height;
}
if ($lettHeight)
{
$lettBMI=round($lettWeight/$lettHeight/$lettHeight, 1);
}
//----Fri 15 Nov 2013----
//KCH by default unless changed by letterdescr
$lettersite = 'KCH';
//allow override here via letterdescriptions 
if (substr_count($lettdescr, 'QEH')) {
	$lettersite='QEH';
}
if (substr_count($lettdescr, 'DVH')) {
	$lettersite='DVH';
}
if (substr_count($lettdescr, 'PRUH')) {
	$lettersite='PRUH';
}
