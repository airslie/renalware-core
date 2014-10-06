<?php
//----Wed 13 Nov 2013----
?>
<div class="btnbar"><button type="button" class="ui-state-default" onclick="$('#lowcleardiv').toggle()">Toggle Low Clear profile</button>&nbsp;&nbsp;<button type="button" class="ui-state-default" style="color: purple;" onclick="$('#updateformdiv').toggle()">Update profile</button>
<a class="ui-state-default" style="color: black;" href="<?php echo $rwareroot ?>/renal/patient_info/printLCCsheet.php?zid=<?php echo $zid ?>" target="new">Print Patient Info (new wndw)</a></div>
<div id="lowcleardiv" style="display: block;" class="clear">
	<?php
	include( 'lowclearprofile.php' );
	?>
</div>
<div class="clear">
	<div class="wrap50pct">
	<?php include('../portals/problemsportal.php'); ?>
	</div>	
	<div class="wrap50pct">
	<?php
	include('../portals/currmedsportal.php');
	?>
	</div>
</div>
<div class="clear">
		<?php
		$portallimit=6;
		include "$rwarepath/pathology/lowclearpatresults_summ.php";
		?>
</div>
<div class="clear">
	<?php
	$portallimit=5;
	include( '../portals/lettersportal.php' );
	?>
</div>
<div class="clear">
	<?php
	$portallimit=5;
	include( '../portals/encountersportal.php' );
	?>
</div>