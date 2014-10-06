<?php
//if form submitted
$addtable='accessfxndata';
$addtablename='Duplex Ultrasound Assessments';
$addlabel='Add new assessment';
echo "<h3>$addtablename</h3>";
if ( $_POST['add']=="$addtable" )
	{
	include( $addtable . '_add.php' );
	}
$descr = "duplex ultrasound assessment(s)";
$fields = "assessmentdate, modalstamp,accesstype, assessmentmethod, flow_feedartery, artstenosisflag, artstenosistext, venstenosisflag, venstenosistext, rx_decision, proceduredate, proced_outcome, residualstenosisflag, surveillance, assessmentoutcome";
//assume want most recent on top so DESC
$sql= "SELECT $fields FROM $addtable WHERE accessfxnzid=$zid ORDER BY assessmentdate DESC";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows $descr recorded.</p>";
	echo '<table class="list"><tr>
	<th>date</th>
	<th>modal</th>
	<th>access type</th>
	<th>method</th>
	<th>flow feed artery</th>
	<th>art stenosis?</th>
	<th>art stenosis</th>
	<th>ven stenosis?</th>
	<th>ven stenosis</th>
	<th>decision</th>
	<th>procedure date</th>
	<th>comments</th>
	<th>residual stenosis?</th>
	<th>surveillance</th>
	<th>assess outcome</th>
	</tr>';
while ($row = $result->fetch_assoc())
	{
	echo '<tr>';
	foreach ($row as $key => $value) {
		echo '<td>'.$row["$key"].'</td>';
	}
	echo '</tr>';
	}
echo "</table>";
?>