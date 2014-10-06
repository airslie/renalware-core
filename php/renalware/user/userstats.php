<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . ' User Stats';
include "$rwarepath/navs/topusernav.php";
?>
<small>
<form href="user/userstats.php?" method="get"><fieldset>Search by last name (case insensitive; e.g. "smith" or "Smith" or "Sm"): <input type="text" size="20" name="user" title="last_name"><input type="submit" style="color: green;" value="Find User"><input type="reset" class="ui-state-default" style="color: #333;" value="Clear" /></fieldset></form>
<!--content here-->
<p><a class="ui-state-default" style="color: green;" href="user/userstats.php">Show All</a> &nbsp; &nbsp; <a class="ui-state-default" style="color: purple;" href="user/userstats.php?show=logged_in">Show Logged In</a></p>
<?php
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
	$showflag = $_GET["show"] . 'flag';
	$displaytext = " <b>$show</b> users";
	$listwhere = "WHERE $showflag=1";
	}
$displaytime = date("D j M Y  G:i:s");
$tables = 'userdata u';
$fields = "uid, user, userlast, userfirst, adddate, expiredate, passmodifstamp, usertype, userstamp, modifstamp, logged_inflag, (SELECT count(sessuid) from renalware.renalsessions WHERE sessuid=uid) as logincount, lastloginstamp, lasteventstamp";
$orderby = "ORDER BY userlast, userfirst";
//see above for list WHEREs
$sql= "SELECT $fields FROM $tables $listwhere $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext. Click on headers to sort.</p>";
	echo '<table class="tablesorter">
	<thead><tr>
		<th>uid</th>
		<th>user</th>
		<th>name</th>
		<th>added</th>
		<th>expires</th>
		<th>password updated</th>
		<th>usertype</th>
		<th>logged_in</th>
		<th>logincount</th>
		<th>lastlogin</th>
		<th>lastevent</th>
		</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		echo '<tr bgcolor="' . $bg . '">
			<td>' . $row["uid"] . '</td>
			<td>' . $row["user"] . '</td>
			<td><a href="user/editprofile.php?uid=' . $row["uid"] . '">' . $row["userlast"] . ", " . $row["userfirst"] . '</a></td>
			<td>' . $row["adddate"] . '</td>
			<td>' . $row["expiredate"] . '</td>
			<td>' . $row["passmodifstamp"] . '</td>
			<td>' . $row["usertype"] . '</td>
			<td>' . $row["logged_inflag"] . '</td>
			<td>' . $row["logincount"] . '</td>
			<td>' . $row["lastloginstamp"] . '</td>
			<td>' . $row["lasteventstamp"] . '</td>
			</tr>';
		}
	echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>