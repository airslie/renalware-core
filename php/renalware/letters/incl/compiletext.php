<?php
switch($lettertype)
	{
	case "clinic":
$letterfulltext="Date: $letterdate
Clinic Date: $clinicdate_ddmy
$lettdescr

$recipient

$salut

$patref
$pataddr

PROBLEMS:
$lettproblems

CURRENT MEDICATIONS
$lettmeds

RECENT INVESTIGATIONS:
$lettresults

BP: $lettBPsyst/$lettBPdiast Weight: $lettWeight Height: $lettHeight BMI: $lettBMI Urine Blood: $letturine_blood Urine Protein: $letturine_prot

ALLERGIES/INTOLERANCE:
$lettallergies

$ltext

Yours sincerely

$elecsig

$authorsig
$position

cc:
$cctext

$typistinits

Renalware SQL Clinic Letter ID: $letter_id created: $lettaddstamp $status logged: $lettmodifstamp";
break;
	case "discharge":
$letterfulltext="Date: $letterdate

DISCHARGE SUMMARY

$recipient

$salut

$patref
$pataddr

ADMITTED: $admdate to $admward under Dr $admconsultant
DISCHARGED: $dischdate to $dischdest
REASON FOR ADMISSION:
$reason

PROBLEMS:
$lettproblems

MEDICATIONS ON DISCHARGE
$lettmeds

RECENT INVESTIGATIONS: $lettresults

ALLERGIES/INTOLERANCE:
$lettallergies

$ltext

Yours sincerely

$elecsig

$authorsig
$position

cc:
$cctext

$typistinits

Renalware SQL Discharge Summary ID: $letter_id created: $lettaddstamp $status logged: $lettmodifstamp";
break;
	case "death":
$letterfulltext="Date: $letterdate

DEATH NOTIFICATION

$recipient

$salut

$patref
$pataddr

ADMITTED: $admdate to $admward under Dr $admconsultant
DIED: $dischdate
REASON FOR ADMISSION:
$reason
CAUSE OF DEATH:
$deathcause

PROBLEMS:
$lettproblems

MEDICATIONS ON DISCHARGE
$lettmeds

RECENT INVESTIGATIONS: $lettresults

ALLERGIES/INTOLERANCE:
$lettallergies

$ltext

Yours sincerely

$elecsig

$authorsig
$position

cc:
$cctext

$typistinits

Renalware SQL Death Notification ID: $letter_id created: $lettaddstamp $status logged: $lettmodifstamp";
break;

case "simple":
$letterfulltext="Date: $letterdate
$lettdescr

$recipient

$salut

$patref
$pataddr

$ltext

Yours sincerely

$elecsig

$authorsig
$position

cc:
$cctext

$typistinits

Renalware SQL Letter ID: $letter_id created: $lettaddstamp $status logged: $lettmodifstamp";
break;
	}
?>