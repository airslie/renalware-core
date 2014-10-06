<?php
//----Sun 08 Dec 2013----
$showfieldsrow1=array(
	'currBP' => 'BP',
	'Weight' => 'Weight',
	'BMI' => 'BMI',
    'endstagedate' => 'ESRF date',
    'EDTAtext' => 'ESRF cause',
	);
?>
<div class="ui-state-default datadiv" >
<?php
	foreach ($showfieldsrow1 as $key => $value) {
		echo "<b>$value</b> ${$key} &nbsp;&nbsp;";
	}
echo "<br><b>Current Tx Wait List Status</b> $txWaitListStatus";
//----Thu 04 Aug 2011----
if ($mrsaflag) {
	echo "<br><b>Last MRSA</b> $mrsadate <b>Swab site</b> $mrsasite <b>Positive?</b> $mrsaflag";
}
?>
</div>
<div class="clear">
	<?php
	include( 'portals/txopsportal.php' )
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
    	$portallimit=10;
    	include('../portals/midasfeedportal.php');
		?>
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
	$portallimit=5;
	include( '../portals/encountersportal.php' );
	?>
</div>