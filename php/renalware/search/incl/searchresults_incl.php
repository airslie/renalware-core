<table id="datatable" class="display">
	<thead>
		<tr>
		<?php
		if ($resultsoptions) {
		  echo '<th>options</th>';
		}
		foreach ($displayfields as $key => $thisfld)
			{
			echo '<th>'.$thisfld.'</th>';			
			} //end foreach
		?>
		</tr>
	</thead>
	<tbody>
	<?php
	while($row = $result->fetch_assoc())
		{
		echo "<tr>";
		if ($resultsoptions) {
		    //for e.g. view.php?scr=clinsumm&amp;zid=$primid
		  include "$searchpath/$thissearch/results_options.php";
		}
		foreach ($displayfields as $key => $fld)
			{
				echo '<td>'.$row["$fld"].'</td>';
			}
		echo "</tr>\r";
		}
	$result->close();
	?>
	</tbody>
</table>
<script>
		$('#datatable').dataTable( {
			"bPaginate": true,
			"bLengthChange": false,
			"bJQueryUI": false,
			//"sPaginationType": "full_numbers",
			"bFilter": true,
			"iDisplayLength": 100,
			"bSort": true,
			"bInfo": true,
			"bAutoWidth": true,
			"bStateSave": true
		} );
</script>