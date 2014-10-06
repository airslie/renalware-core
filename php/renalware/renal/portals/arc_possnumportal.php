<?php
//----Wed 11 May 2011----
$orderby = "ORDER BY possdate DESC";
$fields="poss_id,
possstamp,
possuid,
possuser,
posszid,
possadddate,
possdate
";
$limit = ($latestflag) ? "LIMIT 1" : "" ;
$sql= "SELECT * FROM arc_possdata2 WHERE posszid=$zid $orderby $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows)
{
	if (!$latestflag) {
		echo '<p><b>KEY</b>: 0=<span class="p0">Not at all</span>&nbsp;&nbsp;&nbsp;1=<span class="p1">Slightly</span>&nbsp;&nbsp;&nbsp;2=<span class="p2">Moderately</span>&nbsp;&nbsp;&nbsp;3=<span class="p3">Severely</span>&nbsp;&nbsp;&nbsp;4=<span class="p4">Overwhelmingly</span></p>';
	}
	echo "<table class=\"list\">
	<tr>
	<th>Date</th>
	<th>User</th>
	<th>TOTAL</th>
	<th>pain</th>
	<th>SOB</th>
	<th>weakn</th>
	<th>N</th>
	<th>V</th>
	<th>Poor App</th>
	<th>Const</th>
	<th>Mouth</th>
	<th>drowsy</th>
	<th>mobility</th>
	<th>itch</th>
	<th>insomn</th>
	<th>legs</th>
	<th>anxiety</th>
	<th>depr</th>
	<th>skin</th>
	<th>diarrh</th>
	<th>other 1</th>
	<th>other 2</th>
	<th>other 3</th>
	<th>affected most</th>
	<th>improved most</th>
	</tr>";
	while ($row = $result->fetch_assoc()) {
		//$viewprint = '<a href="renal/arc/updatepossurvey?zid='.$zid.'&amp;poss_id='.$row["poss_id"].'">edit/print</a>';
		//<td>' .$viewprint . '</td>
		echo '<tr>
		<td>' . dmyyyy($row["possdate"]) . '</td>
		<td>' . $row["possuser"] . '</td>
		<td><b>' . $row["totalposs_score"] . '</b></td>
		<td class="p' . $row["pain"] . '">' . $row["pain"] . '</td>
		<td class="p' . $row["shortness_of_breath"] . '">' . $row["shortness_of_breath"] . '</td>
		<td class="p' . $row["weakness"] . '">' . $row["weakness"] . '</td>
		<td class="p' . $row["nausea"] . '">' . $row["nausea"] . '</td>
		<td class="p' . $row["vomiting"] . '">' . $row["vomiting"] . '</td>
		<td class="p' . $row["poor_appetite"] . '">' . $row["poor_appetite"] . '</td>
		<td class="p' . $row["constipation"] . '">' . $row["constipation"] . '</td>
		<td class="p' . $row["mouth_problems"] . '">' . $row["mouth_problems"] . '</td>
		<td class="p' . $row["drowsiness"] . '">' . $row["drowsiness"] . '</td>
		<td class="p' . $row["poor_mobility"] . '">' . $row["poor_mobility"] . '</td>
		<td class="p' . $row["itching"] . '">' . $row["itching"] . '</td>
		<td class="p' . $row["insomnia"] . '">' . $row["insomnia"] . '</td>
		<td class="p' . $row["restless_legs"] . '">' . $row["restless_legs"] . '</td>
		<td class="p' . $row["anxiety"] . '">' . $row["anxiety"] . '</td>
		<td class="p' . $row["depression"] . '">' . $row["depression"] . '</td>
		<td class="p' . $row["skinchanges"] . '">' . $row["skinchanges"] . '</td>
		<td class="p' . $row["diarrhoea"] . '">' . $row["diarrhoea"] . '</td>
		<td>' . $row["othersymptom1"] .' '. $row["othersymptom1score"] . '</td>
		<td>' . $row["othersymptom2"] .' '. $row["othersymptom2score"] . '</td>
		<td>' . $row["othersymptom3"] .' '. $row["othersymptom3score"] . '</td>
		<td>' . $row["affected_most"] . '</td>
		<td>' . $row["improved_most"] . '</td>
		</tr>';
	}
	echo '</table>';
} else {
	echo '<p><i>No records found.</i></p>';
}
