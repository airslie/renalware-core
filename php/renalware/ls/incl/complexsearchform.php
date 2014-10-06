<?php
include 'operators_incl.php';
//prep non-date fields
$nondateoptions="";
foreach ($fieldslist as $key => $value) {
	if (strtolower(substr($key,-4))!="date") {
		$nondateoptions.='<option value="'.$key.'">'.$value.'</option>'."\r";
	}
}
$dateoptions="";
$datefieldcount=0;
foreach ($fieldslist as $key => $value) {
	if (strtolower(substr($key,-4))=="date") {
		$dateoptions.='<option value="'.$key.'">'.$value.'</option>'."\r";
		$datefieldcount+=1;
	}
}
?>
<div id="listsearchdiv">
	<form action="<?php echo "$baseurl"; ?>" method="get" accept-charset="utf-8">
		<input type="hidden" name="list" value="<?php echo $thislistgroupcode ?>search" id="thislist" />
		<fieldset>
			<legend>Search <?php echo $thissearchtitle ?></legend>
			(1)&nbsp;<select name="srchfld1" id="srchfld1">
				<option value="">Select first field...</option>
				<?php echo $nondateoptions; ?>
			</select>
			<select name="oper1">
			<?php echo $operoptions; ?>
			</select>
			<input type="text" name="srchval1" size="20" id="srchval1" /><br>
			<b>AND (optional)</b><br>
			(2)&nbsp;<select name="srchfld2" id="srchfld2">
				<option value="">Select second field...</option>
				<?php echo $nondateoptions; ?>
			</select>
			<select name="oper2">
			<?php echo $operoptions; ?>
			</select>
			<input type="text" name="srchval2" size="20" id="srchval2" /><br>
			<b>AND (optional)</b><br>
			(3) DATES <br>
			<select name="datefld1" id="datefld1">
			<option value="">Select first date field...</option>
			<?php echo $dateoptions; ?>
			</select>&nbsp;&nbsp;
			<select name="dateoper1">
			<?php echo $dateoperoptions; ?>
			</select> <input type="text" name="dateval1" class="datepicker" id="dateval1" />
			<?php if ($datefieldcount>1): ?>
				<select name="datefld2" id="datefld2">
				<option value="">Select second date field...</option>
				<?php echo $dateoptions; ?>
				</select>&nbsp;&nbsp;
				<select name="dateoper2">
				<?php echo $dateoperoptions; ?>
				</select> <input type="text" name="dateval2" class="datepicker" id="dateval2" />
			<?php endif ?>
			<input type="submit" style="color: green;" value="Perform Search" />
		</fieldset>
	</form>
</div>