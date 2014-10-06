<?php
require '../config_incl.php';
include('../incl/check.php');
$pagetitle= "Add new $siteshort Renalware User";
include "$rwarepath/navs/topsimplenav.php";
//--------Page Content Here----------
include "$rwarepath/navs/usernav.php";
//create default expdate
$expday=date(d);
$expmonth=date(m);
$expyear=date(Y) + 1;
$expdate=$expday . "/" . $expmonth . "/" . $expyear;
?>
<b>Note: For security, administrator ("superuser") privileges cannot be granted through this form.</b><br>
<form class="uiform" action="admin/run/processnewuser.php" method="post">
<fieldset>
	<legend><?php echo $pagetitle; ?></legend>
<ul class="form">
<li><label>user</label>&nbsp;&nbsp;<input type="text" name="user"  size="20" /></li>
<li><label>password</label>&nbsp;&nbsp;<input type="text" name="pass"  size="20" /></li>
<li><label>surname</label>&nbsp;&nbsp;<input type="text" name="userlast"  size="20" /></li>
<li><label>forename(s)</label>&nbsp;&nbsp;<input type="text" name="userfirst"  size="20" /></li>
<li><label>user type</label>&nbsp;&nbsp;<select name="usertype">
	<option>Consultant</option>
	<option>Secretary</option>
	<option>Nurse</option>
	<option>Medical Staff</option>
	<option>IT Staff</option>
	<option>Bed Manager</option>
	<option>Clerk</option>
	<option>Other</option>
	</select></li>
<li><label>email</label>&nbsp;&nbsp;<input type="text" name="email" size="20" /></li>
<li><label>dept</label>&nbsp;&nbsp;<select name="dept">
	<option>Renal</option>
	<option>Liver</option>
	<option>Psychiatry</option>
	<option>Dermatology</option>
	<option>Housekeeping</option></select></li>
<li><label>location</label>&nbsp;&nbsp;<input type="text" name="location"  size="20" /></li>
<li><label>Main Tel</label>&nbsp;&nbsp;<input type="text" name="maintel"  size="20" /></li>
<li><label>Direct Tel</label>&nbsp;&nbsp;<input type="text" name="directtel"  size="20" /></li>
<li><label>mobile</label>&nbsp;&nbsp;<input type="text" name="mobile"  size="20" /></li>
<li><label>fax</label>&nbsp;&nbsp;<input type="text" name="fax"  size="20" /></li>
<li class="hdr">Data for Letters Module</li>
<li><label>inits</label>&nbsp;&nbsp;<input type="text" name="inits"  size="6" /></li>
<li><label>signature</label>&nbsp;&nbsp;<input type="text" name="authorsig"  size="30" /></li>
<li><label>position</label>&nbsp;&nbsp;<input type="text" name="position"  size="30" /></li>
<li class="hdr">Privileges, Pop-Up Menus Configuration &amp; Expiration Date</li>
<li><label>consultant?</label>&nbsp;&nbsp;<input type="checkbox" name="consultantflag"  value="1" /></li>
<li><label>edit?</label>&nbsp;&nbsp;<input type="checkbox" name="editflag"  value="1" /></li>
<li><label>author?</label>&nbsp;&nbsp;<input type="checkbox" name="authorflag"  value="1" checked="checked" /></li>
<li><label>Bed Manager?</label>&nbsp;&nbsp;<input type="checkbox" name="bedmanagerflag"  value="1" /></li>
<li><label>has clinics?</label>&nbsp;&nbsp;<input type="checkbox" name="clinicflag"  value="1" /></li>
<li><label>HD nurse?</label>&nbsp;&nbsp;<input type="checkbox" name="hdnurseflag"  value="1" /></li>
<li><label>View print queue?</label>&nbsp;&nbsp;<input type="checkbox" name="printflag"  value="1" /> <i>For secretaries</i></li>
<li><label>Decrypt sensitive data?</label>&nbsp;&nbsp;<input type="checkbox" name="decryptflag"  value="1" /></li>
</ul>
<?php
if ( $adminflag)
{
	echo '<input type="submit" style="color: green;" value="Add user" />';
}
?>
</fieldset>
</form>
<?php
include '../parts/footer.php';
?>