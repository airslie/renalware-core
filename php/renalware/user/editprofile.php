<?php
//Sun Dec 20 13:15:03 JST 2009
include '../req/confcheckfxns.php';
$pagetitle= "Edit $user&rsquo;s Profile";
include "$rwarepath/navs/topusernav.php";
?>
<p class="alertsmall">If this is your first login please update the following and change your password.</p>
<?php
//--------Page Content Here----------
//get data
$fields = "uid, user, userlast, userfirst,inits, dept, location, adddate, passmodifstamp, email, maintel, directtel, mobile, fax, authorsig, position, modifstamp, authorflag";
$tables = "userdata";
$where = "WHERE uid=$uid";
$sql= "SELECT $fields FROM $tables $where LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>
<form action="user/run/updateprofile.php" method="post">
<input type="hidden" name="uid" value="<?php echo $uid ?>" id="mode" />
<fieldset>
<legend>Edit profile</legend>
<p><a class="ui-state-default" style="color: purple;" href="user/changepw.php">Change Password</a></p>
<p>Please use the <a href="user/changepw.php">password update form</a> to change your password.<br>
<b>Note: only certain fields can be modified.</b> Email <a href="mailto:<?php echo $adminemail; ?>"><?php echo $admin ?></a> if you have queries.</p>
<ul class="form">
<li><label>uid</label>&nbsp;&nbsp;<?php echo $uid; ?></li>
<li><label>user</label>&nbsp;&nbsp;<?php echo $user; ?></li>
<li><label>userlast</label>&nbsp;&nbsp;<?php echo $userlast; ?></li>
<li><label>userfirst</label>&nbsp;&nbsp;<?php echo $userfirst; ?></li>
<li><label>dept</label>&nbsp;&nbsp;<select name="dept">
<option><?php echo $dept; ?></option>
<option>Renal</option>
<option>Liver</option>
<option>Psychiatry</option>
<option>Dermatology</option>
<option>Surgery</option>
<option>Urology</option>
<option>Housekeeping</option></select></li>
<li><label>location</label>&nbsp;&nbsp;<input type="text" name="location" value="<?php echo $location; ?>" size="30" /></li>
<li><label>email</label>&nbsp;&nbsp;<input type="text" name="email" value="<?php echo $email; ?>" size="30" /></li>
<li><label>maintel</label>&nbsp;&nbsp;<input type="text" name="maintel" value="<?php echo $maintel; ?>" size="30" /></li>
<li><label>directtel</label>&nbsp;&nbsp;<input type="text" name="directtel" value="<?php echo $directtel; ?>" size="30" /></li>
<li><label>mobile</label>&nbsp;&nbsp;<input type="text" name="mobile" value="<?php echo $mobile; ?>" size="30" /></li>
<li><label>fax</label>&nbsp;&nbsp;<input type="text" name="fax" value="<?php echo $fax; ?>" size="30" /></li>
<li><label>initials</label>&nbsp;&nbsp;<input type="text" name="inits" value="<?php echo $inits; ?>" size="6" /></li>
<li><label>authorsig</label>&nbsp;&nbsp;<input type="text" name="authorsig" value="<?php echo $authorsig; ?>" size="50" /> <i>Appears in Letters</i></li>
<li><label>position</label>&nbsp;&nbsp;<input type="text" name="position" value="<?php echo $position; ?>" size="50" /> <i>Appears in Letters</i></li>
<li><label>modifstamp</label>&nbsp;&nbsp;<?php echo $modifstamp; ?></li>
</ul>
<input type="submit" style="color: green;" value="Update Details" />&nbsp;&nbsp;<a class="ui-state-default" style="color: red;" href="user/userhome.php">Cancel</a>
</fieldset>
</form>
<?php
include '../parts/footer.php';
?>