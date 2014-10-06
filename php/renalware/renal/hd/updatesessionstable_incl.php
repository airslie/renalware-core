<?php
//----Sun 08 Dec 2013----URR, KTV
//----Mon 25 Feb 2013----accesssitestatus
//created on 2009-05-12.
echo '<table class="list"><thead>
<tr>
<th>date<br>site</th>
<th>access site<br>inspection status</th>
<th>time on<br>time off</th>
<th>wt_pre<br>wt_post <i>(change)</i></th>
<th>pulse pre<br>pulse post</th>
<th>BP pre<br>BP post</th>
<th>temp pre<br>temp post</th>
<th>BM pre<br>BM post</th>
<th>AP<br>VP</th>
<th>fluid removal<br>blood flow</th>
<th>UFR</th>
<th>URR<br>Kt/V</th>
<th>machineNo<br>litres proc</th>
<th>Subs <br>Fluid%</th>
<th>Subs <br>Vol</th>
<th>Subs <br>Rate</th>
<th>Subs <br>Goal</th>
<th>signon<br>signoff</th>
</tr></thead>';
while ($row = $result->fetch_assoc())
	{
	$bg = ($bg=='#fff' ? '#ddd' : '#fff');
	$BPpre =  $row["syst_pre"] . "/" .  $row["diast_pre"];
	$BPpost =  $row["syst_post"] . "/" .  $row["diast_post"];
	$hdsession_id=$row["hdsession_id"];
	if ($row["submitflag"]!=1)
		{
		$bg="#ccf";
		//put $mode here to make flexible -- may be profile or sessions
		echo '<form action="renal/renal.php?zid=' . $zid . '&amp;scr=hdnav&amp;hdmode=' . $hdmode . '&amp;updatesess=' . $hdsession_id . '" method="post">
		<tr bgcolor="' . $bg . '">';
		echo '<td>' . $row["hdsessdate_ddmy"] . '<br>' . $row["sitecode"] . '</td>
		<td>' . $row["access"] . '<br>'.$row["accesssitestatus"].'</td>
	<td>' . $row["timeon"] . '<br><input type="text" name="timeoff" size="4" value="' . $row["timeoff"] . '" /></td>
	<td>' . $row["wt_pre"] . '<br><input type="text" name="wt_post" size="4" value="' . $row["wt_post"] . '" /></td>
	<td>' . $row["pulse_pre"] . '<br><input type="text" name="pulse_post" size="4" value="' . $row["pulse_post"] . '" /></td>
	<td>' . $BPpre . '<br><input type="text" name="BPpost" size="8" value="' . $BPpost . '" /></td>
	<td>' . $row["temp_pre"] . '<br><input type="text" name="temp_post" size="4" value="' . $row["temp_post"] . '" /></td>
	<td>' . $row["BM_pre"] . '<br><input type="text" name="BM_post" size="4" value="' . $row["BM_post"] . '" /></td>
	<td>' . $row["AP"] . '<br>' . $row["VP"] . '</td>
	<td>' . $row["fluidremoved"] . '<br>' . $row["bloodflow"] . '</td>
	<td>' . $row["UFR"] . '</td>
	<td>' . $row["machineURR"] . '<br>' . $row["machineKTV"] . '</td>
	<td>' . $row["machineNo"] . '<br><input type="text" name="litresproc" size="8" value="' . $row["litresproc"] . '" /></td>
	<td><input type="text" name="subsfluidpct" size="6" value="' . $row["subsfluidpct"] . '" /></td>
	<td><input type="text" name="subsvol" size="6" value="' . $row["subsvol"] . '" /></td>
	<td><input type="text" name="subsrate" size="6" value="' . $row["subsrate"] . '" /></td>
	<td><input type="text" name="subsgoal" size="6" value="' . $row["subsgoal"] . '" /></td>
	<td>' . $row["signon"] . '<br><input type="text" name="signoff" size="12" value="' . $row["signoff"] . '" /></td></tr>
	<tr bgcolor="' . $bg . '"><td colspan="17" style="border-bottom: 1px solid black;"><input type="text" name="evaluation" size="160" value="' . $row["evaluation"] . '" /></td>
	<td><input type="submit" style="color: green;" value="enter" /></td></tr></form></tr>';
		}
		else
		{
		echo '<tr bgcolor="' . $bg . '">';
		echo '<td>' . $row["hdsessdate_ddmy"] . '<br>' . $row["sitecode"] . '</td>
			<td>' . $row["access"] . '<br>'.$row["accesssitestatus"].'</td>
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
			<tr bgcolor="' . $bg . '"><td colspan="18" style="border-bottom: 1px solid black;"><i>notes:</i> ' . $row["evaluation"] .'</td></tr>';
		}
	}
	echo '</table>';
?>