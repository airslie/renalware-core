<?php
//----Mon 23 Sep 2013----HGB fix
//----Mon 25 Feb 2013----cannulation
//--Mon Nov  5 15:05:48 CET 2012--streamlined and PLT added
//----Tue 06 Nov 2012----HB date
$HGB=10*$HB;
$HGBdate=dmy(substr($HBstamp,0,10));
echo "<h3> $firstnames ". strtoupper($lastname) . "($hospno1): HD Profile on " . date('D d M Y') ."</h3>
<span class=\"profile\"><b>Created:</b> $hdaddstamp <b>Updated:</b> $hdmodifstamp<br>
<b>site:</b> $currsite &nbsp; &nbsp;
<b>schedule:</b> $currsched-$currslot &nbsp; &nbsp;
<b>current access:</b> $accessCurrent (<b>formed:</b> $accessCurrDate)&nbsp;&nbsp;
<b>Named Nurse:</b> $namednurse &nbsp; &nbsp;<b>hours:</b> $hours<br>
<b>Needle:</b> &nbsp;<b>Size</b>: $needlesize &nbsp; &nbsp; <b>Single</b>? $singleneedle &nbsp; &nbsp; &nbsp; <b>Sodium Profiling</b> $dialNaProfiling
&nbsp; &nbsp; <b>Na 1st half</b>: $dialNa1sthalf
&nbsp; &nbsp; <b>Na 2nd half</b>: $dialNa2ndhalf
<br>
<b>Additional Rx:</b> <b>ESA</b>: $esdflag &nbsp; &nbsp;
<b>Iron</b>: $ironflag &nbsp; &nbsp;
<b>Warfarin</b>: $warfarinflag &nbsp; &nbsp; &nbsp; <b>Dry Weight:</b> $dryweight <i>kg</i> &nbsp; &nbsp;
<b>Date</b>: $drywtassessdate &nbsp; &nbsp;
<b>Assessor</b>: $drywtassessor<br>
<b>Dialyser: </b> $dialyser &nbsp; &nbsp; <b>dialysate</b>: $dialysate
&nbsp; &nbsp; <b>flowrate</b>: $flowrate
 &nbsp; &nbsp; <b>K</b>: $dialK
&nbsp; &nbsp; <b>Ca</b>: $dialCa
&nbsp; &nbsp; <b>Temp</b>: $dialTemp
&nbsp; &nbsp; <b>Bicarb</b>: $dialBicarb
<br>
<b>Anticoagulant: </b> <b>Type</b>: $anticoagtype
&nbsp; &nbsp; <b>Loading Dose</b>: $anticoagloaddose &nbsp; &nbsp; <b>Hourly Dose</b>: $anticoaghourlydose &nbsp; &nbsp; <b>Stop Time</b>: $anticoagstoptime &nbsp; &nbsp;
<b>Prescriber</b>: $prescriber &nbsp; &nbsp; <b>Date</b>: $prescriptdate<br>
<b>Transport: </b> <b>Needs</b>: $transport &nbsp; &nbsp;  <b>Type</b>: $transporttype &nbsp; &nbsp; <b>Decider</b>: $transportdecider &nbsp; &nbsp; <b>Date</b>: $transportdate &nbsp;&nbsp;
<b>Prefs:</b> <i>Site:</i> $prefsite &nbsp; &nbsp;<i>schedule:</i> $prefsched-$prefslot&nbsp;&nbsp;<i>Prefs dated:</i> $prefdate <b>Latest HGB</b>: $HGB <i>($HGBdate)</i> <b>Platelets:</b> $PLT<br>
<i>Pref Notes:</i> $prefnotes<br>
<b>Cannulation Technique</b>: $cannulationtype
</span>";
