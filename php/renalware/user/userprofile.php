<?php
include '../req/confcheckfxns.php';
$pagetitle= "User Profile: $user";
include "$rwarepath/navs/topusernav.php";
$fields = "uid, user, userlast, userfirst, dept, location, adddate, passmodifstamp, email, maintel, directtel, mobile, fax, authorsig, position, modifstamp, authorflag, adminflag";
$tables = "userdata";
$where = "WHERE uid=$uid";
$sql="SELECT $fields FROM $tables $where";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
if ($row) {
foreach($row AS $key => $value)
	{
	${$key} = (strtolower(substr($key,-4))=="date") ? dmyyyy($value) : $value ;
	}
}
?>
<ul class="portal">
<li class="hdr">Current profile for <?php echo $user ?></li>
<li><b>User ID</b>&nbsp;&nbsp;<?php echo $uid; ?></li>
<li><b>user</b>&nbsp;&nbsp;<?php echo $user; ?></li>
<li><b>userlast</b>&nbsp;&nbsp;<?php echo $userlast; ?></li>
<li><b>userfirst</b>&nbsp;&nbsp;<?php echo $userfirst; ?></li>
<li><b>dept</b>&nbsp;&nbsp;<?php echo $dept; ?></li>
<li><b>location</b>&nbsp;&nbsp;<?php echo $location; ?></li>
<li><b>email</b>&nbsp;&nbsp;<?php echo $email; ?></li>
<li><b>maintel</b>&nbsp;&nbsp;<?php echo $maintel; ?></li>
<li><b>direct tel</b>&nbsp;&nbsp;<?php echo $directtel; ?></li>
<li><b>mobile</b>&nbsp;&nbsp;<?php echo $mobile; ?></li>
<li><b>fax</b>&nbsp;&nbsp;<?php echo $fax; ?></li>
<li><b>author sig</b>&nbsp;&nbsp;<?php echo $authorsig; ?></li>
<li><b>position</b>&nbsp;&nbsp;<?php echo $position; ?></li>
<li><b>modifstamp</b>&nbsp;&nbsp;<?php echo $modifstamp; ?></li>
<li><b>passmodifstamp</b>&nbsp;&nbsp;<?php echo $passmodifstamp; ?></li>
</ul>
<?php
include '../parts/footer.php';
?>