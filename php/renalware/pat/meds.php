<?php
//----Sun 07 Apr 2013----sorts fix
//----Mon 25 Feb 2013----esa class fix
//Thu May 14 22:56:20 BST 2009
?>
<div class="buttonsdiv">
        <a style="color: #333;" href="renal/renal.php?scr=esa&amp;zid=<?php echo $zid; ?>">View ESA Data</a>&nbsp;&nbsp;
        <a style="color: #333;" href="renal/renal.php?scr=immunosupp&amp;zid=<?php echo $zid; ?>">View Immunosuppression Data</a>&nbsp;&nbsp;
        <a style="color: green; background: white;" href="patmedsprint.php?zid=<?php echo $zid; ?>" >Print Meds Data</a>&nbsp;&nbsp;
</div>
<?php
$sort = ($_GET['sort']) ? $_GET['sort'] : "medsdata_id" ;
switch ($sort) {
    case 'adddate':
        $orderby="ORDER BY adddate";
        break;
    case 'drugname':
        $orderby="ORDER BY drugname,adddate";
        break;
        
    case 'medsdata_id':
        $orderby="ORDER BY medsdata_id";
        break;
}
$sql = "SELECT medsdata_id, drugname, dose, route, freq, drugnotes, adddate, medmodal, esdflag,immunosuppflag, modifstamp FROM medsdata WHERE medzid=$zid AND termflag=0 $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">Current Medications ($numrows)</p>";
?>
<table class="list">
<tr>
<th>prescription <i>(date added)</i> <a href="pat/patient.php?vw=meds&amp;zid=<?php echo $zid; ?>&amp;sort=drugname">sort by drug</a>&nbsp;&nbsp;<a href="pat/patient.php?vw=meds&amp;zid=<?php echo $zid; ?>&amp;sort=adddate">sort by date</a></th>
</tr>
<?php
while($row = $result->fetch_assoc())
	{
	$adddate=dmy($row["adddate"]);
	$class='';
	if ($row['esdflag']==1)
		{
		$class = 'esa'; //flag ESAs
		}
	if ($row['immunosuppflag']==1)
		{
		$class = 'immunosupp'; //flag immunosupps
		}
	$notes=FALSE;
	if ($row["drugnotes"]) {
		$notes="&nbsp;&nbsp;<font color=\"009933\"><i>" . $row["drugnotes"].'</i></font>';
	}
	echo '<tr><td class="'.$class.'"><b>' . $row['drugname'] . '</b> ' . $row['dose'] . ' ' . $row['route'] . ' ' . $row['freq'] . " <i>($adddate)</i>$notes" . '</td></tr>';
	}
    echo '</table>';
    //meds hx
include('incl/medshistportal.php');
