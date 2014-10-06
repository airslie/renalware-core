<?php
//----Wed 31 Jul 2013----LIMIT 500
include '../req/confcheckfxns.php';
$pagetitle= "$user&rsquo;s Letters &amp; Drafts";
include "$rwarepath/navs/topusernav.php";
?>
<form id="searchform" href="user/userletters.php" method="get" style="display: none;">
<fieldset><label>Search field:</label><br><input type="radio" name="srch" value="patname" checked="checked" />patient (e.g. "smith, j" or "smith, jane")* &nbsp; &nbsp; <input type="radio" name="srch" value="hospno" />Hosp No &nbsp; &nbsp; <input type="radio" name="srch" value="descr" />Description &nbsp;&nbsp;
<input type="text" name="srchtext" size="20" /><input type="submit" style="color: green;" value="Search My Letters" />
</fieldset></form>
<?php
$srchbutton='<button type="button" class="ui-state-default" onclick="$(\'#searchform\').toggle(\'slow\')">Search Letters</button>';
$limit=500;
$displaytext = "Recent letters &amp; drafts authored or typed by $user ($limit max listed)"; //default
$where = "WHERE typistid=$uid or authorid=$uid"; // default
$showall="";
if(isset($get_srch))
	{
		$showall='<a class="ui-state-default" style="color: green;" href="user/userletters.php">Show All</a>';
		$searchfield=$_GET['srch'];
		$srchtext=$_GET['srchtext'];
		switch ($searchfield) {
			case 'patname':
				$search = strtolower($srchtext);
				$where = "WHERE lower(patlastfirst) LIKE '$search%' AND (typistid=$uid or authorid=$uid)";
		$displaytext = "user letters about <b>$search</b> found";
				break;
			case 'descr':
				$search = strtolower($srchtext);
				$where = "WHERE lower(lettdescr) LIKE '%$search%' AND (typistid=$uid or authorid=$uid)";
		$displaytext = "user letter descriptions like <b>$search</b> found";
				break;
			case 'hospno':
				$search = strtoupper($srchtext);
				$where = "WHERE UPPER(letthospno) LIKE '$search%' AND (typistid=$uid or authorid=$uid)";
		$displaytext = "user letters for $search found";
				break;
		}
	}
$fields = "letter_id, letterzid, letthospno, lettuid, lettuser, lettmodifstamp, authorid, typistid, typistinits, letterdate, status, lettdescr, wordcount, concat(lastname, ', ', firstnames) as patlastfirst, authorlastfirst, recipname, recipient, patref, printstage, lettertype";
$tables = "letterdata LEFT JOIN patientdata on letterzid=patzid";
$orderby = "ORDER BY lettmodifstamp DESC";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	echo "<p class=\"header\">$numrows $displaytext. Click on headers to sort. $showall $srchbutton</p>";
	echo '<table class="tablesorter"><thead>
	<tr><th>HospNo</th>
	<th>patient</th>
	<th>date</th>
	<th>description <i>words</i></th>
	<th>edit/view</th>
	<th>author</th>
	<th>typist</th>
	<th>recipient (first 40 chars)</th>
	</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$printstage = $row['printstage'];
		$lettertype = $row['lettertype'];
		$descr = $row["lettdescr"] . ' <i>' . $row["wordcount"] . '</i>';
		$viewURL='letters/viewletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$printURL='letters/printletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$viewedit = '<a href="' . $printURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">view/print ARCHIVED</a>';
		$preview = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">preview</a>';
		if ( $printstage==1 )
		{
		$viewedit = '<a href="' . $printURL . '"  target="_blank" onclick="window.open(\'' . $printURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">print FINAL</a> for post or ' . $preview;	
		}
		if ( $status=="TYPED" )
		{
			$viewedit = '<a href="letters/editletter.php?zid=' . $row["letterzid"] . '&amp;letter_id=' . $row["letter_id"] . '">edit/review TYPED</a>';
		}
		if($status=="DRAFT")
			{
			$viewedit = '<a href="letters/editletter.php?zid=' . $row["letterzid"] . '&amp;letter_id=' . $row["letter_id"] . '">edit DRAFT</a> or ' . $preview;
			}
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["letterzid"] . '">' . $row["patlastfirst"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["letterzid"] . '">' . $row["letthospno"] . '</a>';
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["letterzid"] . '">' . $row["patlastfirst"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["letterzid"] . '">' . $row["letthospno"] . '</a>';
		$recip = '<acronym title="' . $row["recipient"] . '">' . $row['recipname'] . '</a>';
		$newpatletter = '<a href="letters/createletter.php?zid=' . $row["letterzid"] . '">new lttr</a>';
		$viewpatletters = '<a href="pat/patient.php?vw=letters&amp;zid=' . $row["letterzid"] . '">view lttrs</a>';
		$trclass= ($row["printstage"]==1)? "UNPRINTED" : $status;
		echo '<tr class="' . $trclass . '">
		<td>' . $adminlink . '</td>
		<td><b>' . $patlink . '</b> <i>' . $newpatletter . '</i></td>
		<td>' . dmy($row["letterdate"]) . '</td>
		<td>' . $descr . '</td>
		<td>' . $viewedit . '</td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $row["typistinits"] . '</td>
		<td>' . substr($row["recipient"], 0,40) . '</td>
		</tr>';
		}
	echo '</tbody></table>';
	}
// get footer
include '../parts/footer.php';
?>