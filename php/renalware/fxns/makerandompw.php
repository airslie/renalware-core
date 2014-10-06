<?php
//----Tue 03 Aug 2010----
$vocab=array(
	'monday',
	'tuesday',
	'wednesday',
	'thursday',
	'friday',
	'saturday',
	'sunday',
	'january',
	'february',
	'marchhare',
	'april',
	'mayday',
	'boxingday',
	'junebug',
	'romeoandjuly',
	'august',
	'september',
	'october',
	'november',
	'december',
	'newyearsday',
	);
$rand_key=array_rand($vocab,1);
$randomelement=$vocab[$rand_key];
$newpass=$randomelement;
$numset = "0123456789";
for ($i = 0; $i < 3; $i++)
{
   $newpass .= $numset[mt_rand(0, strlen($numset) - 1)];
}
?>