<?php
include '../req/confcheckfxns.php';
require '../config_incl.php';
$pagetitle= "Change $user&rsquo;s password";
include '../navs/topnonav.php';
if ($_GET['mode']=="run") {
	include '../run/runchangepw.php';
}
?>

<?php if ($get_alert=="newpw"): ?>
	<p class="alert">Your password has expired. Please create a new one below.</p>
<?php else: ?>
		<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p>
<?php endif ?>
<form action="user/changepw.php?mode=run" method="post">
	<input type="hidden" name="uid" value="<?php echo $uid ?>" id="uid">
<fieldset>
<legend>Change User Password</legend>
<ul class="form">
<li>Use only letters and numbers</li>
<li>Your password should be between 6 and 20 characters long</li>
<li>It should contain at least one numeric character (0-9)</li>
	<li><label>enter new password</label>&nbsp;&nbsp;<input type="password" name="password1" size="20" /></span></li>
	<li><label>confirm (retype)</label>&nbsp;&nbsp;<input type="password" name="password2" size="20" /></span></li>

<li class="submit"><input type="submit" style="color: green;" value="Change Password" />
</li>
</ul></fieldset>
</form>
<?php
include '../parts/footer.php';
?>