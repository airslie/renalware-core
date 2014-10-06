<?php
//----Sun 15 May 2011----
require '../../config_incl.php';
require '../../incl/check.php';
include '../../fxns/fxns.php';
include '../config/mrsa_config.php';
$table="mrsadata";
$sql = "SELECT * FROM $table WHERE mrsa_id=$get_mrsa_id";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
	foreach ($row as $key => $value) {
		$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
if ($resultdate && $swabresult) {
	$showfields=$mrsa_showdatamap;
	echo '<h4>MRSA Swab Results of '.dmyyyy($row["swabdate"]).'</h4>';
	echo '<ul class="dataportal">';
	foreach ($showfields as $key => $value) {
		list($specs,$label)=explode("^",$value);
		if ($specs=="0") {
			echo '<li class="header">'.$label.'</li>';
		} else {
			echo '<li><b>'.$label.'</b>&nbsp;&nbsp;'.$$key."</li>";
		}
	}
	echo '</ul><input type="button" style="color: red;" value="Cancel"  onclick="hideMRSA()"/>';
} else {
echo '<br><br><form action="renal/renal.php?scr=mrsa&amp;zid='.$mrsazid.'" method="post" accept-charset="utf-8">
		<input type="hidden" name="runmode" value="updmrsadata" />
		<input type="hidden" name="mrsa_id" value="'.$mrsa_id.'" />
		<input type="hidden" name="swabdate" value="'.dmyyyy($row["swabdate"]).'" />
		<fieldset>
			<legend>Update MRSA Swab data (ID No '.$mrsa_id.')</legend>
			<ul class="form">';
			$datamap=$mrsa_upddatamap;
			include '../incl/makeupdfieldsx_incl.php';
			echo '<li class="submit"><input type="submit" style="color: green;" value="Update data&rarr;" />&nbsp;&nbsp;<input type="button" style="color: red;" value="Cancel"  onclick="hideMRSA()"/></li>
			</ul>
		</fieldset>
	</form>';
}
?>
<script type="text/javascript">
	$(".datepicker").datepicker({
		dateFormat: 'dd/mm/yy',
		showOn: 'button',
		buttonImage: 'images/calendar.gif',
		buttonImageOnly: true
		});
</script>
