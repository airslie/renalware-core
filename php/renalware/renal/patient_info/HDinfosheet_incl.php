<?php
//----Fri 27 Sep 2013----HGB fix and updated info
//----Sat 03 Jul 2010----
$sheettitle="Haemodialysis Patient Information Sheet";
$sheetdate= date('D d M Y');
echo '<p style="background: #ddd; color: black; font-size: 10pt; padding: 2px">';
echo "<b>King&rsquo;s Renal Unit</b>&nbsp;&nbsp;$sheettitle (printed $sheetdate)</p>
	<h1>$pat_ref<br>$pat_addr</h1>
	<p><b>GP:</b> $gpref</p>";
?>
<table class="infosheet">
	<tr><th width="50%">Recent Results &amp; BP</th><th width="50%">Current Medications</th></tr>
	<tr><td><?php
	include 'incl/pat_pathresultsportal.php';
	?><br>
	<p><b>Chol</b>: <?php echo $CHOL . ' <i>(' . unstamp($CHOLstamp) . ')</i>'; ?><br>
	<b>PTH</b>: <?php echo $PTHI . ' <i>(' . unstamp($PTHIstamp) . ')</i>'; ?><br>
	<b>URR</b>: <?php echo $URR; ?><br>
	<b>Blood Pressure</b>:<br>
	Average pre-dialysis BP:  <?php echo $avgsyst_pre . '/' . $avgdiast_pre; ?><br>
	Average post-dialysis BP: <?php echo $avgsyst_post . '/' . $avgdiast_post; ?><br>
	<b>Transplant Waiting List Status</b>:<br>
	<?php echo $txWaitListStatus; ?></p>
</td><td>
<?php
echo nl2br($medlist);
?>
<p style="font-size: 8pt; font-style: italic;"><b>od</b>=once daily; <b>bd</b>=twice daily; <b>tid</b>=3 times daily; <b>qds</b>=4 times daily; <b>PO</b>=by mouth; <b>mane</b>=in the morning; <b>nocte</b>=at night; <b>prn</b>=as required</p>
</td></tr>
</table>
<!-- start custom content here -->
<h2>Guide to Renal Investigations and what they mean for your care</h2>
<p><b>Haemoglobin</b> (HGB, formerly referred to as Hb): Anaemia (or low HGB) is very common in patients with kidney disease due to failure of production of erythropoietin (EPO&mdash;a hormone produced by the kidneys). Anaemia is associated with a reduction in overall health, heart damage and an increased risk of death. Most patients with severe kidney failure will be treated with EPO (NeoRecormon, Eprex, Binocrit or Aranesp). It is very important to have your EPO regularly to keep your heart healthy. The ideal HGB is between 105 and 125 g/L.</p>

<p><b>Dialysis Efficiency</b> (Urea, URR): For a patient on either haemodialysis or peritoneal dialysis, the amount of dialysis provided plus any remaining kidney function is very important. Below a certain amount of dialysis, patients are more likely to develop complications and have a shorter life. In haemodialysis, dialysis efficiency is measured using the pre dialysis urea and the <b>Urea Reduction Ratio</b> (URR - this is the percentage of toxins removed during a dialysis session). Predialysis urea should be below 25 mmol/l and the URR greater than 64%. </p>

<p><b>Calcium</b>, <b>Phosphate</b> and <b>PTH</b>: Low calcium (Ca), high phosphate (Phos) and high parathormone (PTH) are common in kidney disease. If uncontrolled, this can lead to progressive weakening of the bones. A raised Phos, particularly when combined with a high Ca, is associated with Ca deposits in blood vessels increasing the risk of heart attacks and strokes. Phos is controlled with diet and tablets to reduce Phos absorption from food. The ideal values are Ca 2.20-2.40 mmol/L, Phos 0.8-1.8 mmol/L and PTH 150-350 picograms/L. </p>

<p><b>Potassium</b> (Potass) is commonly retained in kidney failure. A rapid rise in K can be dangerous. For this reason patients who have a high K will receive advice on reducing high K foods in their diet. The normal range for K is 3.5-5 mmol/L but we are happy if it is below 6.0 mmol/L before dialysis. </p>

<p><b>Cholesterol</b>: Patients with kidney failure are prone to a raised cholesterol which can lead to heart attacks and strokes. Cholesterol can be lowered by diet but many patients require tablets. Ideally cholesterol should be less than 5.0 mmol/L. </p>

<p><b>Blood Pressure</b>: High blood pressure is associated with an increased risk of heart disease and strokes. Raised blood pressure is very common in patients on dialysis and is controlled by a combination of limiting fluid and salt intake, good and frequent dialysis and, often, medication. Ideally blood pressure should be less than 140/90 before haemodialysis and less than 130/80 after dialysis.</p>