<?php
//Mon Dec 17 16:13:48 CET 2007
function makeslotradios($thisdayno, $slots, $currslot, $currdayno)
{
	$valuearray=explode(',',$slots);
	foreach ($valuearray as $key => $value) {
		$checked = ($currslot==$value and $thisdayno==$currdayno) ? ' "checked" ' : "" ;
		echo '<input type="radio" name="surgslot" value="'.$value.'"'.$checked.'/>'.$value.' '. $surgdayno.'&nbsp; &nbsp;';
	}
}
?>
<b>Monday:</b> <?php makeslotradios('2', '1,2,3,E', $surgslot, $surgdayno) ?> (E=Emergency) <br>
<b>Thursday:</b> <?php makeslotradios('5', '1,2,3,4',  $surgslot, $surgdayno) ?> (Dr Valenti&rsquo;s Vascular List) <br>
<b>Friday:</b> <?php makeslotradios('6', '1,2,3,4,5,6,7',  $surgslot, $surgdayno) ?> <br>
