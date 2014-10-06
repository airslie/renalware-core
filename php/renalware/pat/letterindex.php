<?php
//get distinct letterdescr

$sql="SELECT lettdescr_id, lettdescr, count(letterindex_id) as lettcount FROM letterindex WHERE letterzid=$zid GROUP BY lettdescr_id ORDER BY lettdescr";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
?>
<?php if ($numrows): ?>
<form action="pat/patient.php" method="get">
<input type="hidden" name="vw" value="letterindex" id="vw" />
<input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
<fieldset>	
<select name="lettdescr_id">
<option value="">Select from <?php echo "$title $lastname&rsquo;s letters"; ?></option>
<?php
while($row = $result->fetch_array(MYSQLI_NUM))
	{
	echo '<option value="'.$row["0"].'">'. $row["1"]. ' ['.$row["2"]."]</option>\n";
	}
$result->close();
?>
</select>&nbsp;&nbsp;
Show <b><?php echo $user ?></b>&rsquo;s letters only? <input type="radio" name="uidflag" value="no" checked="checked" />no &nbsp; &nbsp; <input type="radio" name="uidflag" value="yes" />yes
<input type="submit" style="color: green;" value="Display selected letters" /></fieldset>
</form>
<?php endif ?>

<?php
$portallimit=500;
if ( $_GET['show']=='all' )
{
	$show='all'; //for override
}
include( '../portals/letterindexportal.php' );
?>