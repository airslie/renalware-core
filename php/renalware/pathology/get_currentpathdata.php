<?php
//----Wed 06 Aug 2014----uses correct MDRD column
//----Sun 03 Aug 2014----now uses pathol_results EGFR column rather than calculation below DEPR
//----Mon 23 Sep 2013----add HGB to array here
//----Mon 10 Dec 2012----if numrows now
//----Mon 05 Nov 2012----
//nb age, sex, Wt come from patientdata uppage
$sql = "SELECT * FROM hl7data.pathol_current WHERE currentpid='$hospno1' LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$currpatharray = $result->fetch_assoc();
	foreach($currpatharray AS $key => $value)
		{ //parse $rows
		    ${$key} = $value;
        }
	//for obsolete XYZdate refs
	//Ca*Phos
	$CalPhos="";
	if ($CCA && $PHOS)
		{
		$CalPhos = number_format($CCA*$PHOS,2);
		}
	//C-G
	if ($CRE && $Weight)
		{
		$cgx = ($sex=='F') ? 1.04 : 1.23 ;
		$CG=($cgx*(140-$age)*$Weight)/$CRE;
		$CG=round($CG,0);
		}
    if ($HB) {
        //----Mon 23 Sep 2013----HGB fix
        $HGB=10*$HB;
        $HGBstamp=$HBstamp;
    }
}
