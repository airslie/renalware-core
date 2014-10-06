<?php
//----Sat 03 Jul 2010----
$sheettitle="Nephrology Information Sheet";
include 'incl/infosheethead_incl.php'; //incl header, probs, meds list
?>
<!-- start custom content here -->
<h2>Nephrology Information Sheet</h2>
<table class="infosheet">
<tr><td>
<?php
//get portal
include 'incl/CRE_eGFR_Klist.php';
?>
</td><td>
<b>Kidney Function</b> The function of the kidneys can be assessed in a number of ways but the commonest is to measure the level of <b>creatinine</b> in the blood (the higher the creatinine the worse the kidney function). Estimated glomerular filtration rate (<b>eGFR</b>) is then calculated to give a value which is equivalent to an approximate percentage of normal kidney function. <b>Reduced eGFR</b> is compatible with normal health and the aim of good management of kidney disease is to prevent or slow down a fall in eGFR.
</td></tr>
<!-- next section -->
<tr><td>
<?php
include 'incl/bpweightslist.php';
?>
</td><td>
<b>Blood Pressure</b> High blood pressure (BP - called hypertension) is very common in patients with kidney disease and may also cause kidney disease. It also increases the risk of strokes, heart attacks and vascular disease affecting the legs. Most patients with hypertension require medication to reduce the BP although life style factors influence both the development of high BP and its control. A healthy diet, particularly avoiding salt, regular exercise and maintaining or achieving a healthy weight all reduce blood pressure. Various types of medication are used to treat hypertension and many patients require a combination of different types to control their blood pressure. There is very good evidence that two related classes of antihypertensives are particularly good at protecting the kidneys from hypertension in diabetics and also reducing the future risk of heart attacks and strokes - these are the angiotensin converting enzyme (ACE) inhibitors (name ends in -pril e.g. ramipril) and the angiotensin receptor blockers (ARB name ends in -artan e.g. irbesartan). Diabetic patients should be on one of these agents unless there is a contrindication to their use. <b>Target BP is less than 135/80</b>.<br><br>
<b>Weight</b> Obesity is, of course, commonly associated with an increased risk of type 2 diabetes. In addition it is also associated with hypertension and a greater risk of progressive kidney disease.  Maintaining or achieving a good body weight is therefore desirable and you should aim to keep your body mass index (BMI) below 30 kg/m2 (<b>ideally 21 - 28</b>).
</td></tr>
<!-- next section -->
<tr><td>
	<?php
	$thisfield="CHOL";
	$thislabel="Chol";
	$showcount=3;
	include 'incl/listsingleresult_incl.php';
	?>
</td><td>
<b>Cholesterol</b> High cholesterol is very common in diabetes, particularly when kidney disease is also present. Although a healthy diet and regular exercise can improve cholesterol (lowering LDL cholesterol, the bad sort, and raising HDL cholesterol, the good sort), this effect is usually fairly limited and many patients require medication to reduce cholesterol to a satisfactory level. The statins (e.g. simvastatin) are very widely used to lower cholesterol and reduce the risk of heart attacks and strokes very significantly. <b>The target cholesterol is less than 5.0 mmol/L</b>.
</td></tr>
<!-- next section -->
<tr><td>
	<?php
	$thisfield="PCRA";
	$thislabel="PCR";
	$showcount=3;
	include 'incl/listsingleresult_incl.php';
	?>
</td><td>
<b>Urinary protein</b> Raised protein in the urine is very common in kidney disease and, in some cases, the higher the protein the more likely the kidney function is to get worse in the future. Urinary protein can be measured in a number of ways but the easiest is the protein creatinine ratio (abbreviated PCR) done on a single sample of urine. Normal value is less than 15 mg/mmol. The amount of protein in the urine can be reduced by good blood pressure control particularly if certain types of blood pressure tablets are used (ACE inhibitors or angiotensin receptor blockers). Losing weight if you are overweight may also help. <b>The target PCR is less than 15</b>.
</td></tr>
</table>
<!-- next section -->
<p><b>Exercise</b> Regular aerobic exercise produces numerous health benefits including weight control and reduction in body fat, increased muscle mass, improved blood pressure, lower cholesterol and a reduced risk of heart disease. There are also beneficial effects on the interaction between the blood and the lining of blood vessels and these may help to protect the kidneys from future damage.</p>