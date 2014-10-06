<?php
//----Mon 25 Feb 2013----cannulation
//----Sun 28 Oct 2012----streamlining
//----Wed 23 Jun 2010----
//for outcome colouring
$bgcolours=array(
	'Green'=>'green',
	'Amber'=>'orange',
	'Red'=>'red',
	);
$outcomebg=$bgcolours["$accessAssessOutcome"];
echo "<p class=\"header\">HD Profile (Created: $hdaddstamp Updated: $hdmodifstamp)</p>
<ul class=\"portal\">
<li><b>Site:</b> $currsite <b>Pref:</b> $prefsite&nbsp;&nbsp;<b>Schedule:</b> $currsched-$currslot <i>Pref: $prefsched-$prefslot</i>&nbsp;&nbsp;
<b>Named Nurse:</b> $namednurse&nbsp;&nbsp;<b>hours:</b> $hours&nbsp; &nbsp;<b>Type:</b> $hdtype</li>
<li><b>Pref Notes:</b> $prefnotes</li>
<li><b>Current access:</b> $accessCurrent (<b>formed:</b> $accessCurrDate)&nbsp;&nbsp;<b>Access Plan:</b> $accessPlan ($accessPlanner -- $accessPlandate)</li>
<li><b>Needle:</b> &nbsp;&nbsp;<b>Size:</b>  $needlesize&nbsp;&nbsp;<b>Single</b>? $singleneedle&nbsp;&nbsp;<b>Sodium Profiling</b> $dialNaProfiling&nbsp;&nbsp; <b>Na 1st half:</b>  $dialNa1sthalf&nbsp;&nbsp;<b>Na 2nd half:</b>  $dialNa2ndhalf</li>
<li><b>Additional Rx:</b> <b>ESD/Epo:</b>  $esdflag&nbsp;&nbsp;<b>Iron:</b>  $ironflag&nbsp;&nbsp;<b>Warfarin:</b>  $warfarinflag&nbsp;&nbsp;<b>Dry Weight:</b> $dryweight <i>kg</i>&nbsp;&nbsp;<b>Date:</b>  $drywtassessdate&nbsp;&nbsp;<b>Assessor:</b>  $drywtassessor</li>
<li><b>Dialyser:</b> $dialyser&nbsp;&nbsp;<b>dialysate:</b>  $dialysate
&nbsp;&nbsp;<b>flowrate:</b>  $flowrate
&nbsp;&nbsp;<b>K:</b>  $dialK
&nbsp;&nbsp;<b>Ca:</b>  $dialCa
&nbsp;&nbsp;<b>Temp:</b>  $dialTemp
&nbsp;&nbsp;<b>Bicarb:</b>  $dialBicarb</li>
<li><b>Anticoagulant:</b> <b>Type:</b>  $anticoagtype&nbsp;&nbsp;<b>Loading Dose:</b>  $anticoagloaddose &nbsp;&nbsp;<b>Hourly Dose:</b>  $anticoaghourlydose &nbsp;&nbsp;<b>Stop time:</b>  $anticoagstoptime&nbsp;&nbsp;
<b>Prescriber:</b>  $prescriber&nbsp;&nbsp;<b>Date:</b>  $prescriptdate</li>
<li><b>Transport: </b> See renal navbar above&nbsp;&nbsp;<b>Cannulation Technique</b>: $cannulationtype</li>
<li><b>BP Statistics: </b>  BP max PRE: $maxsyst_pre/$maxdiast_pre&nbsp;&nbsp; max POST: $maxsyst_post/$maxdiast_post&nbsp;&nbsp;BP min PRE: $minsyst_pre/$mindiast_pre&nbsp;&nbsp; min POST: $minsyst_post/$mindiast_post&nbsp;&nbsp;<b>BP avg PRE: $avgsyst_pre/$avgdiast_pre&nbsp;&nbsp; avg POST: $avgsyst_post/$avgdiast_post</li>
<li><b>Access Surveillance Date:</b> $accessLastAssessdate &nbsp;&nbsp;<b>Outcome: </b> <span style=\"color: $outcomebg\"> $accessAssessOutcome</span></li>
</ul>";
