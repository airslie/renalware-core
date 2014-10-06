<?php
//--Fri Mar  8 15:18:38 EST 2013--
$fields="txbxdate, txbxresult1, txbxresult2, txbxnotes";
$displaytext='transplant biopsies';
$where="WHERE txbxzid=$zid";
$tables='txbxdata';
$sql="SELECT $fields FROM $tables $where";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"muted\">There are no $displaytext recorded for this patient</p>";
	}
	else
	{
	echo "<p class=\"text-info\">$numrows $displaytext found</p>";
		echo '<table class="table table-striped table-condensed table-bordered">';
		echo '<thead><tr>
		            <th>date</th>
		            <th>result 1</th>
		            <th>result 2</th>
		            <th>notes</th>
		            </tr></thead><tbody>';
			while ($row = $result->fetch_assoc()) {
				echo '<tr>
				<td>' . dmyyyy($row['txbxdate']) . '</td>
				<td>' . $row['txbxresult1'] . '</td>
				<td>' . $row['txbxresult2'] . '</td>
				<td>' . $row['txbxnotes'] . '</td>
				</tr>';
			}
		echo '</tbody></table>';
	}
//add new bx entry form if UPDATE
?>
<p><button class="btn btn-mini" onclick="$('#biopsyformdiv').show()">Add biopsy result</button></p>
<div id="biopsyformdiv" style="display: none;">
<form action="renal/txop/view_txop.php?zid=<?php echo $zid; ?>&amp;id=<?php echo $txop_id; ?>" method="post">
<fieldset>
	<input type="hidden" name="run" value="addtxbx" />
	<input type="hidden" name="txop_id" value="<?php echo $txop_id; ?>" />
    <legend>Add Biopsy</legend>
    <label>Biopsy date</label>
    <input type="text" name="txbxdate" value="<?php echo date("d/m/Y") ?>" class="input-small datepicker" />
    <label>Result 1</label>
    <input type="text" name="txbxresult1" class="input-xlarge" />
    <label>Result 2</label>
    <input type="text" name="txbxresult2" class="input-xlarge" />
    <label>Biopsy Notes</label>
    <textarea name="txbxnotes" rows="3"></textarea>
    </ul>   
</fieldset>
<button type="submit" class="btn btn-success btn-small">Submit biopsy data</button>
</form>
<button class="btn btn-danger btn-small" onclick="$('#biopsyformdiv').hide()">Cancel</button>
</div>
