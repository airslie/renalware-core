<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . ' User Privileges &amp; Stats';
include "$rwarepath/navs/topusernav.php";
?>
<form href="user/userprivs.php?" method="get"><fieldset>Search by last name (case insensitive; e.g. "smith" or "Smith" or "Sm"): <input type="text" size="20" name="user" bgcolor="yellow" title="last_name"><input type="submit" style="color: green;" value="Find User"><input type="reset" class="ui-state-default" style="color: #333;" value="Clear" /></fieldset></form>
<!--content here-->
<a class="ui-state-default" style="color: green;" href="user/userprivs.php">Show All</a>&nbsp;&nbsp; 
<a class="ui-state-default" style="color: purple;" href="user/userprivs.php?show=logged_in">Show Logged In</a>&nbsp;&nbsp; 
<?php
$flags=array(
	'adminflag' => 'admin',
	'consultantflag' => 'consultant',
	'authorflag' => 'author',
	'clinicflag' => 'clinic',
	'hdnurseflag' => 'HD nurse',
	'bedmanagerflag' => 'bed manager',
	'wardclerkflag' => 'ward clerk',
	'transportdeciderflag' => 'transport decider',
	);
	foreach ($flags as $key => $value) {
			$style = ($key==$get_show) ? "color: red; background: yellow" : "#333" ;
			echo '<a class="ui-state-default" style="'.$style.';" href="user/userprivs.php?show=' . $key . '">' . $value . '</a>&nbsp;&nbsp;';
		}
?>
</p>
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
$fields = "uid, user, pass, userlast, userfirst, adminflag, editflag,logged_inflag, consultantflag, authorflag, clinicflag, decryptflag, adddate, expiredate, passmodifstamp, usertype, userstamp, modifstamp";
$orderby = "ORDER BY userlast, userfirst";
//see above for list WHEREs
$sql= "SELECT $fields FROM $tables $listwhere $orderby LIMIT $start, $display";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext</p>";
	echo '<table class="tablesorter">
	<thead><tr><th>uid</th>
		<th>user</th>
		<th>name</th>
		<th>added</th>
		<th>expires</th>
		<th>password modifdate</th>
		<th>usertype</th>
		<th>admin</th>
		<th>edit</th>
		<th>consultant</th>
		<th>author</th>
		<th>clinic</th>
		<th>decrypt</th>
		</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$trclass = ($row["logged_inflag"]=="1" ? 'hilite' : '');
		echo '<tr class="' . $trclass . '">
			<td>' . $row["uid"] . '</td>
			<td>' . $row["user"] . '</td>
			<td><a href="user/editprofile.php?uid=' . $row["uid"] . '">' . $row["userlast"] . ", " . $row["userfirst"] . '</a></td>
			<td>' . $row["adddate"] . '</td>
			<td>' . $row["expiredate"] . '</td>
			<td>' . $row["passmodifstamp"] . '</td>
			<td>' . $row["usertype"] . '</td>
			<td>' . $row["adminflag"] . '</td>
			<td>' . $row["editflag"] . '</td>
			<td>' . $row["consultantflag"] . '</td>
			<td>' . $row["authorflag"] . '</td>
			<td>' . $row["clinicflag"] . '</td>
			<td>' . $row["decryptflag"] . '</td>
			</tr>';
		}
	echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>