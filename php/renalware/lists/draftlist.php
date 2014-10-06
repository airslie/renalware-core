<?php
include '../req/confcheckfxns.php';
$pagetitle= "$siteshort DRAFTS &amp; TYPED Listing";
include "$rwarepath/navs/topsimplenav.php";
//going to show all
$displaytext = " draft/typed renal letters at $siteshort"; //default
$showall = "";
$where = "WHERE archiveflag=0";  // default
if($_GET["authorid"])
	{
	$authorid = $_GET["authorid"];
	$sql= "SELECT authorsig FROM userdata WHERE uid=$authorid";
	$result = $mysqli->query($sql);
		$row = $result->fetch_assoc();
		$author=$row['authorsig'];
	$where .= " AND authorid =$authorid";
	$displaytext = "draft renal letters by <b>$author</b> found";
	$showall="<a href=\"draftlist.php\">Show All Drafts</a>";
	}
if($_GET["ltypeid"])
	{
	$ltypeid = $_GET["ltypeid"];
	$sql= "SELECT lettdescr FROM letterdescrlist WHERE lettertype_id=$ltypeid";
	$result = $mysqli->query($sql);
		$row = $result->fetch_assoc();
		$lettdescr=$row['lettdescr'];
	$where .= " AND lettertype_id=$ltypeid";
	$displaytext = "draft <b>$lettdescr</b> found";
	$showall="<a href=\"draftlist.php\">Show All Drafts</a>";
	}
if($_POST["lettdescr"])
	{
	$lettdescr = $_GET["lettdescr"];
	$where .= " AND lettdescr='$lettdescr";
	$q .= "lettdescr=" . urlencode($lettdescr) . "&amp;";
	$displaytext = "draft <b>$lettdescr</b> found";
	$showall="<a href=\"draftlist.php\">Show All Drafts</a>";
	}
if($_GET["patzid"])
	{
	$letterzid = $_GET["patzid"];
	$where .= " AND letterzid=$letterzid";
	$q .= "letterzid=$letterzid&amp;";
	$displaytext = "archived found";
	$showall="<a href=\"draftlist.php\">Show All Drafts</a>";
	}
$fields = "letter_id, letterzid, letthospno, typistinits, letterdate, lettertype, status, lettdescr, wordcount, patlastfirst, authorlastfirst, recipname, recipient, patref, printstage";
$tables = "letterdata";
$orderby = "ORDER BY letterdate DESC";
$sql= "SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	echo '<form class="tablesearch" action="#">
		<input type="text" name="tblsearch" title="Search by name, Hosp No, author..." size="80" value="" id="tblsearch" /> <a type="button" class="ui-state-default" href="lists/draftlist.php">Reload (after search)</a>
		</form>';
	echo "<p class=\"header\">$numrows $displaytext. Click on headers to sort.</p>";
	echo "<table class=\"tablesorter\" id=\"searchtbl\"><thead>
	<tr>
	<th>options</th>
<th>status</th>
<th>letterdate</th>
<th>author</th>
	<th>typist</th>
	<th>HospNo</th>
	<th>patient</th>
	<th>description <i>words</i></th>
	<th>recipient</th>
	</tr></thead><tbody>";
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$descr = $row["lettdescr"] . ' <i>' . $row["wordcount"] . '</i>';
		$viewURL='letters/viewletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$preview = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">preview</a>';
		$viewedit = '<a href="letters/editletter.php?zid=' . $row["letterzid"] . '&amp;letter_id=' . $row["letter_id"] . '">edit</a> or ' . $preview;
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["letterzid"] . '">' . $row["patlastfirst"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["letterzid"] . '">' . $row["letthospno"] . '</a>';
		$recip = '<acronym title="' . $row["recipient"] . '">' . $row['recipname'] . '</a>';
		$trclass= ($row["printstage"]==1)? "UNPRINTED" : $status;
		echo '<tr class="' . $trclass . '">
		<td>' . $viewedit . '</td>
		<td>' . $status . '</td>
		<td>' . dmy($row["letterdate"]) . '</td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $row["typistinits"] . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . $descr . '</td>
		<td>' . $recip . '</td>
		</tr>';
		}
		echo '</tbody>
		</table>';
		echo '<div id="noresults" style="display: none; padding: 3px; border: thin solid red; background: yellow;">Sorry, no matching results were found in the displayed data.</div>';
	}
	?>
	<script type="text/javascript">
	$('clearSearch').click(function(){
	   $('#tblsearch').attr('value','').trigger('keydown')
	});</script>
	<?php
 include '../parts/footer.php';
?>