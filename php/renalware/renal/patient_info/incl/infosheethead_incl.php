<?php
//----Sat 03 Jul 2010----
$sheetdate= date('D d M Y');
echo '<p style="background: #ddd; color: black; font-size: 10pt; padding: 2px">';
echo "<b>King&rsquo;s Renal Unit</b>&nbsp;&nbsp;$sheettitle (printed $sheetdate)</p>
	<h1>$pat_ref<br>$pat_addr</h1>
	<p><b>GP:</b> $gpref</p>";
?>
<table class="infosheet">
	<tr><th width="50%">Problem List</th><th width="50%">Current Medications</th></tr>
<tr><td><?php
echo nl2br($problist);
?>
</td><td>
<?php
echo nl2br($medlist);
?>
<p style="font-size: 8pt; font-style: italic;"><b>od</b>=once daily; <b>bd</b>=twice daily; <b>tid</b>=3 times daily; <b>qds</b>=4 times daily; <b>PO</b>=by mouth; <b>mane</b>=in the morning; <b>nocte</b>=at night; <b>prn</b>=as required</p>
</td></tr>
</table>