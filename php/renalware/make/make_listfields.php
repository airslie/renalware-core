<?php
//----Sat 09 Mar 2013----now uses array
//--Fri Mar  8 10:39:22 EST 2013--
//nb assumes tbl start/end tags
//req $fldmap array and $fldlist "one,two,three,...";
foreach ($showfields as $fld) {
    if (substr($fld,0,1)=='#') {
        echo '<tr><th colspan="2" class="text-error">'.substr($fld,1).'</th></tr>';
    } else {
        $fldlbl=$fldmap[$fld];
        $fldval = (${$fld}) ? ${$fld} : '&nbsp;' ;
        echo "<tr><th>$fldlbl</th><td>$fldval</td></tr>";
    }
}
