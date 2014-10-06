<?php
include 'operators_incl.php';
?>
<div id="listsearchdiv" style="display:none;padding:5px;">
	<form action="<?php echo "$baseurl"; ?>" method="get" accept-charset="utf-8">
		<input type="hidden" name="list" value="<?php echo $thislistcode ?>" id="thislist" />
		<fieldset>
			<legend>Search <?php echo $thislistname ?></legend>
			<select name="srchfld" id="srchfld">
				<?php
				foreach ($fieldslist as $fld => $fldname) {
					echo '<option value="'.$fld.'">'.$fldname.'</option>';
				}
				?>
			</select>
			<select name="oper">
			<?php echo $operoptions; ?>
			</select>
			<input type="text" name="srchval" size="20" id="srchval" /> [enter dates as YYYY-MM-DD] &nbsp;&nbsp;
			<input type="submit" style="color: green;" value="Continue &rarr;" />
		</fieldset>
	</form>
</div>
<?php
//if submitted
$searched=FALSE;
$showwhere="";
$urlappend="";
if ($get_srchfld) {
	$searched=TRUE;
	$sqlopers=array(
	'eq' => '=',
	'gt' => '>',
	'gte' => '>=',
	'lt' => '<',
	'lte' => '<=',
	'startswith' => 'startswith',
	'contains' => 'contains',
	'neq' => '!='
	);
	$valfix = $mysqli->real_escape_string($get_srchval);
	$sqlop=$sqlopers[$get_oper];
	$whereterm=$fieldslist[$get_srchfld]." $sqlop <b>'$valfix'</b>"; //for display
	//see if numeric
	if (is_numeric($valfix)) {
		$sqlwhereterm=$fieldslist[$get_srchfld]." $sqlop $valfix";
		$whereterm=$fieldslist[$get_srchfld]." $sqlop <b>$valfix</b>";		
		}
		else
		{
		$vallower=strtolower($valfix);
		$sqlwhereterm="LOWER($get_srchfld) $sqlop '$vallower'";
		}
	if ($get_oper=='contains') {
		//must be text
		$vallower=strtolower($valfix);
		$whereterm=$fieldslist[$get_srchfld]." CONTAINS <b>'$vallower'</b>";
		$sqlwhereterm="LOWER($get_srchfld) LIKE '%$vallower%'";
		}
	if ($get_oper=='startswith') {
		//must be text
		$vallower=strtolower($valfix);
		$whereterm=$fieldslist[$get_srchfld]." STARTS WITH <b>'$vallower'</b>";
		$sqlwhereterm="LOWER($get_srchfld) LIKE '$vallower%'";
		}
	//see if new or append to existing
	if ($where) {
		//already WHERE
		$where.=" AND $sqlwhereterm";
	} else
	{
	$where="WHERE $sqlwhereterm";
	}
	//for debugging
//	echo "NEW WHERE: $where <br>";
	$showwhere="WHERE $whereterm"; //for display in header
	$urlappend="&amp;srchfld=$get_srchfld&amp;oper=$get_oper&amp;srchval=$get_srchval";
}
?>