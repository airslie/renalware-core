<?php
//--Sun Nov 24 13:00:14 EST 2013--bs3 version
echo '<div style="padding: 4px; border: 1px solid #ddd; margin-top: 2px;">';
echo "<a href=\"renal/renal.php?zid=$zid&amp;scr=renalsumm\">Renal Summ</a> &nbsp; 
<a href=\"renal/renal.php?zid=$zid&amp;scr=access\">Access</a> $accessCurrent &nbsp; 
<a href=\"renal/renal.php?zid=$zid&amp;scr=esrf\">ESRF</a> $endstagedate &nbsp; 
<a href=\"renal/renal.php?zid=$zid&amp;scr=esa\">ESA</a> $esdregime &nbsp;";
include( '../renal/pd/getworkupdata.php' );
$workupmode = ($workup_id) ? "view" : "create" ;
echo '<a href="renal/pd/workup.php?zid=' . $zid . '&amp;mode='.$workupmode.'">'.$workupmode.' PD Assess</a>';
echo "<br>
<a href=\"renal/renal.php?zid=$zid&amp;scr=lowclear\">Low Clear</a> &nbsp; 
<a href=\"renal/renal.php?zid=$zid&amp;scr=virology\">Virol</a> &nbsp; 
<a href=\"renal/renal.php?zid=$zid&amp;scr=txstatus\">Transpl Status/Ops</a> $txWaitListStatus &nbsp; <b>Rejection Risk</b>: $txRejectionRisk ";
if (substr_count($modalcode, 'Tx')==1) { echo '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txscreenview">Tx Screen</a> &nbsp; '; }
//get immunosupp prn
if ($immunosuppflag==1) { echo '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=immunosupp">Immunosuppr&rsquo;n</a> &nbsp; '; }
if ($hdflag) {
	include '../data/hddata.php';
	echo '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=hdnav">HD profile/sessions</a> &nbsp;' . "<b>$currsite</b> $currsched-$currslot &nbsp;&nbsp;";
	echo '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=homehdnav">Home HD</a>&nbsp;&nbsp;';
	}
//get PD prn
if ($pdflag) { echo '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=pd">PD info</a> &nbsp; <a href="renal/renal.php?zid=' . $zid . '&amp;scr=pdscreenview">PD screen</a> &nbsp; '; }
if ($EDTAtext) { echo "<br><a href=\"renal/renal.php?zid=$zid&amp;scr=esrf\">Renal Dx</a>: $EDTAtext&nbsp;&nbsp;"; }
//$showmrsa = ($mrsaposflag=='Y') ? " POS: $mrsaposdate" : "" ;
$sql = "SELECT swabdate,swabsite FROM mrsadata WHERE mrsazid=$zid AND swabresult='POS' ORDER BY swabdate DESC LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
$showmrsa="";
if ($numrows) {
	$row = $result->fetch_assoc();
	$showmrsa=' POS: '.dmy($row["swabdate"]).'--'.$row["swabsite"];
}
$showadvdirective = ($advancedirsumm) ? "$advancedirsumm ($advancedirdate)" : "None Recorded" ;
echo "<br><a href=\"renal/renal.php?zid=$zid&amp;scr=mrsa\">MRSA</a>$showmrsa&nbsp;&nbsp;<a href=\"renal/renal.php?zid=$zid&amp;scr=advdir_lpa\">Adv Directive/LPA</a> $showadvdirective &nbsp; ";
echo "&nbsp;&nbsp;<a href=\"renal/renal.php?zid=$zid&amp;scr=advrenalcare\">Adv Renal Care</a>&nbsp;&nbsp;";
if ($lupusflag=='Y') {
    echo "&nbsp;&nbsp;<a href=\"renal/renal.php?zid=$zid&amp;scr=lupus\">Lupus</a>&nbsp;&nbsp;";
}
if ($akiflag=='Y') {
    echo "&nbsp;&nbsp;<a href=\"renal/renal.php?zid=$zid&amp;scr=aki\">AKI</a>&nbsp;&nbsp;";
}
echo "&nbsp;&nbsp;<a href=\"pat/form.php?zid=$zid&amp;f=update_transport\">Transport</a> Needs: <b>$transportflag</b> Type: <b>$transporttype</b> Decider: <b>$transportdecider</b> Updated: $transportdate";
echo '</div>';
