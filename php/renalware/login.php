<?php
ob_start();
$_SESSION['loginerror']=FALSE;
require 'config_incl.php'; //NB includes status and version info
include 'versionnotes.php';
include 'fxns/fxns.php';
$pagetitle="Login to Renalware";
include 'parts/head.php';
echo '<div id="kruheaderdiv">
		<p>KING&rsquo;S COLLEGE HOSPITAL RENAL UNIT · <b>RENALWARE</b></p>
</div>';
echo '<div id="logindiv">';
if ($_SESSION['loginerror']) {
	echo '<div class="upgradealert">'.$_SESSION['loginerror'].'</div>';
	session_unset(); 
	session_destroy();
	}
?>
<form class="uiform" action="run/runlogin.php" method="post">
    <fieldset>
        <legend>Log in to Renalware</legend>
        <p style="background: yellow; border: thin solid red; padding: 3px;">NOTICE: This system contains patient clinical records. All information is highly confidential and must be treated as such.<br>
        All data must be used with the Data Protection Act and related legislation and in compliance with security policies governing use of this system.<br>
        Unauthorised, illegal or improper use may result in disciplinary action and civil or criminal prosecution.<br>
        By continuing to access this system you agree that such access and use is subject to the foregoing.</p>
        <p>If you cannot login for some reason please contact <?php echo $admin; ?> at <?php echo $adminemail ?>.</p>
        <?php
        if ($configstatus != 'LIVE') {
        	makeError("WARNING","This is the $configstatus version! ($vno)");
        }
        ?>
        <ul class="form">
            <li><label>Username</label>&nbsp;<input type="text" id="userinput" name="user" size="20" autocomplete="off" autofocus /></li>
<li><label>Password</label>&nbsp;<input type="password" id="pass" name="pass" size="20" autocomplete="off" />&nbsp;&nbsp;<input type="submit" style="color: green;"  value="Log in now" /></li>
     </ul>
    </fieldset>
</form>
<script type="text/javascript">
	$('#userinput').focus()
</script>
<div id="versiondiv">
<h3>Recent Enhancements &amp; Fixes</h3>
<!--start recent changes/fixes -->
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
<!--end recent changes/fixes -->
        <a href="changelog.php">View complete change log</a>
    </div>
</div> 
<?php
//special footer
ob_end_flush();
include 'parts/footer_login.php';
?>