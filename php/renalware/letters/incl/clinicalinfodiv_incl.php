<?php
//----Fri 15 Nov 2013----simplify KCH results display
//----Fri 01 Nov 2013----restrict letterresults to KRU sites
//updated ----Mon 23 Jul 2012----
?>
<div id="probsmedsdiv">
	<div id="probsdiv">
	<b>Problem List</b><br>
		<?php echo nl2br($lettproblems); ?>
	</div>
	<?php if ($medflag): ?>
	<div id="medsdiv">
	<b><?php echo $medsheader ?></b><br>
		<?php echo nl2br($lettmeds); ?>
	</div>	
	<?php endif ?>
</div><br style="clear: both" />
<div id="allergiesresultsdiv">
	<p><b>ALLERGIES/INTOLERANCE:</b> <?php echo $lettallergies ?><br><br>
	<?php
    //----Fri 15 Nov 2013----only display for KCH lettersite
	if ($lettresults and $lettersite=='KCH')
		{
		echo '<b>Recent Investigations:</b> ' . $lettresults;
		}
	?>
	</p>
<?php
if ( $lettBPsyst and $lettBPdiast )
	{
	echo '<b>BP:</b> ' . $lettBPsyst . '/' . $lettBPdiast . ' &nbsp; &nbsp;';
	}
if ( $lettWeight )
{
echo '<b>Weight: </b>' . $lettWeight  . ' kg &nbsp; &nbsp;';
}
if ( $lettHeight && $lettBMI )
{
echo '<b>Height: </b>' . $lettHeight . ' m &nbsp; &nbsp; <b>BMI: </b>' . $lettBMI . ' &nbsp;&nbsp; ';
}
if ( $letturine_prot or $letturine_blood )
{
echo '<b>Urine Blood: </b>' . $letturine_blood . ' &nbsp; &nbsp; <b>Urine Protein: </b>' . $letturine_prot;
}
?>
</div>