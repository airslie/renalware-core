<?php
//----Sat 03 Jul 2010----
$sheettitle="Low Clearance Information Sheet";
include 'incl/infosheethead_incl.php'; //incl header, probs, meds list
?>
<!-- start custom content here -->
<table class="infosheet">
<tr><td>
<?php
 include 'incl/CRE_eGFR_URElist.php';
?>
</td><td>
<b>Kidney Function</b> The function of your kidneys can be assessed in several ways - the commonest is to measure your creatinine level. Creatinine is a normal side product of your body working, and it is the job of the kidneys to filter it out of your blood. If your kidneys can&#x27;t do this, the level of creatinine in your blood rises. The worse your kidney function, the higher your blood creatinine. Urea is another toxin normally removed by healthy kidneys. A high urea (more than 40 mmols/l) can sometimes make you feel very sick. Another measurement is your estimated GFR (eGFR), which is roughly equivalent to your remaining percentage level of normal kidney function. Most people who choose to dialyse need to start this treatment when their kidney function is between 10 and 14% of normal. If your kidney function is less than 20% of normal it is important you have thought about which kind of dialysis you would like to undertake in the future.
</td></tr>
<!-- next section -->
<tr><td>
<?php
include 'incl/bpweightslist.php';
?>
</td><td>
<b>Blood Pressure</b> High blood pressure is common in patients with kidney disease. Uncontrolled high blood pressure can speed up a decline in kidney function, getting you to the point at which you need dialysis sooner. Our target BP in this clinic is 130/80 for all kidney patients and 125/75 for diabetic kidney patients. You can improve your BP by taking your blood pressure tablets, eating less salt and limiting your overall fluid intake (ask your nurse or doctor about this). <b>Target BP is less than 135/80</b>.<br><br>
<b>Weight</b> Obesity is, of course, commonly associated with an increased risk of type 2 diabetes. In addition it is also associated with hypertension and a greater risk of progressive kidney disease. Maintaining or achieving a good body weight is therefore desirable and you should aim to keep your body mass index (BMI) below 30 kg/m2 (<b>ideally 21 - 28</b>).
</td></tr>
<!-- next section -->
<tr><td>
<?php
$thisfield="HBA";
$thislabel="HBA1c";
$showcount=3;
include 'incl/listsingleresult_incl.php';
?>
</td><td>
<b>Diabetic Control</b> If you are diabetic it is important to control your blood sugar, as continued high sugars can also hasten the need for dialysis treatment. Diabetic control is measured by regular sugar testing and by the long term sugar test HbA1C which reflects your sugar control over the last 3-6 weeks. <b>Our target HbA1c is 7% or lower.</b> Improved sugar control can be achieved by eating a low sugar diet, increasing your oral hypoglycaemic tablets or by starting or adjusting insulin. It can also be improved by regular exercise. 
</td></tr>
<!-- next section -->
<tr><td>
<?php
 include 'incl/HbFerrlist.php';
?>
</td><td>
<b>Anaemia</b> Normal kidneys make a hormone called EPO which helps your body make red blood cells. As your kidneys fail, they make less EPO, and if you don nott make enough red cells you become anaemic. This will show in your blood tests by a low haemoglobin count, and is a major reason why many kidney patients feel very tired. In the long run being anaemic is also bad for your heart. We can correct your anaemia, make you feel less tired, and protect your heart, by giving you iron or EPO injections (Eprex, Neorecormin, Mircera or Aranesp). <b>Our target for haemoglobin (Hb) is 10-12 g/dl.</b> If you are either above or below this target, please talk to your doctor or nurse. 
</td></tr>
<!-- next section -->
<tr><td>
<?php
$thisfield="BIC";
$thislabel="Bicarb";
$showcount=3;
include 'incl/listsingleresult_incl.php';
?>
</td><td>
<b>Bicarbonate</b> Healthy kidneys balance the acid in your body by keeping bicarbonate and getting rid of unwanted acid in the urine. As your kidneys function less well, they no longer do this and we need to give you oral bicarbonate tablets instead. Recent evidence has suggested that taking these tablets may help delay the need for dialysis. <b>We aim to keep your bicarbonate levels above 20 mmol/l.</b>
</td></tr>
<!-- next section -->
<tr><td>
<?php
 include 'incl/CaPhosPTHlist.php';
?>
</td><td>
<b>Bone Health</b> Patients with kidney disease can also develop problems with their bones. This is due to the levels of phosphate and calcium in your blood becoming out of balance. Often, phosphate levels rise, which can also make you itchy. Your calcium level may fall, as a result of your kidneys making less vitamin D, which can cause tingling around the mouth and long term will weaken your bones. If your calcium is less than 2 mmol/l we will ask you to take calcium supplements or vitamin D. If your phosphate level is higher than 1.4 mmol/l you may be advised to eat fewer dairy products or to take tablets called phosphate binders (adcal, renagel) in the 15 minutes before you eat (taking them after your meal is too late!). All these tablets are particularly important if you have high levels of PTH (a hormone which increases if you have low vitamin D). 
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
<tr><td colspan="2">
<b>Exercise</b> Regular aerobic exercise produces numerous health benefits including weight control and reduction in body fat, increased muscle mass, improved blood pressure, lower cholesterol and a reduced risk of heart disease. There are also beneficial effects on the interaction between the blood and the lining of blood vessels and these may help to protect the kidneys from future damage.</b>.
</td></tr>
</table>