<?php
//----Wed 06 Aug 2014----fix to use pathol_current MDRD
//----Sun 03 Aug 2014----use pathol_results EGFR -- DEPR
//----Mon 23 Sep 2013---- HGB fix
$sql = "SELECT * FROM hl7data.pathol_current WHERE currentpid='$hospno1' LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
$row = $result->fetch_assoc();
	//will need reordering
	foreach($row AS $key => $value)
		{ //parse $rows
		${$key} = $value;
		if (substr($key,-5)=="stamp")
			{
			${$key} = dmy(substr($value,0,10));
			}
		}
//sigh... for "specials"
if ($HB) {
    $HGB=10*$HB; //HGB fix
}
if ( $CHOL )
	{
	$showCHOL= "$CHOLstamp: Chol $CHOL;";
}
if ( $HBA )
	{
//		$showHBA= "$HBAstamp: HBA $HBA;"; //----Thu 01 Jul 2010----needs checking
	$showHBA= "$HBAstamp: HbA1c $HBA;";
}
if ( $FER )
	{
	$showFER= "$FERstamp: Ferr $FER;";
}
if ( $BGLU )
	{
	$showGLU= "$BGLUstamp: Gluc $BGLU;";
}
if ( $MDRD )
	{
	$showMDRD= "(eGFR-MDRD $MDRD)";
}
$current_lettresults= "$HBstamp: HGB $HGB, Plt $PLT, WBC $WBC; $UREstamp: Urea $URE; $CREstamp: Creat $CRE $showMDRD, K $POT, Na $NA; $BICstamp: Bicarb $BIC; $CCAstamp: Correct Ca $CCA, Phos $PHOS, Alb $ALB; $BILstamp: Bili $BIL, AST $AST, GGT $GGT, AlkPhos $ALP; $PTHIstamp PTH $PTHI; $showCHOL $showFER; $showGLU; $showHBA";
