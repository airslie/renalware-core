<?php
echo '<dl class="dl-horizontal">';
foreach ($showfields as $fld => $label) {
    $val=${$fld};
    if (substr($fld,-4)=='flag') {
        $val = ($val==1) ? 'Y' : $val ;
    }
    echo "<dt>$label</dt><dd>$val</dd>";
}
echo '</dl>';
