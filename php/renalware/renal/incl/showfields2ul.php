<?php
//----Fri 25 Feb 2011----
echo '<ul class="dataportal">';
foreach ($showfields as $key => $value) {
	list($specs,$label)=explode("^",$value);
	if ($specs=="0") {
		echo '<li class="header">'.$label.'</li>';
	} else {
		echo '<li><b>'.$label.'</b>&nbsp;&nbsp;'.$$key."</li>";
	}
}
echo '</ul>';
?>
