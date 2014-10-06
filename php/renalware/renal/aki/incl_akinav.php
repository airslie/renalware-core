<?php
//--Tue Mar  5 11:33:39 EST 2013--
$modeslist = array(
    'view_summ' => 'View AKI Summary',
    'view_episode' => 'View AKI Episode',
    'upd_episode' => 'Update Episode',
 );

echo '<div class="buttonsdiv">';
echo "<button onclick=\"location.href='ls/akilist.php'\">AKI List</button>&nbsp;&nbsp;";

foreach ($modeslist as $mode => $modename) {
	$class = ($thismode==$mode) ? 'class="hilit"' : "" ;
	echo "<button $class onclick=\"location.href='renal/renal.php?zid=$zid&amp;scr=aki&amp;mode=$mode&amp;id=$thisid'\">$modename</button>&nbsp;&nbsp;";
	}
echo '</div>';
