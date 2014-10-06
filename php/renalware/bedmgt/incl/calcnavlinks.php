<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$sql="SELECT $navkey FROM $navtable $where";
$result = $mysqli->query($sql);
$nr=$result->num_rows;
if ( $_GET['show']=='all' or $pp==0 )
{
	$pp=$nr;
}
$pnp=ceil($nr/$pp);
$pn=1;
if ( $_GET['cp'] )
{
	$pn=$_GET['cp'];
}
$sr = (($pn * $pp) - $pp);
/*
$nr = number of results
$pp = results per page ***0=show all***
$pnp = page navigation pages
$pn = current page
$url = base url to append navigation to
$sr = starting row
*/
