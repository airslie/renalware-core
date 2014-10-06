<?php
include '../req/confcheckfxns.php';
$vw=$_POST["vw"];
$searchquery=$_POST["searchquery"];
$searchq=$_POST["searchq"];
$searchwhere=$_POST["searchwhere"];
$pagetitle= $vw . " Search Results";

//get header
include '../parts/head.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
echo '<small><a href="javascript:window.close();">close this window.</a></small>';
//--------Page Content Here----------
?>
<br>
<?php
//get hdlist *for sched*
$q=$searchq;
$limit = 25; // How many results should be shown at a time
$scroll = '1'; // How many elements to the record bar are shown at a time
$xnav_sql = "SELECT renalzid FROM renaldata $searchware";
$xnavresult = $mysqli->query($xnav_sql);
$numtotal=$xnavresult->num_rows;
include('../navs/xnavstartasc.php');
$sql= $searchquery;
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"alertsmall\">$numtotal relevant Patients found; $numrows displayed. &nbsp;";
include "$rwarepath/navs/xnavbar.php";
?>
</p>
<table cellpadding="5">
	<tr>
		<td valign="top">
			<?php
			echo '<table class="portal">';
			while ($row = $result->fetch_assoc())
				{
				$zid = $row["hdpatzid"];
				$showage = '<i>(' . $row["age"] . ')</i>';
				$patlink = '<a href="renal/screenresults.php?vw=' . $vw . '&show=' . $display . '&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
				echo "<tr>
				<td>$patlink " . $row["sex"] . " $showage</td>
				</tr>";
				}
			echo '</table>';
			?>
		</td>
		<td valign="top">
		<?php
		//if patient is selected...
		if ( $_GET["zid"] )
		{
			$zid=$_GET["zid"];
			$vw=$_GET["vw"];
			include ('../renal/' . $vw . '.php');
		}
		?>
		</td>
	</tr>
</table>
<?php
include '../parts/footer.php';
?>