<?php
//----Wed 06 Aug 2014----restore MDRD from pathol_current
//----Mon 04 Aug 2014----EGFR from pathol_current; needs nightly script DEPR
//----Sun 03 Aug 2014----use pathol_current EGFR DEPR
//----Fri 15 Nov 2013----DMY fix for manual date displays
//----Mon 23 Sep 2013----HB to HGB fix; NOW IN get_currpathdata ----Thu 31 Oct 2013----manual display
include realpath($_SERVER['DOCUMENT_ROOT'].'/').'../../tmp/renalwareconn.php';
include 'get_currentpathdata.php';
include 'incl/obxcodelist.php';
//nb $currpatharray from get_currentpathdata.php
function showCurrentdata($currpatharray,$pathfldarray,$obxcodelist)
{
	foreach ($pathfldarray as $key => $pathfld) {
		$pathstamp=$pathfld . 'stamp'; //nb stamp-->date format in get_currpathdata
		$fieldlabel= $obxcodelist[$pathfld];
		$pathresult=$currpatharray["$pathfld"];
		$pathdate=$currpatharray["$pathstamp"];
		//&nbsp; inserted for blank cells
		echo "<tr><td class=\"l\">$fieldlabel</td><td class=\"n\">$pathresult&nbsp;</td><td class=\"i\">".dmy(substr($pathdate,0,10))."&nbsp;</td></tr>\n";
	}
}
//arrange baskets NB HB converted to HGB upstream
$haem=array(
'MCV',
'MCH',
'HYPO',
'RETA',
'WBC',
'LYM',
'NEUT',
'PLT',
'ESRR',
'INR',
'APTR',
'FER',
'FOL',
'B12',
);
echo '<div>
    <table class="datalist">';
//----Thu 31 Oct 2013----show HGB manually
echo "<tr><td class=\"l\">HGB</td><td class=\"n\">$HGB&nbsp;</td><td class=\"i\">".dmy(substr($HGBstamp,0,10))."&nbsp;</td></tr>\n";
showCurrentdata($currpatharray,$haem,$obxcodelist);
echo '</table>';
$biochem1=array(
'URE',
'CRE',
'NA',
'POT',
'BIC',
'CAL',
'CCA',
'PHOS',
'PTHI',
'TP',
'GLO',
'ALB',
'URAT',
'MG',
);
echo '<table class="datalist">';
showCurrentdata($currpatharray,$biochem1,$obxcodelist);
//extras
echo "<tr><td class=\"l\">[CorrCa]x[PO4]:</td><td class=\"n\">$CalPhos</td><td class=\"i\">".dmy(substr($CCAstamp,0,10))."&nbsp;</td></tr>";
echo '</table>';

$biochem2=array(
'BIL',
'ALT',
'AST',
'ALP',
'GGT',
'GLU',
'HBA',
'HBAI',
'CHOL',
'HDL',
'LDL',
'TRIG',
'TSH',
'CK',
'CRP',
'AL',
);
echo '<table class="datalist">';
showCurrentdata($currpatharray,$biochem2,$obxcodelist);
echo '</table>';

$misc1=array(
'ANA',
'DNA',
'C3',
'C4',
'ANCA',
'IGLA',
'IGLG',
'IGLM',
'RF',
'CRP',
'CYA',
'CRYO',
);
echo '<table class="datalist">';
showCurrentdata($currpatharray,$misc1,$obxcodelist);
echo '</table>';

$liver=array(
'BHBC',
'BHBS',
'BHCV',
);
$renal=array(
'URR',
'CCL',
'UPRE',
'UALB',
'UREP',
'ACRA',
'PCRA',
);
echo '<table class="datalist">';
showCurrentdata($currpatharray,$liver,$obxcodelist);
showCurrentdata($currpatharray,$renal,$obxcodelist);
	if ($MDRD) {
		echo "<tr><td class=\"l\">eGFR: MDRD</td><td class=\"n\">$MDRD</td><td class=\"i\">".dmy(substr($CREstamp,0,10))."</td></tr>";
	}
	if ($CG) {
		echo "<tr><td class=\"l\">eGFR: C-G</td><td class=\"n\">$CG</td><td class=\"i\">".dmy(substr($CREstamp,0,10))."</td></tr>";
	}
echo '</table>
</div>';
