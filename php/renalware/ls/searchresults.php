<?php
//----Mon 13 Jan 2014----RPV and death colourcoding restored
//----Mon 06 Jan 2014----
//--Fri Dec 20 11:09:12 CET 2013--
include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
include '../req/confcheckfxns.php';
$searchstring=$_GET["findpat"];
$listitems="patients";
$pagetitle= "Renalware search results for &ldquo;$searchstring&rdquo;";
//get datatable header
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
$limit="";
//fix "’" entry
$searchstring=str_replace("’","'",$searchstring);
//to fix e.g. "O'Donnell":
$searchstringfix = $mysqli->real_escape_string($searchstring);
$searchstring_lc = strtolower($searchstringfix); //nb hospno may be entered in lc as well
	if(strstr($searchstring_lc,",")) //firstname entered and NOT hospno
		{
		$lastfirst = explode(",",$searchstring_lc);
		$ln = trim($lastfirst[0]);
		$fn = trim($lastfirst[1]);
		$where = "WHERE LOWER(lastname) LIKE '$ln%' AND LOWER(firstnames) LIKE '$fn%'";
		}
	else
		{
        $where="WHERE LOWER(hospno1) = '$searchstring_lc' OR LOWER(hospno2) = '$searchstring_lc' OR LOWER(hospno3) = '$searchstring_lc' OR LOWER(hospno4) = '$searchstring_lc' OR LOWER(hospno5) = '$searchstring_lc' OR nhsno='$searchstring_lc' OR LOWER(lastname) LIKE '$searchstring_lc%'";
		}
	$displaytext = "<b>$searchstring</b> matches";
?>
<div id="datatablediv">
<?php
$table="patientdata";
$listnotes="Click on patient name for Clinical Summary.";
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=admin' => "admin",
	'letters/createletter.php' => "new lttr",
);
$showsql=false;
$fields="";
$theaders="<th>New</th>
    <th>View</th>
    <th>Patient (Clin Summ)</th>
    <th>DOB</th>
    <th>Age</th>
    <th>Sex</th>
    <th>Modal</th>
    <th>NHS No</th>
    <th>$hosp1label</th>
    <th>$hosp2label</th>
    <th>$hosp3label</th>
    <th>$hosp4label</th>
    <th>RPV?</th>
";
$fields = "patzid, hospno1,hospno2,hospno3,hospno4,hospno5,nhsno, CONCAT(UPPER(lastname),', ', firstnames) as patlastfirst, sex, birthdate, age, modalcode, rpvstatus";
$orderby="ORDER BY lastname, firstnames";
$sql = "SELECT $fields FROM $table $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($showsql) {
	echo "<p class=\"alertsmall\">$sql</p>";
}
if ($numrows) {
	showInfo("$numrows $listitems found","$listnotes");
} else {
	showAlert("No matching $listitems located!");
}
?>
<div><form action="ls/searchresults.php" method="get" accept-charset="utf-8">
    <fieldset><legend>Revise your search</legend>
        <input type="text" name="findpat" value="<?php echo $searchstring ?>" id="findpat"> &nbsp;&nbsp;<input type="submit" value="Submit &rarr;"></fieldset>
</form></div>
<?php if ($numrows): ?>
<table id="datatable" class="display">
	<thead><tr><?php echo $theaders ?></tr></thead>
	<tbody>
	<?php
	while($row = $result->fetch_assoc())
		{
		$zid=$row["patzid"];
		$tdclass = ($row["modalcode"]=="death") ? ' class="death"' : '';
        $rpv = ($row["rpvstatus"]) ? $row["rpvstatus"] : '<a href="ls/rpvlist.php?newzid='.$zid.'">Add</a>';
		echo '<tr'.$trclass.'>
        <td><a href="letters/createletter.php?zid='.$zid.'" >letter</a></td>
        <td><a href="pat/patient.php?vw=admin&amp;zid='.$zid.'" >admin</a>&nbsp;&nbsp;
        <td><a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . $row["patlastfirst"] . '</a></td>
        <td>'.dmyyyy($row["birthdate"]).'</td>
        <td>'.$row["age"].'</td>
        <td>'.$row["sex"].'</td>
        <td'.$tdclass.'>'.$row["modalcode"].'</td>
        <td>'.$row["nhsno"].'</td>
        <td>'.$row["hospno1"].'</td>
        <td>'.$row["hospno2"].'</td>
        <td>'.$row["hospno3"].'</td>
        <td>'.$row["hospno4"].'</td>
		<td>'.$rpv.'</td>
        </tr>';
		}
	?>
	</tbody>
</table>
<script>
	$('#datatable').dataTable( {
		"bPaginate": true,
		"bLengthChange": false,
		"bJQueryUI": false,
		"bFilter": false,
		"iDisplayLength": 50,
		"bSort": true,
        "aaSorting": [[ 2, "asc" ]],
        "aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 0, 1 ] }
          ],
		"bInfo": false,
		"bAutoWidth": true,
		"bStateSave": false
	} );
</script>
<?php endif ?>
</div>
<?php
include '../parts/footer.php';
