<?php
require '../config_incl.php';
include '../incl/check.php';
include '../fxns/fxns.php';
include '../fxns/formfxns.php';
$pagetitle= $siteshort . ' Users &amp; Privileges List';
include "$rwarepath/navs/topusernav.php";
?>
<?php if (!$adminflag): ?>
	Sorry, you do not have access to this information.
<?php else: ?>
<form href="user/userlist.php?" method="get"><fieldset>Search by last name (case insensitive; e.g. "smith" or "Smith" or "Sm"): <input type="text" size="20" name="user" bgcolor="yellow" value="last_name"><input type="submit" style="color: green;" value="Find User"><input type="reset" class="ui-state-default" style="color: #333;" value="Clear" /></fieldset></form>
<!--content here-->
<div id="subnavbar">
<p>
<a class="ui-state-default" style="color: green;" href="user/userlist.php">Show All</a></li>
<?php
$flags=array(
	'adminflag' => 'admin',
	'consultantflag' => 'consultant',
	'editflag' => 'edit',
	'authorflag' => 'author',
	'clinicflag' => 'clinic',
	'hdnurseflag' => 'HD nurse',
	'printflag' => 'print queue',
	'logged_inflag' => 'logged in',
	'bedmanagerflag' => 'bed manager',
	'expiredflag' => 'expired',
	);
	foreach ($flags as $key => $value) {
			$style = ($key==$get_show) ? "color: red; background: yellow" : "#333" ;
			echo '<a class="ui-state-default" style="'.$style.';" href="user/userlist.php?show=' . $key . '">' . $value . '</a>&nbsp;&nbsp;';
		}
?>
</p>
</div>
<?php
//run REVIVE/EXPIRE
if ($get_expire_uid) {
	$sql = "UPDATE userdata SET expiredate=NOW(),modifstamp=NOW(),expiredflag='1' WHERE uid=$get_expire_uid LIMIT 1";
	$result = $mysqli->query($sql);	
}
if ($get_revive_uid) {
	$sql = "UPDATE userdata SET expiredate=NULL,modifstamp=NOW(),expiredflag='0' WHERE uid=$get_revive_uid LIMIT 1";
	$result = $mysqli->query($sql);	
}

//get total
$listwhere = ""; // default
$displaytext = "$siteshort users"; //default
if($_GET["user"])
	{
	$userlast = $_GET["user"];
	$displaytext = "users matching <b>$userlast</b>";
	$listwhere = "WHERE lower(userlast) LIKE lower('$userlast%')";
	}
if($_GET["show"])
	{
	$show = $_GET["show"];
	$showlabel=$flags[$get_show];
	$showflag = $_GET["show"] . 'flag';
	$displayquery = "SELECT uid FROM userdata WHERE $get_show='1'";
	$displaytext = " <b>$showlabel</b> users";
	$listwhere = "WHERE $get_show='1'";
	}
$tables = "userdata";
$fields = "uid, user, pass, userlast, userfirst, adddate, lastloginstamp, passmodifstamp,modifstamp, expiredate,expiredflag, usertype, email, sitecode, dept, location, maintel, directtel, mobile, fax, inits, authorsig, position, logged_inflag";
$orderby = "ORDER BY userlast, userfirst";
//see above for list WHEREs
$sql= "SELECT $fields FROM $tables $listwhere $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0') {
	echo "<p class=\"headergray\">There are no $displaytext</p>";
}
else {
	echo "<p class=\"header\">$numrows $displaytext. Click on headers to sort.</p>";
	echo '<table class="tablesorter">
	<thead><tr>
	<th>options</th>
		<th>UID</th>
		<th>user</th>
		<th>name</th>
		<th>added</th>
		<th>user type</th>
		<th>inits</th>
		<th>signature</th>
		<th>position</th>
		<th>last login</th>
		</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$expiredflag=$row["expiredflag"];
		$bg = ($row["logged_inflag"]=="1") ? '#ffff00' : '#fff';
		if ($expiredflag=='1') {
			$bg='#cccccc';
		}
		$changestatus = ($expiredflag=='1') ? "revive" : "expire" ;
		echo '<tr bgcolor="' . $bg . '">
			<td><a href="admin/adminuser.php?edituid=' . $row["uid"] . '">edit</a>&nbsp;&nbsp;<a href="user/userlist.php?sortby='.$sortby.'&amp;'.$changestatus.'_uid=' . $row["uid"] . '">'.$changestatus.'</a></td>
			<td>' . $row["uid"] . '</td>
			<td>' . $row["user"] . '</td>
			<td><b>' . $row["userlast"] . ", " . $row["userfirst"] . '</b></td>
			<td>' . $row["adddate"] . '</td>
			<td>' . $row["usertype"] . '</td>
			<td>' . $row["inits"] . '</td>
			<td>' . $row["authorsig"] . '</td>
			<td>' . $row["position"] . '</td>
			<td>' . $row["lastloginstamp"] . '</td>
			</tr>';
	}
	echo '</tbody></table>';
}
?>
<?php endif ?>
<?php
include '../parts/footer.php';
?>