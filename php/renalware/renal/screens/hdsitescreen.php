<?php
//---------------Sun Apr 18 17:32:34 CEST 2010---------------
include "$rwarepath/data/hddata.php";
include('hd/hdstatusbar_incl.php');
?>	
<input type="button" class="ui-state-default" style="color: green;" value="Toggle Full HD Profile" onclick="javascript:toggl('hdprofilediv');"/>
<div id="hdprofilediv" style="display: none">
	<?php
	//nb requires hddata.php above
	include('hd/hdprofile_incl.php');
	?>	
</div>
<table border="0">
<td valign="top" width="50%">
<?php include('../portals/currmedsportal.php'); ?>
</td><td valign="top" width="50%">
<?php include('incl/esahxtable.php'); ?>
</td></tr></table>
<?php
$portallimit=12;
include "$rwarepath/pathology/patresults_summ.php";
?>
<input type="button" class="ui-state-default" style="color: green;" value="Toggle Recent Letters" onclick="javascript:toggl('lettersdiv');"/>
<div id="lettersdiv" style="display: none">
	<?php
	$portallimit=6;
	include( '../portals/lettersportal.php' );
	?>	
</div>
<?php
$sesslimit=6;
include('hd/sessions_incl.php');
?>