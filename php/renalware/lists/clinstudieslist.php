<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . ' Clinical Studies List Management';
//log the event
$eventtype="$page";
include "$rwarepath/run/logevent.php";
//get header
include '../parts/head.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//--------Page Content Here----------
//add patients if edit privs
if ($editflag==1)
	{
		if (!$_GET['mode'])
			{
			echo '<form action="lists/clinstudieslist.php?mode=findstudypat" method="post">
			<fieldset>
				<legend>Enroll Study Patient</legend>
				<input type="text" size="20" name="patname" />
				<input type="submit" style="color: green;" value="find lastname[,firstname]" />
			</fieldset>
			</form>';
			}
		if ($_GET['mode']=="findstudypat")
			{
			include('../incl/studypatpopup.php');
			}
	}
//add study pat
if ($_POST['mode']=="addstudypat")
	{
	$clinstudyzid = $_POST["clinstudyzid"];
	$studyid = $_POST["studyid"];
	$patadddate = $mysqli->real_escape_string($_POST["patadddate"]);
	$patadddate = fixDate($patadddate);
	//add to list
	$insertfields = "clinstudyzid, studyid, clinstudypatstamp, patadduser, patadddate";
	$values="'$clinstudyzid', '$studyid', NOW(), '$user', '$patadddate'";
	$table = "clinstudypatdata";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
    $result = $mysqli->query($sql);
		//log the event
	//set zid
	$zid=$clinstudyzid;
	$eventtype="NEW Clinical Study (ID# $studyid) Patient: $clinstudyzid";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//end logging
	echo '<p class="alert"><b>The patient has been added!</p>';
	}
?>
<h3>Current <?php echo $siteshort; ?> Clinical Studies</h3>
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
$sql= "select study_id, studycode, studyname, studyleader, studynotes, DATE_FORMAT(studystamp, '%d/%m/%y') AS studystamp, (SELECT count(clinstudyzid) FROM clinstudypatdata d WHERE study_id=studyid AND termdate is NULL) as patcount FROM clinstudylist l ORDER BY $sort";
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
<th>Date added</th>
<th>subjects</th>
</tr>
</thead><tbody>
<?php
while ($row = $result->fetch_assoc()) {
	echo '<tr>
	<td>' . $row["study_id"] . '</td>
	<td><a href="lists/clinstudypatlist.php?study_id=' . $row["study_id"] . '">' . $row["studycode"] . '</a></td>
	<td>' . $row["studyname"] . '</td>
	<td>' . $row["studyleader"] . '</td>
	<td>' . $row["studystamp"] . '</td>
	<td>' . $row["patcount"] . '</td>
	</tr>';
}
?>
</tbody></table>
<?php
  include '../parts/footer.php';
?>