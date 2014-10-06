<?php
//get data
function dmy($ymd)
{
	if ($ymd !=NULL AND $ymd != '0000-00-00') {
	$y_m_d=explode("-",$ymd);
	$dmy=$y_m_d[2].'/'.$y_m_d[1].'/'.substr($y_m_d[0],2);
	return($dmy);
	}
}
function dmyyyy($ymd)
{
	if ($ymd !=NULL AND $ymd != '0000-00-00') {
	$y_m_d=explode("-",$ymd);
	$dmyyyy=$y_m_d[2].'/'.$y_m_d[1].'/'.$y_m_d[0];
	return($dmyyyy);
	}
}

$admid=$_GET["admid"];
$fields = "admdate, admward, consultant, admtype, reason, dischdate, dischdest";
$table = "admissiondata";
$where = "WHERE admission_id=$admid";
$sql= "SELECT $fields FROM $table $where LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
	$admdate=dmy($row["admdate"]);
	$admward=$row["admward"];
	$consultant=$row["consultant"];
	$reason=$row["reason"];
	$dischdate=dmy($row["dischdate"]);
	$dischdest=$row["dischdest"];
?>
<b>Admission Date:</b> <input type="text" size="14" name="admdate" value="<?php echo $admdate; ?>" />&nbsp; &nbsp;
<b>Admission Ward:</b> <input type="text" size="14" name="admward" value="<?php echo $admward; ?>" />&nbsp; &nbsp;
<b>Consultant:</b><input type="text" size="14" name="consultant" value="<?php echo $consultant; ?>" /><br>
<b>Discharge Date:</b> <input type="text" size="14" name="dischdate" value="<?php echo $dischdate; ?>" />&nbsp; &nbsp;
<b>Destination:</b> <input type="text" size="14" name="destination" value="<?php echo $dischdest; ?>" /><br>
<b>Reason for Admission:</b><br>
<textarea id="" name="reason" rows="3" cols="80" ><?php echo $reason; ?></textarea><br><br>
<b>Cause of Death (if applic):</b><br>
<textarea id="" name="deathcause" rows="3" cols="80" ></textarea><br><br>
