<?php
//Fri May 15 00:00:40 BST 2009
//get fieldset
$table="viroldata";
$tablezid="virolzid";
$fieldset = array(
'p*CMVAbStatus'=>'CMVAb status',
'd*CMVAbdate'=>'CMVAb date',
'p*EBVstatus'=>'EBV status',
'd*EBVdate'=>'EBV date',
'p*HBVsurfaceAbStatus'=>'HBVsurfaceAb status',
'd*HBVsurfaceAbdate'=>'HBVsurfaceAb date',
'p*HBVsurfaceAgStatus'=>'HBVsurfaceAg status',
'd*HBVsurfaceAgdate'=>'HBVsurfaceAg date',
'd*HBVboosterdate'=>'HBVbooster date',
'p*HBVcoreAbStatus'=>'HBVcoreAb status',
'd*HBVcoreAbdate'=>'HBVcoreAb date',
't*HBVlatestTitre'=>'HBVlatestTitre',
'd*HBVlatestTitredate'=>'HBVlatestTitre date',
'd*HBVvacc1date'=>'HBVvacc1 date',
'd*HBVvacc2date'=>'HBVvacc2 date',
'd*HBVvacc3date'=>'HBVvacc3 date',
'd*HBVvacc4date'=>'HBVvacc4 date',
'p*HCV_AbStatus'=>'HCV_Ab status',
'd*HCV_Abdate'=>'HCV_Ab date',
'p*HCV_RNAstatus'=>'HCV_RNA status',
'd*HCV_RNAdate'=>'HCV_RNA date',
'p*HIV_AbStatus'=>'HIV_Ab status',
'd*HIV_Abdate'=>'HIV_Ab date',
't*HIVviralload'=>'HIVviralload',
'd*HIVviralloaddate'=>'HIVviralload date',
't*HIV_CD4count'=>'HIV_CD4count',
'd*HIV_CD4countdate'=>'HIV_CD4count date',
'p*HTLVstatus'=>'HTLV status',
'd*HTLVdate'=>'HTLV date',
'p*HZVstatus'=>'HZV status',
'd*HZVdate'=>'HZV date',
't*virolNotes'=>'Virol Notes',
);
//set optionlists
$posneg='
<option>POSITIVE</option>
<option>NEGATIVE</option>
<option>UNKNOWN</option>';

//collate fields
$selectfields="";
$updatefields="virolmodifstamp=NOW()";
foreach ($fieldset as $key => $value) {
	$fielddata=explode('*',$key);
	$type=$fielddata[0];
	$field=$fielddata[1];
	$fieldvalue=$mysqli->real_escape_string($_POST["$field"]);
	if ($type=='d') {
		$fieldvalue=fixDate($fieldvalue);
	}
	$updatefields .= ", $field='$fieldvalue'";
	$selectfields .= ", $field";
}
//fix selectfields
$selectfields=substr($selectfields,2);
//echo "TEST SELECT: $selectfields <br>";
//if updated
if ($_GET['mode']=="update")
	{
	//update the table
	$sql= "UPDATE $table SET $updatefields WHERE $tablezid=$zid";
//	echo "$sql";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="$table data updated";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
} // end update IF
//refresh data
$sql= "SELECT * FROM $table WHERE $tablezid=$zid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
?>
<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=virology&amp;mode=update" method="post">
<fieldset>
<legend>Update Virology data</legend>
<table style="border: none; background-color: none;">
<tr><td valign="top">
<?php
//first col
$basket = array(
'p*HBVsurfaceAbStatus'=>'HBV surface Ab status',
'd*HBVsurfaceAbdate'=>'HBV surface Ab date',
'p*HBVsurfaceAgStatus'=>'HBV surface Ag status',
'd*HBVsurfaceAgdate'=>'HBV surface Ag date',
'd*HBVboosterdate'=>'HBV booster date',
'p*HBVcoreAbStatus'=>'HBV core Ab status',
'd*HBVcoreAbdate'=>'HBV core Ab date',
);
include '../fxns/runbasket.php';
?>
</td><td valign="top">
<?php
//first col
$basket = array(
't*HBVlatestTitre'=>'HBV latestTitre',
'd*HBVlatestTitredate'=>'HBV latestTitre date',
'd*HBVvacc1date'=>'HBV vacc1 date',
'd*HBVvacc2date'=>'HBV vacc2 date',
'd*HBVvacc3date'=>'HBV vacc3 date',
'd*HBVvacc4date'=>'HBV vacc4 date',
);
include '../fxns/runbasket.php';
?>
</td><td valign="top">
<?php
$basket = array(
'p*HIV_AbStatus'=>'HIV Ab status',
'd*HIV_Abdate'=>'HIV Ab date',
't*HIVviralload'=>'HIV viralload',
'd*HIVviralloaddate'=>'HIV viralload date',
't*HIV_CD4count'=>'HIV CD4count',
'd*HIV_CD4countdate'=>'HIV CD4count date',
);
include '../fxns/runbasket.php';
?>
</td><td valign="top">
<?php
$basket = array(
'p*HTLVstatus'=>'HTLV status',
'd*HTLVdate'=>'HTLV date',
'p*HZVstatus'=>'HZV status',
'd*HZVdate'=>'HZV date',
);
include '../fxns/runbasket.php';
?>
</td><td valign="top">
<?php
$basket = array(
'p*CMVAbStatus'=>'CMVAb status',
'd*CMVAbdate'=>'CMVAb date',
'p*EBVstatus'=>'EBV status',
'd*EBVdate'=>'EBV date',
'p*HCV_AbStatus'=>'HCV_Ab status',
'd*HCV_Abdate'=>'HCV_Ab date',
'p*HCV_RNAstatus'=>'HCV_RNA status',
'd*HCV_RNAdate'=>'HCV_RNA date',
);
include '../fxns/runbasket.php';
?>
</td></tr></table>
Notes: <textarea name="virolNotes" rows="4" cols="100"><?php echo $row["virolNotes"]; ?></textarea><br>
<input type="submit" style="color: green;" value="Update Virology Details" />
</fieldset>
</form>