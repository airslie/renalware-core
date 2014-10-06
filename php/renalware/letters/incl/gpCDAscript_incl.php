<?php
// updated Mon 10 Jun 2013 based on KCH server version
//  renalware version ----Mon 30 Jan 2012----
//  Script by Jamie Nguyen
//
// ------------------START EMAIL SCRIPT ---------------------------------------------------
// NB path variables now in config_incl.php

//
// Here we gather the necessary fields for the email.
//

// 1. Email subject.
$gp_email_subject = "$lettdescr from King's Renal Unit (KCH No $hospno1)";
// 2. Email sender address and return email.
$email_sender_address = "kch.notifications@nhs.net";
//$cc_addresses="hugh.cairns@nhs.net"; //NB must be nhs.net email
$gp_email_address="$practiceemail";
// 4. Information for the <IDENT> metadata fields.
/* from the specs
	<IDENT>PracticeIdent|LastName|FirstName|ID|NHS|DOB|KINGS COLLEGE HOSPITAL|LetterCreator|VisitDate|LetterName|LetterID|OriginatingUser|Created Date|GPIdent|CareGroup|LetterFrom</IDENT>
	This is an automated email - please do not reply directly to this email.
	Please call on 000 1111 2222 or email aaa@bbb.ccc if you have any queries.
*/
$phoneback="020 3299 6233";
$emailback="kch-tr.renal@nhs.net";

$emailbody="<IDENT>$practicecode|$lastname|$firstnames|$hospno1|$nhsno|$birthdate|KINGS COLLEGE HOSPITAL|Renalware|$clinicdate|$lettdescr|$letter_id|$authorlastfirst|$letterdate|$gp_natcode|RenalCareGroup|$authorsig</IDENT>\r\n
This is an automated email - please do not reply directly to this email.\r\n
Please call on $phoneback or email $emailback if you have any queries.\r\n";


//$cda_metadata="<IDENT>$practicecode|$lastname|$firstnames|$hospno1|$nhsno|$birthdate|KINGS COLLEGE HOSPITAL|Renalware|$clinicdate|$lettdescr|$letter_id|$authorlastfirst|$letterdate|$gp_natcode|RenalCareGroup|$authorsig</IDENT>";
$cda_metadata="
<div class=\"organisationName\">$lettdescr<div>
<div class=\"authorSig\">$authorsig</div>

<div class=\"gpPracticeCode\">$practicecode</div>
<div class=\"recipientGiven\">$gp_name</div>
<div class=\"recipientFamily\">$gplastname</div>
<div class=\"receivedOrgainisationName\">$practicename</div>
<div class=\"gpPracticeEmail\">$gp_email_address</div>

<div class=\"effectiveTimeValue\">$letterdate</div>
<div class=\"patientGiven\">$firstnames</div>
<div class=\"patientFamily\">$lastname</div>
<div class=\"patientGender\">$sex</div>
<div class=\"patientBirthdate\">$birthdate</div>
<div class=\"patientRoleId\">$nhsno</div>
<div class=\"sendCDAflag\">$sendCDAflag</div>
";

// 5. Render the text to HTML.
//NB using html vars from above
$handle2 = fopen("$gp_emails_path/$htmlfilename", "w");
fwrite($handle2, $html);
fclose($handle2);

$cdafilename = $basefilename.'.cda';
$handle3 = fopen("$gp_emails_path/$cdafilename", "w");
fwrite($handle3, $cda_metadata);
fclose($handle3);


// 6. Send the HTML and PDF to another server to be converted to TIFF and sent as attachment to CDA message
shell_exec("/usr/bin/scp \"$gp_emails_path/$cdafilename\" cdauser@10.148.129.117:/srv/renalwareIN/cda/$cdafilename");
shell_exec("/usr/bin/scp \"$gp_emails_path_pdf/$pdffilename\" cdauser@10.148.129.117:/srv/renalwareIN/pdf/$pdffilename");
shell_exec("/usr/bin/scp \"$gp_emails_path/$htmlfilename\" cdauser@10.148.129.117:/srv/renalwareIN/html/$htmlfilename");

// We add to gpCDAlogs which will also indicate if it has
// been sent in queues via LEFT JOIN.
$lettdescr = $mysqli->real_escape_string($lettdescr);
$table="gpCDAlogs";
$insertfields="logadddate, logzid, logletter_id, loghospno,loguid,loguser,logdescr,logpracticecode,loglettertype";
$insertvalues="CURDATE(), $zid, $letter_id, '$hospno1',$uid,'$user','$lettdescr','$practicecode','$lettertype'";
$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
// ------------------END EMAIL SCRIPT IF sendCDAflag -----------------
