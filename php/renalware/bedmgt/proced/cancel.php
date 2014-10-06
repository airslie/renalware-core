<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//get opid
//$pid=$_GET['pid'];
$pzid=(int)$_GET['zid'];
$zid=(int)$_GET['zid'];
//get opdata
$legend="Cancel procedure for $patientref";
$showpriority=strtoupper($priority);
echo "<div class=\"$priority\">$proced -- Priority $showpriority (Status: $status)</div>";
?>
<form action="run/runcancel.php" method="post">
	<fieldset>
		<legend><?php echo $legend ?></legend>
<input type="hidden" name="mode" value="cancel" id="mode" />
<input type="hidden" name="pid" value="<?php echo $pid; ?>" id="pid" />
<input type="hidden" name="pzid" value="<?php echo $pzid; ?>" id="pzid" />
<table>
<tr><td class="fldview">Listed Date</td><td class="data"><?php echo $listeddate; ?> <b>Days on List:</b> <?php echo $daysonlist; ?> <i>days</i></td></tr>
<tr><td class="fldview">Consultant</td><td class="data"><?php echo $consultant; ?>
</td></tr>
<tr><td class="fldview">Surgeon</td><td class="data"><?php echo $surgeon; ?>
</td></tr>
<tr><td class="fldview">Priority</td><td class="data"><?php echo $priority; ?></td></tr>
<tr><td class="fldview">Procedure</td><td class="data"><?php echo $proced; ?>
</td></tr>

<tr><td class="fldview">Management Intent</td><td class="data"><?php echo $mgtintent; ?></td></tr>
<tr><td class="fldview">TCI Date</td><td class="data"><?php echo $tcidate; ?>&nbsp;&nbsp;<b>TCI Time</b><?php echo $tcitime; ?>
</td></tr>
<tr><td class="fldview">Cancellation Date</td><td class="data"><input type="text" name="canceldate" value="<?php echo $todaydmy; ?>" id="canceldate" size="12">
</td></tr>
<tr><td class="fldview">Cancellation Reason</td><td class="data"><textarea  class="form" name="cancelreason" rows="2" cols="60"></textarea></td></tr>
<tr><td class="fldview">Surgery Date</td><td class="data"><?php echo $surgdate; ?>
</td></tr>
<tr><td class="fldview">Surgery Booked by</td><td class="data"><?php echo $booker; ?></td></tr>
<tr><td class="fldview">Schedule Notes</td><td class="data"><textarea  class="form" name="schednotes" rows="7" cols="80"><?php echo $schednotes; ?></textarea></td></tr>
</table>
<input type="submit" name="submit" value="CANCEL Procedure for <?php echo $patient; ?>" id="submit" />
</fieldset>
</form>
<hr />
<form action="index.php" method="get">
<input type="hidden" name="vw" value="pat" id="vw" />
<input type="hidden" name="scr" value="patview" id="scr" />
<input type="hidden" name="zid" value="<?php echo $zid; ?>" id="scr" />
<input type="submit" name="submit" value="ABORT CANCEL -- RETAIN Procedure for <?php echo $patient; ?>" id="submit" /><br>
</form>