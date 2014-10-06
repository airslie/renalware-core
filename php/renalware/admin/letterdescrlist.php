<?php
include '../req/confcheckfxns.php';
$pagetitle= "$siteshort Letter Descriptions";
include "$rwarepath/navs/topusernav.php";
if ($post_newletterdescr) {
	$newletterdescr = $mysqli->real_escape_string($_POST["newletterdescr"]);
	$sql = "INSERT INTO letterdescrlist (letterdescrstamp, letterdescruid, letterdescr,clinicflag) VALUES (NOW(),$uid,'$newletterdescr',$post_clinicflag)";
	$result = $mysqli->query($sql);
	$eventtype="NEW LETTER DESCRIPTION: $newletterdescr added by $user";
	include "$rwarepath/run/logevent.php";
	echo "<p class=\"alertsmall\">The letter type \"$post_newletterdescr\" has been added to the list.</p>";
}
?>
<form action="admin/letterdescrlist.php" method="post" accept-charset="utf-8">
	<fieldset>
		<legend>Add New Letter Description</legend>
		<ul class="form">
		<li><b>IMPORTANT</b>: Ensure the letter description does not exist already!</li >
		<li><label>New Description</label><input type="text" name="newletterdescr" size="70" id="newletterdescr" /></li>
		<li><label>Clinic Letter?</label><input type="radio" name="clinicflag" value="0" checked>No &nbsp; &nbsp; <input type="radio" name="clinicflag" value="1">Yes</li>
		<li class="submit"><input type="submit" style="color: green;" value="Add Letter Description &rarr;" /></li>
		</ul>
	</fieldset>
</form>
<?php
if ( $_GET['delete'] )
	{
	$delete_id=$_GET['delete'];
	//get the name
	$sql= "SELECT letterdescr FROM letterdescrlist WHERE lettertype_id=$delete_id";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$vanished=strtoupper($row["letterdescr"]);
	//do the delete
	$sql= "DELETE FROM letterdescrlist WHERE lettertype_id=$delete_id LIMIT 1";
	$result = $mysqli->query($sql);
	echo "<p class=\"alertsmall\">The letter type \"$vanished\" has vanished into the ether.</p>";
	}
$displaytext = "letter types for $siteshort. <a href=\"admin/letterdescrsreport.php\">View usage report</a>"; //default
$orderby = "ORDER BY letterdescr"; //incl ORDER BY prn
$sql= "SELECT lettertype_id, letterdescr, letterdescrstamp FROM letterdescrlist $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows $displaytext</p>";
?>
<table class="tablesorter">
<thead><tr>
	<th>added</th>
	<th>letter description</th>
	<th>delete? CANNOT BE UNDONE</th>
</tr>
</thead><tbody>
<?php
while($row = $result->fetch_assoc()) {
	echo '<tr>
		<td>' . $row["letterdescrstamp"] . '</td>
		<td><b>' . $row["letterdescr"] . '</b></td>
		<td class="options"><a href="admin/letterdescrlist.php?delete=' . $row["lettertype_id"] . '">delete!</a></td>
	</tr>';
}
?>
</tbody>
</table>
<?php
include '../parts/footer.php';
?>