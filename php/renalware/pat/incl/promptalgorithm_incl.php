<?php
//----Mon 23 Sep 2013----HGB fix
//created on 2009-02-16.
//versionstamp 
if ($HGB && $HGB<10) {
	$promptflag=true;
	$promptmsg.="WARNING: Patient HGB=$HGB ($HGBdate)!\r";
}
if ($PHOS && $PHOS>1.8) {
	$promptflag=TRUE;
	$promptmsg.="WARNING: Patient Phosphate=$PHOS ($PHOSdate)!\r";
}
