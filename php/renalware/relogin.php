<?php
ob_start();
require 'config_incl.php';
include "$rwarepath/fxns/fxns.php";
$pagetitle="Login to Renalware SQL";
include 'parts/head.php';
//need this as no check.php yet
if ($_SESSION['loginerror']) {
	echo '<div class="upgradealert">'.$_SESSION['loginerror'].'</div>';
//	$_SESSION['loginerror']=FALSE;
	session_unset(); 
	session_destroy();
	}
?>
<form action="run/runlogin.php" method="post">
<fieldset>
<legend>Log In -- Please Try Again</legend>
    <p class="alertsmall">If you cannot login for some reason please contact <?php echo $admin; ?> at <?php echo $adminemail ?>.</p>
    <ul>
    <li><label for="user">Username</label>&nbsp;<input type="text" id="user" name="user" size="20" autocomplete="off" />&nbsp;&nbsp;&nbsp;<label for="pass">Password</label>&nbsp;<input type="password" id="pass" name="pass" size="10" autocomplete="off" /></li>
    <li class="submit"><input type="submit" style="color: green;" value="Log in now" /></li>
</fieldset>
</form>
<?php
//special footer
ob_end_flush();
?>