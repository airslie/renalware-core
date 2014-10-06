<?php
//----Wed 06 Mar 2013----
if ( $_GET['bxmode']=='addtxbx' )
	{
		foreach ($_POST as $key => $value) {
				$escvalue=$mysqli->real_escape_string($value);
				${$key} = (substr($key,-4)=="date") ? fixDate($escvalue) : $escvalue ;
		}
	$sql="INSERT INTO txbxdata (txbxdate, txbxresult1, txbxresult2, txbxnotes, txbxzid, txbxaddstamp, txbxmodifstamp, txbxuser, txopid) VALUES ('$txbxdate', '$txbxresult1','$txbxresult2','$txbxnotes', $zid, NOW(), NOW(), '$user', $txopid)";
	$result = $mysqli->query($sql);
	echo "<p class=\"alertsmall\">Your Transplant biopsy has been recorded!</p>";
	}
//start table
//display existing
//select...
$fields="txbxdate, txbxresult1, txbxresult2, txbxnotes";
$displaytext='transplant biopsies';
$where="WHERE txbxzid=$zid";
$tables='txbxdata';
$sql="SELECT $fields FROM $tables $where";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no $displaytext recorded for this patient</p>";
	}
	else
	{
	echo "<p class=\"header\">$numrows $displaytext.</p>";
		echo '<table class="list">';
		echo '<thead><tr>
		            <th>date</th>
		            <th>result1</th>
		            <th>result2</th>
		            <th colspan="2">notes</th>
		            </tr></thead><tbody>';
			while ($row = $result->fetch_assoc()) {
				echo '<tr>
				<td>' . dmyyyy($row['txbxdate']) . '</td>
				<td>' . $row['txbxresult1'] . '</td>
				<td>' . $row['txbxresult2'] . '</td>
				<td colspan="2">' . $row['txbxnotes'] . '</td>
				</tr>';
			}
		echo '</tbody></table>';
	}
//add new bx entry form if UPDATE
?>
<p><input type="button" style="background: green; color: #fff" value="Add New Biopsy" onclick="$('#addbiopsyform').show()"/></p>
<?php if ($_GET['mode']=="update"): ?>
	<form id="addbiopsyform" style="display: none;" action="renal/txops.php?zid=<?php echo $zid; ?>&amp;mode=update&amp;txop_id=<?php echo $txop_id; ?>&amp;bxmode=addtxbx" method="post">
		<input type="hidden" name="txopid" value=" <?php echo $txop_id; ?>" id="txopid" />
<fieldset>
    <legend>Add Biopsy</legend>
    <ul>
    <li><label>Biopsy date</label>&nbsp;&nbsp;<input type="text" name="txbxdate" value="<?php echo date("d/m/Y") ?>"class="datepicker" size="12" /></li>
    <li><label>Rx end date</label>&nbsp;&nbsp;<input type="text" name="rxenddate" value="" class="datepicker" size="12" /></li>
    <li><label>result 1</label>&nbsp;&nbsp;<input type="text" name="txbxresult1"  size="20" /></li>
    <li><label>result 2</label>&nbsp;&nbsp;<input type="text" name="txbxresult2"  size="20" /></li>
    <li><label>Notes</label>&nbsp;&nbsp;<input type="text" name="txbxnotes"  size="60" /></li>
    </ul>   
</fieldset>
<input type="submit" style="color: green;" value="Submit biopsy data" />
<input type="button" style="color: red;" value="cancel" onclick="$('#addbiopsyform').hide()"/>

	</form>
<?php endif ?>