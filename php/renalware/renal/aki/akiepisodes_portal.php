<?php
//--Mon Mar  4 14:07:23 EST 2013--
$orderby = "ORDER BY episodedate DESC";
$fields="aki_id,
referraldate,
akiriskscore,
cre_baseline,
cre_peak,
urineoutput,
urineblood,
urineprotein,
akinstage,
stopdiagnosis,
stopsubtype,
stopsubtypenotes,
akicode,
ituflag,
itudate,
renalunitflag,
renalunitdate,
itustepdownflag,
rrtflag,
rrtnotes,
akioutcome
";
$sql= "SELECT $fields FROM akidata WHERE akizid=$zid $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo '<table class="list" style="width: 900px;">
<tr>
<th>referral<br>date</th>
<th>baseline<br>CRE</th>
<th>peak adm<br>CRE</th>
<th>urine<br>output</th>
<th>risk<br>score</th>
<th>urine<br>dipstick</th>
<th>AKIN<br>Score</th>
<th>AKI<br>Diagnosis</th>
<th>ITU<br>Adm?</th>
<th>Renal<br>Unit?</th>
<th>RRT On<br>Renal Unit?</th>
<th>Outcome</th>
<th>Options</th>
</tr>';
while ($row = $result->fetch_assoc()) {
//	$update = '<a href="renal/aki/upd_episode.php?zid='.$zid.'&amp;aki_id='.$row["aki_id"].'">update</a>';
	$view = '<a href="renal/renal.php?zid='.$zid.'&amp;scr=aki&amp;mode=view_episode&amp;id='.$row["aki_id"].'">view/update</a>';
    //get STOP :(
    //consider using str_replace and/or CSS to make b red
    switch ($akicode) {
        case 'S':
        $showdiag='<b>S</b>top<br>';
            break;
        case 'T':
        $showdiag='s<b>T</b>op<br>';
            break;
        case 'O':
        $showdiag='st<b>O</b>p<br>';
            break;
        case 'P':
        $showdiag='sto<b>P</b><br>';
            break;
    }
    $showdiag.=$row["stopdiagnosis"].':<br>'.$row["stopsubtype"];
    //urine
    $showurine=$row["urineblood"].' Blood<br>'.$row["urineprotein"].' Protein';
    $showstepdown = ($row["itustepdownflag"]=="Y") ? 'ITU Stepdown<br>' : '' ;
    $showrenalunit = ($row["renalunitflag"]=='Y') ? 'Yes<br>'.$showstepdown.dmy($row["renalunitdate"]) : $row["renalunitflag"];
    $showrrt = ($row["rrtflag"]=='Y') ? 'Yes<br>'.$row["rrtnotes"] : 'No' ;
	echo '<tr>
    <td>' . dmy($row["referraldate"]) . '</td>
    <td>' . $row["cre_baseline"] . '</td>
    <td>' . $row["cre_peak"] . '</td>
    <td>' . $row["urineoutput"] . '</td>
    <td>' . $row["akiriskscore"] . '</td>
    <td>' . $row["akinstage"] . '</td>
    <td>' . $showurine . '</td>
    <td>' . $showdiagn . '</td>
    <td>' . $row["ituflag"] . '</td>
    <td>' . $showrenalunit. '</td>
    <td>' . $showrrt . '</td>
    <td>' . $row["akioutcom"] . '</td>
	<td>'.$view. '</td>
	</tr>';
}
echo '</table>';
