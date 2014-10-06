<?php
//streamlining ----Sun 08 Dec 2013----URR, KTV
//----Mon 05 Nov 2012----table fixes
$sql= "SELECT hdsession_id FROM hdsessiondata WHERE hdsesszid=$zid";
$result = $mysqli->query($sql);
$totalnum = $result->num_rows;
$descr = "HD sessions recorded"; //for display with $num
$fields = "*, DATE_FORMAT(hdsessdate, '%a %d/%m/%y') as hdsessdate_ddmy";
$hdfflag = ($hdtype!="HD") ? TRUE : FALSE ;
//get data assume want most recent on top so DESC
$sql= "SELECT $fields FROM hdsessiondata WHERE hdsesszid=$zid ORDER BY hdsession_id DESC LIMIT 3";
$result = $mysqli->query($sql);
//for debugging
$recentnum = $result->num_rows;
echo "<p>There are <b>$totalnum HD sessions recorded</b> for this patient ($recentnum displayed).</p>";
echo '<table class="printlist">
<tr>
<th>date<br>site/type</th>
<th>access</th>
<th>time on<br>time off</th>
<th>Wt pre<br>Wt post <i>(change)</i></th>
<th>pulse pre<br>pulse post</th>
<th>BP pre<br>BP post</th>
<th>temp pre<br>temp post</th>
<th>BM pre<br>BM post</th>
<th>AP<br>VP</th>
<th>fluid removed<br>blood flow</th>
<th>UFR</th>
<th>URR<br>Kt/V</th>
<th>machineNo<br>litres proc</th>';
if ($hdfflag) {
    echo '<th>Subs<br>Fluid%</th>
    <th>Subs<br>Vol</th>
    <th>Subs<br>Rate</th>
    <th>Subs<br>Goal</th>';
}
echo '<th>signon<br>signoff</th>
<th>evaluation/notes</th>
</tr>';
$bg = '#fff';
$systpre=0;
$diastpre=0;
$systpost=0;
$diastpost=0;
$wtpre=0;
$wtpost=0;
$blankrowmid='<tr><td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>
<td class="bot">&nbsp;<br>&nbsp;</td>';
if ($hdfflag) {
    $blankrowmid.='<td class="bot">&nbsp;</td>
    <td class="bot">&nbsp;</td>
    <td class="bot">&nbsp;</td>
    <td class="bot">&nbsp;</td>';
}
$blankrowmid.='<td>&nbsp;<br>&nbsp;</td>
<td width="300">&nbsp;</td></tr>';
$blankrowbot='<tr><td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold">&nbsp;<br>&nbsp;</td>';
if ($hdfflag) {
    $blankrowbot.=
    '<td class="botbold">&nbsp;</td>
    <td class="botbold">&nbsp;</td>
    <td class="botbold">&nbsp;</td>
    <td class="botbold">&nbsp;</td>';
}
$blankrowbot.='<td class="botbold">&nbsp;<br>&nbsp;</td>
<td class="botbold" width="300">&nbsp;</td></tr>';
echo $blankrowmid . "\n";
echo $blankrowbot . "\n";
echo $blankrowmid . "\n";
echo $blankrowbot . "\n";
echo $blankrowmid . "\n";
echo $blankrowbot . "\n";
while ($row = $result->fetch_assoc())
	{
	$BPpre =  $row["syst_pre"] . "/" .  $row["diast_pre"];
	$BPpost =  $row["syst_post"] . "/" .  $row["diast_post"];
	$systpre += $row["syst_pre"];
	$diastpre += $row["diast_pre"];
	$systpost += $row["syst_post"];
	$diastpost += $row["diast_post"];
	$wtpre += $row["wt_pre"];
	$wtpost += $row["wt_post"];
	echo '<tr><td class="botbold">' . $row["hdsessdate_ddmy"] . '<br>' . $row["sitecode"] . '/'.$row["hdtype"].'</td>
<td class="botbold">' . $row["access"] . '</td>
<td class="botbold">' . $row["timeon"] . '<br>' . $row["timeoff"] . '</td>
<td class="botbold">' . $row["wt_pre"] . '<br>' . $row["wt_post"] . ' <i>(' . $row["weightchange"] . ')</i></td>
<td class="botbold">' . $row["pulse_pre"] . '<br>' . $row["pulse_post"] . '</td>
<td class="botbold">' . $BPpre . '<br>' . $BPpost . '</td>
<td class="botbold">' . $row["temp_pre"] . '<br>' . $row["temp_post"] . '</td>
<td class="botbold">' . $row["BM_pre"] . '<br>' . $row["BM_post"] . '</td>
<td class="botbold">' . $row["AP"] . '<br>' . $row["VP"] . '</td>
<td class="botbold">' . $row["fluidremoved"] . '<br>' . $row["bloodflow"] . '</td>
<td class="botbold">' . $row["UFR"] . '</td>
<td class="botbold">' . $row["machineURR"] . '<br>' . $row["machineKTV"] . '</td>
<td class="botbold">' . $row["machineNo"] . '<br>' . $row["litresproc"] . '</td>';
if ($hdfflag) {
	echo '<td class="botbold">' . $row["subsfluidpct"] . '</td>';
	echo '<td class="botbold">' . $row["subsvol"] . '</td>';
	echo '<td class="botbold">' . $row["subsrate"] . '</td>';
	echo '<td class="botbold">' . $row["subsgoal"] . '</td>';
}
echo '<td class="botbold">' . $row["signon"] . '<br>' . $row["signoff"] . '</td>
<td class="botbold" width="300">' . $row["evaluation"] . '</td></tr>';
	}
$systpre_avg=floor($systpre/$recentnum);
$diastpre_avg=floor($diastpre/$recentnum);
$systpost_avg=floor($systpost/$recentnum);
$diastpost_avg=floor($diastpost/$recentnum);
$wtpre_avg=floor($wtpre/$recentnum);
$wtpost_avg=floor($wtpost/$recentnum);
echo "</table>";
