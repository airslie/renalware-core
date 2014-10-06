<?php
//----Mon 15 Oct 2012----streamlining
//Sun Dec 21 11:26:09 SGT 2008
//Tue Sep 15 12:20:29 BRT 2009
//--Fri Jun  8 13:33:14 CEST 2012--
$thistab="index.php";
require '../config_incl.php';
require '../incl/check.php';
$pagetitle="Renal Reg Export System";
include '../parts/head_bs.php';
include 'incl/renalreg_config.php';
include 'incl/rregmaps_incl.php';
include 'incl/navbar_incl.php';
echo '<div id="pagetitlediv">
    <h1><small>'.$pagetitle.'</small></h1></div>';
echo '<h2><small>Important</small></h2>
<p><span class="highlight">Ensure the most recent batch of Renal Registry 
numbers have been imported into the "rregpatlist" table.</span></p>
<h2><small>Instructions</small></h2>
<p>Use the navigation bar above to follow the steps below:</p>
<ol>
<li>Run the "preflight" checks to ensure core data are entered for all ESRF patients*</li>
<li>Select the quarter desired</li>
<li>Check the generated output</li>
<li>If acceptable, save as text file, remove the "header" info, encrypt and send to the Renal Registry</li>
</ol>
<p><small>*Note: not all ESRF patients are exported to the Renal Reg each quarter 
but these data should be entered in any case.</small></p>';
include 'incl/footer_incl.php';
