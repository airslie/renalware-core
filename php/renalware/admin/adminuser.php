<?php
//Sun Oct  4 19:09:45 BST 2009
require '../config_incl.php';
include '../incl/check.php';
include '../fxns/fxns.php';
include '../fxns/formfxns.php';
//separate header w/ form css
//include '../parts/head.php';
$edituid=$get_edituid;
//only admin users
$enableadmin = ($adminflag) ? TRUE : FALSE ;
//get data
//$fields = "uid, user, userlast, userfirst,inits, dept, location, adddate, passmodifstamp, email, maintel, directtel, mobile, fax, authorsig, position, modifstamp, authorflag";
$tables = "userdata";
$where = "WHERE uid=$edituid";
$sql= "SELECT * FROM $tables $where LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
$pagetitle= "Edit User $user: $userfirst $userlast (UID $uid)";
include "$rwarepath/navs/topsimplenav.php";
//--------Page Content Here----------
include "$rwarepath/navs/usernav.php";
?>
<?php if ($enableadmin): ?>
	
<b>Note: For security, administrator ("superuser") privileges cannot be granted through this form.</b><br>
<form action="admin/run/run_adminuser.php" method="post">
	<input type="hidden" name="uid" value="<?php echo $uid ?>" id="uid" />
<fieldset>
	<legend><?php echo $pagetitle; ?></legend>
	<p>Last modified: <?php echo $modifstamp ?></p>
<ul class="form">
<?php
$usertype_options = array(
	"Consultant"=>'Consultant',
	"Secretary"=>'Secretary',
	"Nurse"=>'Nurse',
	"Medical Staff"=>'Medical Staff',
	"IT Staff"=>'IT Staff',
	"super"=>'Super',
	"Other"=>'Other',
	);
$dept_options = array(
"Renal"=>'Renal',
"Liver"=>'Liver',
);
$flag_options=array(
	'1'=>'Yes',
	'0'=>'No'
	);
inputText("userlast","lastname",20,$userlast);
inputText("userfirst","forename(s)",20,$userfirst);
makeSelect("usertype","user type",$usertype, $usertype_options);
inputText("email","email",30,$email);
makeSelect("dept","dept",$dept, $dept_options);
inputText("location","location",30,$location);
inputText("maintel","main tel",20,$maintel);
inputText("directtel","direct tel",20,$directtel);
inputText("mobile","mobile",20,$mobile);
inputText("fax","fax",20,$fax);
inputText("inits","inits",5,$inits);
inputText("authorsig","authorsig",30,$authorsig);
inputText("position","position",30,$position);
makeSelect("consultantflag","consultant",$consultantflag,$flag_options);
makeSelect("editflag","edit",$editflag,$flag_options);
makeSelect("authorflag","author",$authorflag,$flag_options);
makeSelect("clinicflag","clinic",$clinicflag,$flag_options);
makeSelect("hdnurseflag","hdnurse",$hdnurseflag,$flag_options);
makeSelect("printflag","print queue",$printflag,$flag_options);
makeSelect("decryptflag","decrypt",$decryptflag,$flag_options);
makeSelect("expiredflag","expired",$expiredflag,$flag_options);
inputText("expiredate","expiredate",12,$expiredate);
echo '<li class="submit"><input type="submit" style="color: green;" value="Update user" /></li>';
?>
</ul>
</fieldset>
</form>
<?php else: ?>
<p>Apologies -- you do not have access to this screen</p>	
<?php endif ?>

<?php
include '../parts/footer.php';
?>