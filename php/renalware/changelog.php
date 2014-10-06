<?php
ob_start();
$_SESSION['loginerror']=FALSE;
require 'config_incl.php'; //NB includes status and version info
include 'versionnotes.php';
include 'fxns/fxns.php';
$pagetitle="Renalware--Recent Change Log";
include 'parts/head.php';
echo '<div id="kruheaderdiv">
		<p>KING&rsquo;S COLLEGE HOSPITAL RENAL UNIT · <b>RENALWARE</b></p>
</div>';
?>
<h1><?php echo $pagetitle ?></h1>
<h4>V 1.6.1.8</h4>
<ul>
    <li>ESRF: Toggle Problem List option on update form</li>
    <li>RENAL REG: restore ERF04 (EDTA code) to output</li>
</ul>
<h4>V 1.6.1.7</h4>
    <ul>
         <li>CONSULTS: Add consult search form handles non-KCH Nos (BROM, DVH, etc) (#50)</li>
         <li>IMMUNO RX: Signature on form is blank if user is not a registered prescriber (#52)</li>
         <li>MDRD/eGFR: pathol_current nightly script updates only CRE>30 patients (#49)</li>
         <li>RENAL REG/ESRF: update form now includes new PRD (Primary Renal Disease) diagnoses (#44)</li>
    </ul>
<h4>V 1.6.1.6</h4>
    <ul>
         <li>EGFR/MDRD: uniform use of pathology results DB EGFR throughout (#39, #42)</li>
         <li>Tx Inactive Status, Ix Workup types -- option list changes (#41) </li>
    </ul>
<h4>V 1.6.1.4</h4>
    <ul>
         <li>CHANGE: Consult list display enhancements</li>
         <li>CHANGE: Immunosuppr Rx Form fixes and easier Provider updating</li>
    </ul>
<h4>V 1.6.1.2</h4>
    <ul>
         <li>CHANGE: Consult list handling of patients with KCH and non-KCH HospNos (e.g. BROM)</li>
    </ul>
<h4>V 1.6.1.1</h4>
    <ul>
        <li>NEW: Immunosuppressant repeat prescription form handling</li>
        <li>NEW: AKI Consult form entry</li>
        <li>FIX: QuickSearch finds BROM patients (#21)</li>
        <li>NEW: Improved QuickSearch results display</li>
        <li>CHANGE: Consult list redesigns and streamlined Add Consult process</li>
        <li>FIX: Aranesp mcg to IU dose conversion factor (200x)</li>
        <li>FIX: Renal Reg output uses contemporaneous quarter HD session BP data</li>
        <li>CHANGE: Handle "Home Delivery" in meds provider fields</li>
        <li>FIX: Include meds provider data when dose/route is updated</li>
    </ul>
<p><a href="login.php">Log in to Renalware</a></p>

