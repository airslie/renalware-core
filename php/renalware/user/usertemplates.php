<?php
include '../req/confcheckfxns.php';
$pagetitle= 'Letter Templates: ' . $user;
include "$rwarepath/navs/topusernav.php";
//get total
if ($get_delete)
	{
	$sql = "SELECT templatename FROM lettertemplates WHERE template_id=$get_delete LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$vanished=strtoupper($row["templatename"]);
	//do the delete
	$sql = "DELETE from lettertemplates WHERE template_id=$get_delete LIMIT 1";
	$result = $mysqli->query($sql);
	echo "<p class=\"alert\">$vanished has vanished into the ether.</p>";
	}
//-------------------------------start formstuff-------------------------------
$addtype="lettertemplate";
//if form submitted
if ($get_add==$addtype )
	{
	include( 'run/'.$addtype .'add.php');
	echo "<p class=\"alertsmall\">The item was added.</p>";
	}
//toggle form here -->
echo '<div id="'.$addtype.'form" style="display:none;padding-top:0px;font-size: 10px;">';
?>
<form action="user/usertemplates.php?add=lettertemplate" method="post">
<fieldset>
<legend>Add new Letter Template for <?php echo $user; ?></legend>
<label for="templatename">Template Name</label><br><input type="text" id="templatename" size="100" name="templatename" /><br>
<label for "templatetext">Template Text</label><br>
<textarea id="templatetext" name="templatetext" rows="20" cols="100">
</textarea><br>
<input type="submit" style="color: green;" value="add new template" />&nbsp;&nbsp;<a class="ui-state-default" style="color: red;" href="javascript:toggl('<?php echo $addtype ?>form');" />cancel</a>
</fieldset>
</form>
<?php
echo "</div>";
//end toggle form -->
$addmore= "<a class=\"tg\" onclick=\"toggl('".$addtype."form');\">Add new $addtype</a>";
//-------------------------------end addform stuff-------------------------------
$displaytext = "letter templates for $user"; //default
$orderby = "ORDER BY templatename"; //incl ORDER BY prn
$sql = "SELECT template_id, templatename, templatestamp, LEFT(templatetext, 500) as abstract from lettertemplates WHERE templateuid=$uid $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">$numrows $displaytext &nbsp; $addmore. \"Hover\" cursor over name to view the first few lines.</p>";
?>
<div id="listdiv" style="float: left;">
	<table class="tablesorter">
	<thead><tr>
		<th>added</th>
		<th>name</th>
		<th>options (delete CANNOT BE UNDONE)</th>
	</tr>
	</thead><tbody>
	<?php
	while($row = $result->fetch_assoc())
		{
		echo '<tr>
			<td>' . $row["templatestamp"] . '</td>
			<td><acronym title="' . $row["abstract"] . '">' . $row["templatename"] . '</a></td>
			<td><a href="user/usertemplates.php?view=' . $row["template_id"] . '">view text</a>&nbsp;&nbsp;<a href="user/usertemplates.php?delete=' . $row["template_id"] . '">delete!</a></td>
		</tr>';
		}
	?>
	</tbody></table>
</div>
<?php
if (isset($_GET['view']))
{
	$template_id=$_GET['view'];
	$sql = "SELECT template_id, templatename, templatetext from lettertemplates WHERE template_id=$template_id";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	echo '<div id="viewdiv" style="clear: none; float: left; width: 40%; padding: 5px; margin-left: 4px; border: thin solid green;">';
	echo "<h3>" . $row["templatename"] . '</h3>
	<p><a class="ui-state-default" style="color: red;" href="user/usertemplates.php">Hide template text</a></p>
	<p>'.nl2br($row["templatetext"]).'</p>
	</div>';
}
?>
<?php
include '../parts/footer.php';
?>