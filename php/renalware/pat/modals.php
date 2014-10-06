<?php
//----Mon 25 Feb 2013----modaltermdate
//Mon May 11 14:58:49 CEST 2009
$addtype="modal";
if ($get_add=="modal") {
 	include 'run/run_addmodal.php';
}
//toggle form here
echo '<div id="'.$addtype.'form" style="display:none;padding-top:0px;font-size: 10px;">';
include 'forms/'.$addtype.'form.php';
echo "</div>";
//end toggle form
$addmore='<button type="button" class="ui-state-default" style="color: green;"  onclick="$(\'#'.$addtype.'form\').toggle()">Add new '.$addtype.'</button>';

$displaytext = "modalities recorded for patient ID $zid"; //default
$orderby = "ORDER BY modaldate DESC"; //incl ORDER BY prn
$sql = "SELECT d.modalcode, d.modalsitecode, modaldate, modalnotes, modaluser, modality,modaltermdate FROM modaldata d JOIN modalcodeslist l ON d.modalcode=l.modalcode WHERE modalzid=$zid $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	echo "<p class=\"header\">$numrows $displaytext. &nbsp; $addmore</p>";
	echo "<table class=\"list\">
	<tr>
		<th>date</th>
		<th>user</th>
		<th>modality</th>
		<th>sitecode</th>
		<th>notes</th>
		<th>term date</th>
	</tr>";
	while($row = $result->fetch_assoc())
		{
		echo '<tr>
		<td>' . dmyyyy($row["modaldate"]) . '</td>
		<td>' . $row["modaluser"] . '</td>
		<td><b>' . $row["modality"] . '</b></td>
		<td>' . $row["modalsitecode"] . '</td>
		<td>' . $row["modalnotes"] . '</td>
		<td>' . dmyyyy($row["modaltermdate"]) . '</td>
		</tr>';
		}
	echo '</table>';
} else {
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	//include here b/c every pat must have modal and may be sent from patient add script
	include 'forms/modalform.php';
}
