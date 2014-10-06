<?php
$divid="allergiesdiv";
if (strtoupper($clinAllergies) =="NIL KNOWN" or strtoupper($clinAllergies) =="NONE") {
	$divid="allergiesnonediv";
}
?>
<div id="<?php echo $divid ?>" class="ui-state-default">
<a onclick="location.href='renal/renal.php?zid=<?php echo $zid; ?>&amp;vw=renalsumm'">edit</a>&nbsp;&nbsp;<b>Allergies/Intolerance:</b>&nbsp; <?php echo $clinAllergies; ?>
</div>
<?php if ($alert): ?>
<div id="showalertdiv">
<b>ALERT:</b>&nbsp;&nbsp;<?php echo $alert ?> <a style="color: #333; font-size: .7em;"  onclick='$("#editalert").toggle();'>edit</a>&nbsp;&nbsp;<a class="ui-state-default" style="color: red; font-size: .7em;"  href="<?php echo $thisurl ?>&amp;mode=deletealert">delete</a></div>
<?php endif ?>