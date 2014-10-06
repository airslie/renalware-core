<?php
//----Tue 09 Sep 2014----restore EDTAcode/ERF04 to output
//----Fri 05 Sep 2014----miscell tweaks; handling of PRD code (ERFAJ)
//----Fri 30 May 2014----tidying of JOINs and output; disable debugging
//----Thu 24 Apr 2014----Aranesp conversion fix
//----Fri 04 Apr 2014---- EPO testing
//----Fri 04 Apr 2014----now use qend_epodata for EPO section (see prepquarter changes)
//----Wed 26 Feb 2014----get QUA65hhmm from new hours format e.g. 2:30
//----Thu 13 Feb 2014----BP additions ----Sat 15 Feb 2014----
//----Sat 08 Feb 2014----QUA and EPO additions
//----Fri 18 Oct 2013----EpisodeHeartFailure/ERF24 handling
//--Mon Oct 15 09:28:38 SGT 2012--streamlining
//Mon Dec 15 12:44:55 JST 2008
//updated Fri Apr 24 14:53:45 IST 2009 per RenalWretch requests
require '../config_incl.php';
//require '../incl/check.php';
header("Content-type: text/plain");
include 'incl/renalreg_config.php';
include 'incl/rregmaps_incl.php';
$thisqtr=$_SESSION['sessqtr'];
$thisstartdate=$_SESSION['sessstartdate'];
$thisenddate=$_SESSION['sessenddate'];
$debug=$_GET['debug'];
if ($debug == 'Y') {
    $epo_debug=true;
    $debug = true;
}
//DISABLE DEBUG OUTPUT ----Thu 29 May 2014----
$epo_debug=false;
$debug = false;
//END DISABLE
$qtr=$_GET['qtr'];
$thisqtrpatdata="qtr{$qtr}_patientdata";
$rundate=date("m/d/Y");
$startdmy=$qtrstartdmys[$qtr];
$enddmy=$qtrenddmys[$qtr];
$qtrstart_ymd=$qtrstartdates[$qtr];
$qtrend_ymd=$qtrenddates[$qtr];
$qtroutput="!CNT:\$CNT00=$center|\$CNT01=$rundate|\$CNT02=$qtr|\r";
//echo $patoutput;
$sql="SELECT patzid, rregno, 
UPPER(lastname) AS IDN01, 
UPPER(TRIM(firstnames)) AS IDN02, 
IF(sex='M', '1', '2') as PAT00, 
DATE_FORMAT(birthdate, '%d/%m/%Y') AS IDN03,
DATE_FORMAT(deathdate, '%d/%m/%Y') AS PAT40, 
hospno1, modalcode, modalsite, 
UPPER(LEFT(addr1,40)) as PAT20, 
UPPER(LEFT(addr2,40)) as PAT21, 
postcode as PAT23, 
ethnicity, gp_postcode as PAT27,
deathCauseEDTA1 as PAT42, 
DATE_FORMAT(firstseendate, '%d/%m/%Y') as PAT33,
DATE_FORMAT(endstagedate, '%d/%m/%Y') AS ERF00, 
EDTAcode as ERF04, 
rreg_prdcode as ERFAJ, 
IF(Angina='Y','2','1') as ERF20,
IF(PreviousMIlast90d='Y','2','1') as ERF21,
IF(PreviousMIover90d='Y','2','1') as ERF22,
IF(PreviousCAGB='Y','2','1') as ERF23,
IF(EpisodeHeartFailure='Y','2','1') as ERF24,
IF(Smoking='Y','2','1') as ERF30,
IF(COPD='Y','2','1') as ERF31,
IF(CVDsympt='Y','2','1') as ERF32,
IF(DiabetesNotCauseESRF='Y','2','1') as ERF33,
IF(Malignancy='Y','2','1') as ERF34,
IF(LiverDisease='Y','2','1') as ERF35,
IF(Claudication='Y','2','1') as ERF40,
IF(IschNeuropathUlcers='Y','2','1') as ERF41,
IF(AngioplastyNonCoron='Y','2','1') as ERF42,
IF(AmputationPVD='Y','2','1') as ERF43,
LEFT(txWaitListStatus,1) as QUA06,
IF(patientdata.esdflag=1,'2','1') as QUA51,
rrmodalcode as QUA02,
rregsitecode as QUA04,
sitetype as QUA05,
QUA10, QUA11, QUA21, QUA22, QUA23, QUA24, QUA25, QUA26, QUA27, QUA30, QUA31, QUA32, QUA33, QUA34, 
ethnicityreadcode as PAT25,
hdpatdata.hours as QUA65hhmm,
hdpatdata.currsite as hdcurrsite,
BPsyst, BPdiast,
renalreg.qend_epodata.*
FROM renalware.patientdata 
JOIN renalware.renaldata ON patzid=renalzid 
JOIN renalware.esrfdata ON patzid=esrfzid 
JOIN renalware.currentclindata ON patzid=currentclinzid 
LEFT JOIN renalware.hdpatdata ON patzid=hdpatzid 
LEFT JOIN renalreg.qend_epodata ON patzid=epozid 
JOIN renalreg.lastmodaldata m ON patzid=lastmodalzid 
LEFT JOIN renalreg.qtr_pathdata ON patzid=pathzid 
LEFT JOIN renalreg.ethnicreadcodes ON ethnicity=ethnicityname 
WHERE rregflag=1 ORDER BY lastname, firstnames $limit";
$result = $mysqli->query($sql);
if ($debug){ echo $sql . "\r\r"; }
$numrows=$result->num_rows;
echo "\rnumber: ".$numrows;
if ($debug) {
    echo "\rWARNING: DEBUG MODE -- ONLY $limitno RECORDS DISPLAYED \r\r";
}
if ($epo_debug) {
    echo "\rWARNING: EPO DEBUG MODE--NOT FOR TRANSMISSION \r\r";
}
while($row = $result->fetch_assoc())
	{
    //flag HD pats
    $HDpatflag = (strpos($row["modalcode"],'HD') !== false) ? true : false ;
	//misc code fixes
	//ethnic
	$patoutput=""; //reset
	$zid=$row["patzid"];
	$ethnicity=$row["ethnicity"];
	$rregno=$row["rregno"];
	$PAT02 = ($rregno) ? 'A' : 'B' ;
	$PAT03='Y'; //default; all ESRF pats
    //start IDN
	$patoutput= '!IDN:$IDN00='.$rregno.'|$IDN01="'.$row["IDN01"].
    '"|$IDN02="'.$row["IDN02"].'"|$IDN03='.$row["IDN03"].
    '|$IDN04='.$row["hospno1"]."|\r";
    //start PAT
	$patoutput.='!PAT:$PAT00='.$row["PAT00"].'|$PAT01='.$center.
    '|$PAT02='.$PAT02.'|$PAT03='.$PAT03.'|$PAT04=N|$PAT05=Y|$PAT20="'.$row["PAT20"].
    '"|$PAT21="'.$row["PAT21"].'"|$PAT22="'.$row["PAT22"].
    '"|$PAT23='.$row["PAT23"].'|$PAT25=%READ='.$row["PAT25"].'|$PAT27='.$row["PAT27"].'|';
	if ($row["PAT33"] && $row["PAT33"]!='00/00/0000') {
		$patoutput.='$PAT33='.$row["PAT33"].'|';
	}
	if ($row["PAT40"]) {
		$pat42 = ($row["PAT42"]) ? $row["PAT42"] : '0';
			$patoutput.='$PAT40='.$row["PAT40"].'|$PAT42=%EDTA1='.$pat42.'|';
		}
	$patoutput.='!ENDPAT'."\r";
    //start ERF
	if ($PAT03=='Y') {
	$patoutput.='!ERF:$ERF00='.$row["ERF00"].
    '|$ERF04=%EDTA2='.$row["ERF04"].'|$ERFAJ='.$row["ERFAJ"].
    '|$ERF20='.$row["ERF20"].'|$ERF21='.$row["ERF21"].'|$ERF22='.$row["ERF22"].
    '|$ERF23='.$row["ERF23"].'|$ERF24='.$row["ERF24"].'|$ERF30='.$row["ERF30"].
    '|$ERF31='.$row["ERF31"].'|$ERF32='.$row["ERF32"].'|$ERF33='.$row["ERF33"].
    '|$ERF34='.$row["ERF34"].'|$ERF35='.$row["ERF35"].'|$ERF40='.$row["ERF40"].
    '|$ERF41='.$row["ERF41"].'|$ERF42='.$row["ERF42"].'|$ERF43='.$row["ERF43"].
    '|$ERF90=N|$ERF91=N|!ENDERF'."\r";
	}
    //start EPO
    //----Sat 08 Feb 2014----ESD info
    if ($row["epozid"]) {
        //only display for current ESD pats
        // EPO11 EPO drug name (Read code) (Code list RR6)
        // EPO12 EPO dosage per week
        $unitsperwk = $row["esdunitsperweek"]; //EPO12 default ----Mon 10 Mar 2014----
        //calculate EPO11
        $EPO11='i44..'; //assume eprex/alpha
        if (strpos($row["drugname"], 'Neo') !== false) {
            $EPO11='i45..'; //NeoRecormon
        }
        if (strpos($row["drugname"], 'Aranesp') !== false) {
            $EPO11='Zi45x';
            //fix for Aranesp ----Thu 24 Apr 2014----now proper conversion
            $unitsperwk = $unitsperwk/200;
        }
        if (strpos($row["drugname"], 'Darbepoetin') !== false) {
            $EPO11='Zi45x';
        }
        if (strpos($row["drugname"], 'Mircera') !== false) {
            $EPO11='Zi45y';
            //fix for Mircera
            $unitsperwk = $unitsperwk/424;
        }
        if (strpos($row["drugname"], 'Retacrit') !== false) {
            $EPO11='Zi45v';
        }
        if ($epo_debug) {
            $EPO11 .= '***DEBUG: '.$row["drugname"]. ' RAW UNITS/WK: '.$row["esdunitsperweek"]."***";
        }
     $patoutput.='!EPO:$EPO00='.$startdmy. '|$EPO01='.$enddmy.
         '|$EPO11=%READ='.$EPO11.
         '|$EPO12='.$unitsperwk.'|!ENDEPO'."\r";
    }
    //start QUA
    //set default RJZ for non-HD site patients
    $QUA04 = ($row["QUA04"]) ? $row["QUA04"] : "RJZ" ;
    $patoutput.='!QUA:$QUA00='.$startdmy. '|$QUA01='.$enddmy.
        '|$QUA02=%RR='.$row["QUA02"]. '|$QUA04='.$QUA04.
        '|$QUA05=%RR='.$row["QUA05"].'|$QUA09=Y';
    $pathfields=array(
    'QUA10',
    'QUA11',
    'QUA21',
    'QUA22',
    'QUA23',
    'QUA24',
    'QUA25',
    'QUA26',
    'QUA27',
    'QUA30',
    'QUA31',
    'QUA32',
    'QUA33',
    'QUA34',
    );
    foreach ($pathfields as $key => $fld) {
    	if ($row["$fld"]) {
    		$patoutput.='|$'.$fld.'='.$row["$fld"];
    	}
    }
    //REFERENCE:
// Table 11.1: BPs pre and post HD, and average for PD & Transplant
// QUA40 - Systolic BP (mm Hg) (60 - 300), pre dialysis if HD/PD
// QUA41 - Diastolic BP (mm Hg) (35 - 200), pre dialysis if HD/PD
// QUA44 - Post dialysis Systolic BP (mm Hg) (60-300)
// QUA45 - Post dialysis Diastolic BP (mm Hg) (30 - 200)
    //for HD pat BPs
    if ($HDpatflag) {
        //----Sat 05 Apr 2014---- ---------START GET HDSESSDATA -------------
        $hdsesssql = "SELECT hdsesszid, FLOOR(AVG(syst_pre)) AS qtravg_systpre, 
       FLOOR(AVG(diast_pre)) AS qtravg_diastpre, 
       FLOOR(AVG(syst_post)) AS qtravg_systpost, 
       FLOOR(AVG(diast_post)) AS qtravg_diastpost 
       FROM renalware.hdsessiondata WHERE hdsesszid=$zid AND hdsessdate BETWEEN '$qtrstart_ymd' AND '$qtrend_ymd'";
        $hdsessresult = $mysqli->query($hdsesssql);
       // if ($debug){ echo $hdsesssql . "\r\r"; }
        $hdsessrow = $hdsessresult->fetch_assoc();
        //----Sat 05 Apr 2014---- ---------END GET HDSESSDATA -------------
       $patoutput.='|$QUA40='.$hdsessrow["qtravg_systpre"] .
        '|$QUA41='.$hdsessrow["qtravg_diastpre"] .
        '|$QUA44='.$hdsessrow["qtravg_systpost"] .
        '|$QUA45='.$hdsessrow["qtravg_diastpost"];
    } else {
        //standard BP only from currclindata
        $patoutput.='|$QUA40='.$row["BPsyst"] .
         '|$QUA41='.$row["BPdiast"];
    }
    $patoutput.='|$QUA51='.$row["QUA51"];
    //----Sat 08 Feb 2014----new fields added here
    //$QUA64=3; //dial times/wk
    $patoutput.='|$QUA64=3';
    if ($row["QUA65hhmm"]) {
        //----Wed 26 Feb 2014----
        list($dialhh, $dialmm)=explode(":",$row["QUA65hhmm"]);
        $QUA65mins=60*$dialhh + $dialmm;
        $patoutput.='|$QUA65='.$QUA65mins;
    }
    $patoutput.='|!ENDQUA'."\r";
    //TXT portal for each patient
    include 'incl/gettxtdata_incl.php';
    $patoutput.='!ENDIDN'."\r";
    //$patsql="UPDATE renalreg.$thisqtrpatdata SET output=UPPER('$patoutput'),outputstamp=NOW() WHERE qpatzid=$zid LIMIT 1";
    //$patresult = $mysqli->query($patsql);
    //append to qtroutput
    $qtroutput.=$patoutput;
} //end main pat loop
$qtroutput.="!ENDCNT";
$qtroutputtime=date("D M j G:i:s T Y");
echo "\r---------output for Quarter $qtr generated at $qtroutputtime---------\r\r";
//echo strtoupper($qtroutput);
echo $qtroutput;
$thisoutput=$mysqli->real_escape_string($qtroutput);
$sql="INSERT INTO renalreg.qtr_outputs (qtr,outputdate,outputstamp,output,patcount) VALUES ($qtr,NOW(),NOW(),'$thisoutput',$numrows)";
$result = $mysqli->query($sql);
