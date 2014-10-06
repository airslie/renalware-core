<?php
//--Sun Nov 24 12:49:33 EST 2013--bs3 version
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
echo '<div class="alert alert-info">';
echo "<b>BP:</b> $BPsyst/$BPdiast <i>$BPdate</i>&nbsp;&nbsp;<b>Wt:</b> $Weight kg <i>$Weightdate</i>&nbsp;&nbsp;<b>Ht:</b> $Height m&nbsp;&nbsp;<b>BMI:</b> $BMI&nbsp;
    <b>HGB:</b> $HGB <i>$HGBdmy</i> &nbsp; 
    <b>Creat:</b> $CRE <i>$CREdmy</i> <b>eGFR</b>: $eGFR <i>MDRD</i> <b>Cockr-Glt:</b> $CG <i>$CREdmy</i>&nbsp; 
    <b>Urea:</b> $URE <i>$UREdmy</i> &nbsp; 
    <b>Potass:</b> $POT <i>$POTdmy</i>";
echo '</div>';