<?php
//----Sun 07 Apr 2013----sorts and better col display for adduser
//----Sun 10 Mar 2013----adduser
//----Mon 25 Feb 2013----prescriber, provider added; esa class fix
$sorthist="medsdata_id DESC"; //default
if ( $_GET['sorthist'] )
{
	$sorthist=$_GET['sorthist'];
}
$sql = "SELECT * FROM medsdata WHERE medzid=$zid ORDER BY $sorthist";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">Medications History ($numrows). <b>Highlighted</b> (yellow, turquoise, or grey) are currently prescribed</p>";
echo '<table class="list">
<tr>
<th>drug <a href="pat/patient.php?vw=meds&amp;zid='.$zid.'&amp;sorthist=drugname,adddate">sort</a></th>
<th>dose route freq</th>
<th>started <a href="pat/patient.php?vw=meds&amp;zid='.$zid.'&amp;sort=adddate">sort</a></th>
<th>prescriber</th>
<th>stopped (by)</th>
<th>modality</th>
<th>provider</th>
<th>notes</th>
</tr>';
while($row = $result->fetch_assoc())
	{
	$class='currmed';
	if ($row['esdflag'])
		{
		$class = 'esa'; //flag ESAs
		}
	if ($row['immunosuppflag'])
		{
		$class = 'immunosupp'; //flag immunosupps
		}
	if ($row['termdate'])
		{
		$class='discont';
		}
	echo '<tr class="' . $class . '">
	<td>' . $row['drugname'] . '</td>
	<td>' . $row['dose'] . ' ' . $row['route'] . ' ' . $row['freq'] . '</td>
	<td class="start">' . dmyyyy($row['adddate']) .'</td>
	<td>' . $row['adduser'] . '</td>
	<td class="term">' . dmyyyy($row['termdate']) . ' '  . $row['termuser'] . '</td>
	<td>' . $row['medmodal'] . '</td>
	<td>' . $row['provider'] . '</td>
	<td>' . $row['drugnotes'] . '</td>
	</tr>';
	}
echo '</table>';

