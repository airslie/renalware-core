<?php
//----Mon 04 Mar 2013----streamlined ----Sat 09 Mar 2013----fixed
//for prompts/stickies
$promptflag=false; //default
$promptmsg=""; //default
include 'incl/promptalgorithm_incl.php';
if ($promptflag) {
	echo '<div id="promptdiv">'.$promptmsg.'</div>';
}
echo '<div class="clear">';
include '../portals/clinstudieshoriz.php';
echo '</div>
<div class="clear">
	<table class="probsmeds"><tr><td>';
include '../portals/problemsportal.php';
echo '</td><td>';
include '../portals/currmedsportal.php';
echo '</td></tr></table>
</div>
<div class="clear">';
$portallimit=10;
include '../portals/lettersportal.php';
echo '</div>
<div class="clear">';
$portallimit=10;
include '../portals/encountersportal.php';
echo '</div>';
