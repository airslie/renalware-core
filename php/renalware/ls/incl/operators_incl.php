<?php
$opers=array(
'eq' => 'equals',
'startswith' => 'starts w/ (text only)',
'contains' => 'contains (text only)',
'gt' => '&gt;',
'gte' => '&ge;',
'lt' => '&lt;',
'lte' => '&le;',
'neq' => '&ne;'
);
$operoptions="";
foreach ($opers as $key => $value) {
//	$htmlop=htmlentities($value);
	$operoptions .= '<option value="'.$key.'">' . $value . "</option>\n";
	}
$dateopers=array(
'eq' => 'is',
'gt' => 'is after',
'lt' => 'is before',
);
$dateoperoptions="";
foreach ($dateopers as $key => $value) {
	$dateoperoptions .= '<option value="'.$key.'">' . $value . "</option>\n";
	}
?>
