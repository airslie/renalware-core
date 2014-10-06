<?php
//----Fri 28 Feb 2014----logging enhancements
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

// 5. Render the text to HTML.
//NB using html vars from above
$handle2 = fopen("$gp_emails_path/$htmlfilename", "w");
fwrite($handle2, $html);
fclose($handle2);

// 6. Convert the HTML to PDF, then to Base64 text so that it can be attached.
$pdffilename=$basefilename.'.pdf';
shell_exec("/usr/local/bin/wkhtmltopdf \"$gp_emails_path/$htmlfilename\" \"$gp_emails_path_pdf/$pdffilename\"");
$pdftext = chunk_split(base64_encode(file_get_contents("$gp_emails_path_pdf/$pdffilename")));

//
// Here we send the email using the fields gathered above.
//

// Use a hash as the unique MIME boundary.
$hash= md5(uniqid(time()));

// Prepare the email header fields.
$to= "$gp_email_address";
$subject= "$gp_email_subject";
$headers= "Reply-To: <$emailback>" . "\r\n";
if (!empty($cc_addresses)) {
	$headers  .= "Cc: $cc_addresses" . "\r\n";
}
$headers  .= "MIME-Version: 1.0" . "\r\n";
$headers  .= "Content-Type: multipart/mixed; boundary=".$hash."" . "\r\n";
$extraopts = "-f \"$email_sender_address\" -F \"$email_sender_address\"";

$message = "
--$hash
Content-Type: text/plain; charset='iso-8859-1'
Content-Transfer-Encoding: 7bit

$emailbody

--$hash
Content-Type: application/pdf; name=\"$pdffilename\"
Content-Transfer-Encoding: base64
Content-Disposition: attachment

$pdftext

--$hash--";
 
// Now send the email.
if (mail($to, $subject, $message, $headers, $extraopts)) {
	// We add to gpemaillogs which will also indicate if it has
	// been sent in queues via LEFT JOIN.
	$lettdescr = $mysqli->real_escape_string($lettdescr);
	$practiceemail = $mysqli->real_escape_string($practiceemail);
    //----Fri 28 Feb 2014----now log html and filename
	$loghtml = $mysqli->real_escape_string($html);
	$logfilename = $mysqli->real_escape_string($basefilename);
	$table="gpemaillogs";
	$insertfields="logadddate, logzid, logletter_id, loghospno,loguid,loguser,logdescr,logemail,logpracticecode,loglettertype,logfilename,loghtml";
	$insertvalues="CURDATE(), $zid, $letter_id, '$hospno1',$uid,'$user','$lettdescr','$practiceemail','$practicecode','$lettertype','$logfilename','$loghtml'";
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
}
// ------------------END EMAIL SCRIPT IF gpemailflag -----------------
