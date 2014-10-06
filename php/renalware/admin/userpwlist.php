<?php
require '../config_incl.php';
include('../incl/check.php');
$pagetitle= $siteshort . ' User Passwords List';
include "$rwarepath/navs/topusernav.php";
//--------Page Content Here----------
?>
<form action="admin/userpwlist.php?" method="get"><fieldset>Search by last name (case insensitive; e.g. "smith" or "Smith" or "Sm"): <input type="text" size="20" name="finduser"><input type="submit" style="color: green;" value="Find User" /></fieldset></form>
<!--content here-->
<?php
if ($_GET['reset'] && $adminflag==1)
	{
	$resetuid=$_GET['reset'];
	//get randomizer
	include "$rwarepath/fxns/makerandompw.php";
	//gives $newpass
	//update pw
	$sql= "UPDATE userdata SET pass=PASSWORD('$newpass'), passmodifstamp=NOW(),newpwflag='1' WHERE uid=$resetuid";
$result = $mysqli->query($sql);
		//log the event
		$eventtype="password changed for user ID $resetuid";
		include "$rwarepath/run/logevent.php";
	//get email
	$sql= "SELECT user, email FROM userdata where uid=$resetuid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$email=$row["email"];
	$user=$row["user"];
	echo "<p class=\"alert\">The password for $user has been reset to &ldquo;$newpass&rdquo;</p>";
	echo '<p><a class="ui-state-default" style="color: purple;" href="mailto:' . $email . '?subject=Renalware ALERT&body=your new Renalware SQL password is ' . $newpass . '; please login and change it to something new ASAP: http://renalweb/renalware/">Email the new password to ' . $user . ' now</a></p>';
	} //end reset
if ($_GET['reset'] && $adminflag!=1)
	{
	echo '<span class="alert">Sorry you do not have these privileges!</span><br>';
	}
//get total
$listwhere = ""; // default
$displaytext = "$siteshort users"; //default
if($_GET["finduser"])
	{
	$userlast = strtolower($mysqli->real_escape_string($_GET["finduser"]));
	$displaytext = "users matching <b>$userlast</b>";
	$listwhere = "WHERE lower(userlast) LIKE '$userlast%'";
	}
$fields = "uid, user, userlast, userfirst, adddate, expiredate, passmodifstamp, email";
$orderby = "ORDER BY userlast, userfirst";
//see above for list WHEREs
$sql= "SELECT $fields FROM userdata $listwhere $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
$showrows = ($numrows) ? "$numrows $displaytext." : "There are no $displaytext" ;
echo "<p class=\"header\">$showrows</p>";
	if ($numrows) {
		$theaders='<th>uid</th>
		<th>user</th>
		<th>name</th>
		<th>added</th>
		<th>expires</th>
		<th>password modifdate</th>
		<th>email</th>
		<th>options</th>';
	echo '<table class="tablesorter"><thead><tr>'.$theaders.'</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		echo '<tr bgcolor="' . $bg . '">
			<td>' . $row["uid"] . '</td>
			<td>' . $row["user"] . '</td>
			<td><a href="user/userhome.php?uid=' . $row["uid"] . '">' . $row["userlast"] . ", " . $row["userfirst"] . '</a></td>
			<td>' . $row["adddate"] . '</td>
			<td>' . $row["expiredate"] . '</td>
			<td>' . $row["passmodifstamp"] . '</td>
			<td>' . $row["email"] . '</td>
			<td><a href="admin/userpwlist.php?reset=' . $row["uid"] . '">reset password?</a></td>
			</tr>';
		}
	echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>