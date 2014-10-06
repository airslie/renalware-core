<?php
//
$printurl=$_SERVER['PHP_SELF']."?".$_SERVER['QUERY_STRING']."&amp;print=y"
?>
<div class="menubar">
<small>
<a href="javascript:history.go(-1);">Cancel (Return to previous page)</a>&nbsp;&nbsp;
<a href="pat/patient.php?zid=<?php echo $zid ?>&amp;vw=clinsumm"><?php echo $title . ' '. $lastname ?>&rsquo;s Clinical Summary</a>&nbsp;&nbsp;
<a href="pat/renal.php?zid=<?php echo $zid ?>&amp;scr=clinsumm">Renal Summary</a>&nbsp;&nbsp;
</small>
</div>