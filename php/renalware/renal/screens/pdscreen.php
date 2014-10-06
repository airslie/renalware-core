<?php
include('../data/pddata.php');
//PD view
include( 'pd/pddata_view.php' );
?>
<div class="clear">
	<div class="wrap50pct">
	<?php include('../portals/currmedsportal.php'); ?>
	</div>	
	<div class="wrap50pct">
	<?php
	$portallimit=6;
	include('incl/esahxtable.php');
	?>
	</div>
</div>
<div class="clear">
		<?php
		$portallimit=6;
		include "$rwarepath/pathology/patresults_summ.php";
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
	$portallimit=10;
	include( '../portals/encountersportal.php' );
	?>
</div>
