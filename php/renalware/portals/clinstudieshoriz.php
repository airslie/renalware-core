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
echo "<p>";
if ($numrows)
	{
	while ($row = $result->fetch_assoc())
		{
			echo '<a class="ui-state-default" style="color: gray;" href="lists/clinstudypatlist.php?study_id='.$row["studyid"].'">Clin Study: <b>'.$row["studyname"].'</b></a>&nbsp;&nbsp;';			
		}
	}

echo "</p>";
?>
