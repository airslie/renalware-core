<?php
//----Wed 06 Aug 2014----restore pathol_current $MDRD display
//----Mon 23 Sep 2013----now displays HGB fix
//Wed Oct 22 16:37:15 IST 2008
include "$rwarepath/pathology/get_currentpathdata.php";
$pathfields=array(
'HGBdmy'=>"$HGBstamp",
'CREdmy'=>"$CREstamp",
'UREdmy'=>"$UREstamp",
'POTdmy'=>"$POTstamp",
);
foreach($pathfields AS $key => $value)
	{
	${$key} = dmy(substr($value,0,10));
	}
echo '<div id="clinpathdiv" class="ui-state-default">';
echo "<b>BP:</b> $BPsyst/$BPdiast <i>$BPdate</i>&nbsp;&nbsp;<b>Wt:</b> $Weight kg <i>$Weightdate</i>&nbsp;&nbsp;<b>Ht:</b> $Height m&nbsp;&nbsp;<b>BMI:</b> $BMI&nbsp;
    <b>HGB:</b> $HGB <i>$HGBdmy</i> &nbsp; 
    <b>Creat:</b> $CRE <i>$CREdmy</i> <b>eGFR</b>: $MDRD <i>MDRD</i> <b>Cockr-Glt:</b> $CG <i>$CREdmy</i>&nbsp; 
    <b>Urea:</b> $URE <i>$UREdmy</i> &nbsp; 
    <b>Potass:</b> $POT <i>$POTdmy</i>";
echo '</div>';