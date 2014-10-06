<?php
makeInfo("NEW",'Try <a href="pat/patient.php?vw=letterindex&amp;zid='.$zid.'">new archived letters portal for this patient</a> with improved view/toggle options.');
//get distinct letterdescr
$lettlist="<option value=\"\">Select from $title $lastname&rsquo;s letters</option>\n";
$sql="SELECT lettdescr, count(letter_id) as lettcount FROM letterdata WHERE letterzid=$zid GROUP BY lettdescr";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $result->fetch_assoc())
	{
	$lettlist.= '<option value="'.$row["0"].'">'. $row["0"]. ' ['.$row["1"]."]</option>\n";
	}
$result->close();
?>
<?php if ($numtotal>0): ?>
<form action="pat/patient.php" method="get">
<input type="hidden" name="vw" value="letters" id="vw" />
<input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
<fieldset>	
<select name="lettdescr"><?php echo $lettlist; ?></select>&nbsp;&nbsp;
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
include( '../portals/lettersportal.php' );
?>