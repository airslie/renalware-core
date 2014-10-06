<?php
$fields = "
letterzid,
letthospno,
lettaddstamp,
lettmodifstamp,
typistinits,
letterdate,
lettertype_id,
lettertype,
DATE_FORMAT(clinicdate, '%a %d %b %Y') as clinicdate_ddmy,
clinicdate as clinicdateymd,
clinicdate,
status,
lettdescr,
patlastfirst,
authorlastfirst,
authorsig,
position,
recipname,
recipient,
salut,
patref,
pataddr,
lettproblems,
lettmeds,
lettresults,
lettallergies,
cctext,
modalstamp,
lettBPsyst,
lettBPdiast,
lettWeight,
lettHeight,
authorid,
typistid,
elecsig,
admdate,
admward,
dischdate as dischdateymd,
dischdate,
dischdest,
admconsultant,
reason,
deathcause,
admissionid,
typeddate,
reviewdate,
ltext as lettertext
";
$sql = "SELECT $fields FROM letterdata JOIN lettertextdata ON letter_id=lettertext_id WHERE letter_id=$letter_id LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
$patref=str_replace( "\r", "\n", $row["patref"]);
//try to retrieve from current PRN
if ( !$lettHeight )
{
	$lettHeight=$Height;
}
if ( $lettHeight>0 )
{
$lettBMI=round($lettWeight/$lettHeight/$lettHeight, 1);
}
//fixes
$recipvertbr = str_replace( "^", "<br>", $recipient);
$cctextvertbr = str_replace( "^", "<br>", $cctext);
$cctext2br = nl2br($cctext);
$recipnl2br = nl2br($recipient);
?>