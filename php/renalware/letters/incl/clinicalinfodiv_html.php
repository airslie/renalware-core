<?php
//----Fri 01 Nov 2013----restrict letterresults to KRU sites
//updated Thu Sep  3 16:34:42 CEST 2009 for HTML
$html.= '<div id="probsmedsdiv">
	<div id="probsdiv">
	<b>Problem List</b><br>';
		$html.= nl2br($lettproblems);
$html.= '</div>';
if ($medflag) {
	$html.='<div id="medsdiv">
	<b>'.$medsheader.'</b><br>'.nl2br($lettmeds).'</div>';
}
$html.='</div><br style="clear: both" />
<div id="allergiesresultsdiv">
	<p><b>ALLERGIES/INTOLERANCE:</b>'.$lettallergies .'<br><br>';
	if ($lettresults and $lettersite=='KCH')
		{
		$html.= '<b>Recent Investigations:</b> ' . $lettresults;
		}
$html.='</p>';
if ( $lettBPsyst && $lettBPdiast )
	{
	$html.= '<b>BP:</b> ' . $lettBPsyst . '/' . $lettBPdiast . ' &nbsp; &nbsp;';
	}
if ( $lettWeight )
{
$html.= '<b>Weight: </b>' . $lettWeight  . ' kg &nbsp; &nbsp;';
}
if ( $lettHeight && $lettBMI )
{
$html.= '<b>Height: </b>' . $lettHeight . ' m &nbsp; &nbsp; <b>BMI: </b>' . $lettBMI  . ' &nbsp; &nbsp;';
}
if ( $letturine_prot or $letturine_blood )
{
$html.= '<b>Urine Blood: </b>' . $letturine_blood . ' &nbsp; &nbsp; <b>Urine Protein: </b>' . $letturine_prot;
}
$html.='</div>';
