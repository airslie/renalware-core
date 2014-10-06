<?php
//----Fri 22 Nov 2013----$path_to_krudownloads var in config_local
//----Wed 12 Jun 2013----datatable and krudownloads/ at www root
//----Thu 06 Dec 2012----
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Downloads List";
//get datatable header
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
echo '<p class="alertsmall">For the time being please submit documents for this screen to '.$admin.'</p>';
$sql= "SELECT filetitle, filedescr, filename, DATE(addstamp) AS adddate FROM downloads ORDER BY filetitle";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows downloads available.</p>";
echo '<table id="datatable">
    <thead>
	<tr>
	<th>Name</th>
	<th>Description</th>
	<th>Date added</th>
	<th>download</th>
	</tr>
    </thead>
    <tbody>';
while ($row = $result->fetch_assoc())
	{
	echo "<tr>
	<td><b>" . $row["filetitle"] . '</b></td>
	<td>' . $row["filedescr"] . '</td>
	<td>' . dmyyyy($row["adddate"]) . '</td>
	<td><a href="'.$path_to_krudownloads.'/' . $row["filename"] . '">download file</a></td></tr>';
	}
echo '</tbody>
</table>';
include '../parts/footer.php';
?>
<script>
	$('#datatable').dataTable( {
		"bPaginate": false,
		"bLengthChange": false,
		"bJQueryUI": false,
		"bFilter": true,
		"aaSorting": [[ 1, "asc" ]],
		"iDisplayLength": 400,
		"bSort": true,
		"bInfo": true,
		"bAutoWidth": false,
		"bStateSave": true
	} );
</script>
