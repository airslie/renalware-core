<?php
//orig from http://snipplr.com/view.php?codeview&id=4165
//Wed Nov 21 12:07:01 CET 2007 add fixdate to clean(), mysqli
function clean($value)
{
	if (get_magic_quotes_gpc())	$value = stripslashes($value);
	
	if (!is_numeric($value))	$value = mysql_real_escape_string($value);
	
	return $value;
}

array_walk($_GET,'clean');
array_walk($_POST,'clean');
//array_walk($_COOKIE,'clean');

/*
extract($_GET,EXTR_PREFIX_ALL,'get');
extract($_POST,EXTR_PREFIX_ALL,'post');
extract($_COOKIE,EXTR_PREFIX_ALL,'post');
*/
extract($_GET);
extract($_POST);
//extract($_COOKIE,EXTR_PREFIX_ALL,'post');

?>