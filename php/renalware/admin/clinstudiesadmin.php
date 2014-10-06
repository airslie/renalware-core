<?php
include '../req/confcheckfxns.php';
$pagetitle= 'Add New ' . $siteshort . ' Clinical Study';
//log the event
$eventtype="$page";
include "$rwarepath/run/logevent.php";
//get header
include '../parts/head.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//--------Page Content Here----------
?>
<h3>Existing <?php echo $siteshort; ?> Clinical Studies</h3>
<?php
//add new study
if ($_GET['mode']=="addstudy")
	{
	$studycode = $mysqli->real_escape_string($_POST["studycode"]);
	$studyname = $mysqli->real_escape_string($_POST["studyname"]);
	$studynotes = $mysqli->real_escape_string($_POST["studynotes"]);
	$studydate = $mysqli->real_escape_string($_POST["studydate"]);
	$studyleader = $_POST["studyleader"];
	$studydate = fixDate($studydate);
	//add to list
	$insertfields = "studycode, studyname, studynotes, studystamp, studyleader, studydate";
	$values="'$studycode', '$studyname', '$studynotes', NOW(), '$studyleader', '$studydate'";
	$table = "clinstudylist";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="NEW Clinical Study: $studyname";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//end logging
	echo '<p class="alert"><b>' . $studyname . ' has been added!</p>';
	}
if($_GET["sort"])
	{
	$sort = 'patcount DESC';
	}
else
	{
	$sort = 'studyname';
	}
$sql= "select study_id, studycode, studyname, studyleader, studynotes, DATE_FORMAT(studystamp, '%d/%m/%y') AS studystamp, (SELECT count(clinstudyzid) FROM clinstudypatdata d WHERE study_id=studyid) as patcount FROM clinstudylist l ORDER BY $sort";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows clinical studies. <i>Click on a study code to view current enrolled patients</i></p>";
?>
<table class="tablesorter">
<thead><tr>
<th>study_id</th>
<th>code</th>
<th>Study</th>
<th>Study Leader</th>
<th>Notes</th>
<th>Date added</th>
<th>count</th>
</tr>
</thead><tbody>
<?php
while ($row = $result->fetch_assoc())
	{
	echo '<tr>
	<td>' . $row["study_id"] . '</td>
	<td><a href="lists/clinstudypatlist.php?study_id=' . $row["study_id"] . '">' . $row["studycode"] . '</td>
	<td>' . $row["studyname"] . '</td>
	<td>' . $row["studyleader"] . '</td>
	<td>' . $row["studynotes"] . '</td>
	<td>' . $row["studystamp"] . '</td>
	<td>' . $row["patcount"] . '</td>
	</tr>';
	}
?>
</tbody></table>
<?php
//add new study form
if ($adminflag==1)
	{
	include('../forms/makenewclinicstudy.html');
	}
  include '../parts/footer.php';
?>