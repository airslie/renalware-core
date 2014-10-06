<?php
//----Mon 25 Feb 2013----cannulation
//set mode
$mode="view"; //def
if (isset($_GET['mode'])) {
	//view, edit, update
	$mode=$_GET['mode'];
}
//
$hdprofiledata = array(
't*hdpatzid'=>'hdpatzid',
't*hdaddstamp'=>'added',
't*hdmodifstamp'=>'modified',
's*currsite'=>'curr site',
's*currsched'=>'curr sched',
't*needlesize'=>'needle size',
's*singleneedle'=>'single needle?',
't*hours'=>'hours',
's*dialyser'=>'dialyser',
's*dialysate'=>'dialysate',
's*flowrate'=>'flowrate',
't*dialK'=>'dial K',
't*dialCa'=>'dial Ca',
't*dialTemp'=>'dial Temp',
't*dialBicarb'=>'dial Bicarb',
't*dialNaProfiling'=>'dial Na Profiling',
't*dialNa1sthalf'=>'dial Na 1sthalf',
't*dialNa2ndhalf'=>'dial Na 2ndhalf',
's*anticoagtype'=>'anticoag type',
't*anticoagloaddose'=>'anticoag load dose',
't*anticoaghourlydose'=>'anticoag hourly dose',
't*anticoagstoptime'=>'anticoag stoptime',
's*prescriber'=>'prescriber',
't*prescriptdate'=>'prescript date',
's*esdflag'=>'ESA?',
's*ironflag'=>'Iron?',
's*namednurse'=>'named nurse',
's*warfarinflag'=>'warfarin?',
't*dryweight'=>'dry weight',
't*drywtassessdate'=>'dry wt assess date',
't*drywtassessor'=>'dry wt assessor',
's*currslot'=>'curr slot',
's*prefsite'=>'pref site',
's*prefsched'=>'pref sched',
's*prefslot'=>'pref slot',
't*prefdate'=>'pref date',
't*prefnotes'=>'pref notes',
's*cannulationtype'=>'cannulation',
);
//set option lists
$yn=array('Y','N');
$sched=array('MonWedFri','TueThuSat');
