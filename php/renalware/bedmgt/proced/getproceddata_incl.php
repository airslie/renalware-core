<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//Fri Feb 23 10:57:11 JST 2007
//Wed Feb 28 20:30:02 CET 2007 schednotes
//---------------Tue Apr 13 16:48:11 CEST 2010---------------transporttype bug fix
$fields="
pid,
pzid,
surg_id,
sched_uid,
procedtype_id,
hospno,
modal,
addstamp,
p.modifstamp,
tcidate,
preopdate,
IF(listeddate, DATE_FORMAT(listeddate, '%d/%m/%y'),'') AS listeddate_dmy,
IF(tcidate, DATE_FORMAT(tcidate, '%d/%m/%y'),'') AS tcidate_dmy,
IF(tcidate, DATE_FORMAT(tcidate, '%W %d %b %Y'),'') AS tcidate_ddmy,
IF(preopdate, DATE_FORMAT(preopdate, '%W %d %b %Y'),'') AS preopdate_ddmy,
IF(preopdate, DATE_FORMAT(preopdate, '%d/%m/%y'),'') AS preopdate_dmy,
tcitime,
preoptime,
consultant,
surgeon,
priority,
category,
proced,
mgtintent,
surgdate,
IF(status='Arch',DATEDIFF(surgdate,listeddate)+1, DATEDIFF(NOW(),listeddate)+1) as DOL,
IF(surgdate, DATE_FORMAT(surgdate, '%W %d/%m/%y'),'') AS surgdate_ddmy,
booker,
surgslot,
IF(suspenddate, DATE_FORMAT(suspenddate, '%d/%m/%y'),'') AS suspenddate_dmy,
IF(relisteddate, DATE_FORMAT(relisteddate, '%d/%m/%y'),'') AS relisteddate_dmy,
opoutcome,
infxnstatus,
cancelreason,
schednotes,
shortnotice,
no_shortnotice,
anaesth,
status,
transportneed,
transporttext,
dayno
";
$sql="SELECT $fields FROM proceddata p LEFT JOIN diarydates d ON surgdate=diarydate WHERE pid=$pid LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$pid=$row["pid"];
$pzid=$row["pzid"];
$surg_id=$row["surg_id"];
$sched_uid=$row["sched_uid"];
$procedtype_id=$row["procedtype_id"];
$hospno=$row["hospno"];
$modal=$row["modal"];
$addstamp=$row["addstamp"];
$modifstamp=$row["modifstamp"];
$listeddate=$row["listeddate_dmy"];
$tcidate=$row["tcidate"];
$tcidate_dmy=$row["tcidate_dmy"];
$preopdate=$row["preopdate"];
$preopdate_dmy=$row["preopdate_dmy"];
$tcidate_ddmy=$row["tcidate_ddmy"];
$preopdate_ddmy=$row["preopdate_ddmy"];
$tcitime=$row["tcitime"];
$preoptime=$row["preoptime"];
$consultant=$row["consultant"];
$surgeon=$row["surgeon"];
$priority=$row["priority"];
$category=$row["category"];
$proced=$row["proced"];
$mgtintent=$row["mgtintent"];
$daysonlist=$row["DOL"];
$surgdate_ddmy=$row["surgdate_ddmy"];
$surgdate=$row["surgdate"];
$booker=$row["booker"];
$surgslot=$row["surgslot"];
$suspenddate=$row["suspenddate_dmy"];
$relisteddate=$row["relisteddate_dmy"];
$opoutcome=$row["opoutcome"];
$infxnstatus=$row["infxnstatus"];
$cancelreason=$row["cancelreason"];
$schednotes=$row["schednotes"];
$shortnotice=$row["shortnotice"];
$no_shortnotice=$row["no_shortnotice"];
$anaesth=$row["anaesth"];
$status=$row["status"];
$transportneed=$row["transportneed"];
$transporttext=$row["transporttext"];
$zid=$pzid;
$surgdayno=$row["dayno"];
//get pat data via zid
$fields="
title,
lastname,
firstnames,
suffix,
hospno1,
sex, age,
birthdate,
maritstatus,
ethnicity,
religion,
language,
interpreter,
specialneeds,
addr1,
addr2,
addr3,
addr4,
postcode,
tel1,
tel2,
fax,
mobile,
email,
gp_name,
gp_addr1,
gp_addr2,
gp_addr3,
gp_addr4,
gp_postcode,
gp_tel,
gp_fax,
gp_email,
healthauthcode,
hd.transporttype,
modalcode,
modalsite,
currsched,
currslot
";
$table="renalware.patientdata p LEFT JOIN renalware.hdpatdata hd ON patzid=hdpatzid";
$where="WHERE patzid=$zid";
$sql="SELECT $fields FROM $table $where LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$patientref=$row["firstnames"] . ' ' . $row["lastname"] . ' (Hosp No. ' . $row["hospno1"] . ' DOB: ' . dmyyyy($row["birthdate"]) .')';
$title=$row["title"];
$lastname=$row["lastname"];
$firstnames=$row["firstnames"];
$suffix=$row["suffix"];
$sex=$row["sex"];
$age=$row["age"];
$birthdate=dmyyyy($row["birthdate"]);
$hospno=$row["hospno1"];
$maritstatus=$row["maritstatus"];
$ethnicity=$row["ethnicity"];
$religion=$row["religion"];
$language=$row["language"];
$interpreter=$row["interpreter"];
$specialneeds=$row["specialneeds"];
$addr1=$row["addr1"];
$addr2=$row["addr2"];
$addr3=$row["addr3"];
$addr4=$row["addr4"];
$postcode=$row["postcode"];
$tel1=$row["tel1"];
$tel2=$row["tel2"];
$fax=$row["fax"];
$mobile=$row["mobile"];
$email=$row["email"];
$patblock= "$title $firstnames $lastname $suffix\n$addr1\n$addr2\n$addr3 $addr4 $postcode\nTel1: $tel1\nTel2: $tel2\nMobile: $mobile\nEmail: $email";
$gp_name=$row["gp_name"];
$gp_addr1=$row["gp_addr1"];
$gp_addr2=$row["gp_addr2"];
$gp_addr3=$row["gp_addr3"];
$gp_addr4=$row["gp_addr4"];
$gp_postcode=$row["gp_postcode"];
$gp_tel=$row["gp_tel"];
$gp_fax=$row["gp_fax"];
$gp_email=$row["gp_email"];
$healthauthcode=$row["healthauthcode"];
$transporttype=$row["transporttype"];
$modalcode=$row["modalcode"];
$modalsite=$row["modalsite"];
$currsched=$row["currsched"];
$currslot=$row["currslot"];
$patient=$row["firstnames"] . ' ' . $row["lastname"];