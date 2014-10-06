<?php 
$fields='studyid,
studycode,
studyname,
studyleader';
$headers="study,leader";
$fieldslist=explode(",",$fields);
$headerslist=explode(",",$headers);
$sql= "SELECT $fields FROM clinstudypatdata JOIN clinstudylist ON studyid=study_id WHERE clinstudyzid=$zid AND termdate is NULL";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">Current Clinical Studies ($numrows) <small> &nbsp;&nbsp;<i><a href=\"lists/clinstudieslist.php\">view/manage studies</a></i></small></p>";
if ($numrows)
	{
	echo '<ul class="portal">';
	while ($row = $result->fetch_assoc())
		{
			echo '<li><a href="lists/clinstudypatlist.php?study_id='.$row["studyid"].'">'.$row["studyname"].'</a> ('.$row["studyleader"].')</li>';			
		}
	echo '</ul>';
	}
?>
