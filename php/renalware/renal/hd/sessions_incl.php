<?php 
//----Sun 08 Dec 2013----URR, KTV
//----Mon 25 Feb 2013----accesssitestatus
//get total no
$sql= "SELECT hdsession_id FROM hdsessiondata WHERE hdsesszid=$zid";
$result = $mysqli->query($sql);
$totalnum = $result->num_rows;
//LIMIT--get from parent page
$descr = "HD sessions recorded";
$fields = "*, DATE_FORMAT(hdsessdate, '%a %d/%b/%y') as hdsessdate_ddmy";
$table = "hdsessiondata";
$where="WHERE hdsesszid=$zid";
$order="ORDER BY hdsessdate DESC";
$limit="LIMIT $sesslimit";
$sql= "SELECT $fields FROM $table $where $order $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">There are $totalnum $descr for this patient ($numrows displayed).</p>";
echo '<table class="list">
<tr>
<th>date<br>site</th>
<th>access</th>
<th>time on<br>time off</th>
<th>wt_pre<br>wt_post <i>(change)</i></th>
<th>pulse pre<br>pulse post</th>
<th>BP pre<br>BP post</th>
<th>temp pre<br>temp post</th>
<th>BM pre<br>BM post</th>
<th>AP<br>VP</th>
<th>fluid removed<br>blood flow</th>
<th>UFR</th>
<th>URR<br>Kt/V</th>
<th>machineNo<br>litres proc</th>
<th>Subs <br>Fluid%</th>
<th>Subs <br>Vol</th>
<th>Subs <br>Rate</th>
<th>Subs <br>Goal</th>
<th>signon<br>signoff</th>
</tr>';
while ($row = $result->fetch_assoc())
	{
	$bg = ($bg=='#fff' ? '#cff' : '#fff');
	$BPpre =  $row["syst_pre"] . "/" .  $row["diast_pre"];
	$BPpost =  $row["syst_post"] . "/" .  $row["diast_post"];
	echo '<tr bgcolor="' . $bg . '">';
	echo '<td>' . $row["hdsessdate_ddmy"] . '<br>' . $row["sitecode"] . '</td>
<td>' . $row["access"] . '</td>
<td>' . $row["timeon"] . '<br>' . $row["timeoff"] . '</td>
<td>' . $row["wt_pre"] . '<br>' . $row["wt_post"] . ' <i>(' . $row["weightchange"] . ')</i></td>
<td>' . $row["pulse_pre"] . '<br>' . $row["pulse_post"] . '</td>
<td>' . $BPpre . '<br>' . $BPpost . '</td>
<td>' . $row["temp_pre"] . '<br>' . $row["temp_post"] . '</td>
<td>' . $row["BM_pre"] . '<br>' . $row["BM_post"] . '</td>
<td>' . $row["AP"] . '<br>' . $row["VP"] . '</td>
<td>' . $row["fluidremoved"] . '<br>' . $row["bloodflow"] . '</td>
<td>' . $row["UFR"] . '</td>
<td>' . $row["machineURR"] . '<br>' . $row["machineKTV"] . '</td>
<td>' . $row["machineNo"] . '<br>' . $row["litresproc"] . '</td>
<td>' . $row["subsfluidpct"] . '</td>
<td>' . $row["subsvol"] . '</td>
<td>' . $row["subsrate"] . '</td>
<td>' . $row["subsgoal"] . '</td>
<td>' . $row["signon"] . '<br>' . $row["signoff"] . '</td></tr>
<tr bgcolor="' . $bg . '"><td colspan="13"><i>notes:</i>' . $row["evaluation"] . '&nbsp;&nbsp;<i>Access Site Status:</i> '.$row["accesssitestatus"].'</td></tr>';
}
echo '</table>';
