<?php
$updated="updated Wed Mar  7 15:04:08 CET 2007";
$monthno=$_GET['monthno'];
$yearno=$_GET['yyyy'];
//we have $searchday
$ymd = explode("-",$searchday);
$y=$ymd[0];
$m=$ymd[1];
//get first day, dayno
$sql="SELECT diarydate, dayno, monthname(diarydate) as mname, freeslots FROM diarydates WHERE MONTH(diarydate)=$m AND YEAR(diarydate)=$y LIMIT 1";
//$sql="SELECT diarydate, dayno, monthname(diarydate) as mname, freeslots FROM diarydates WHERE MONTH(diarydate)=$monthno AND YEAR(diarydate)=$yearno LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$firstdayno=$row["dayno"];
$mname=$row["mname"];
echo "<h4>$mname $yearno</h4>";
//set table
echo "<table border=\"0\">";
	echo "<tr>";
$weekdays = array( 'Sun','Mon','Tue', 'Wed','Thu','Fri','Sat');
foreach ($weekdays as $key => $value) {
	echo "<td>$value</td>";
}
echo "</tr>";
//set start
$colno=$firstdayno;
$blankdays=$firstdayno-1;
echo "<tr>";
for ($i=0; $i < $blankdays; $i++) { 
	echo "<td>*</td>";
}
$sql="SELECT diarydate, DAY(diarydate) as dday, dayno, openflag, freeslots FROM diarydates WHERE MONTH(diarydate)=$m AND YEAR(diarydate)=$y";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $result->fetch_assoc())
    {
$dday=$row["dday"];
$diarydate=$row["diarydate"];
$freeslots=$row["freeslots"];
$openflag=$row["openflag"];
$bg="#fff";
switch ($freeslots) {
	case '1':
		$bg="#ff6600";
		break;
	case '2':
		$bg="#FFCC00";
		break;
	case '3':
		$bg="#ffcc00";
		break;
	case '4':
		$bg="#ffff66";
		break;
	
	default:
		$bg="#fff";
		break;
}
$showdate='<font color="#333">' . $dday . '</font>';
if ($openflag==1) {
	$showdate='<a href="index.php?vw=glance&amp;scr=dayview&ymd=' . $diarydate . '">' . $dday . '</a>';
}
echo '<td bgcolor="' . $bg . '">' . $showdate . "</td>";
$colno++;
if ($colno==8)
	{
	echo "</tr>\n";
	$colno=1;
	echo "<tr>";
	}
}
echo "</table>";
