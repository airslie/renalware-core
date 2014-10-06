<?php
//hide main navbar if menu=hide
$win = (isset($get_win)) ? $get_win : FALSE ;
$menu = (isset($get_menu)) ? $get_menu : FALSE ;
if ($win=="new") {
	//only display if new window
	echo '<input type="button" class="ui-state-default" style="color: red;" value="Close Window" onclick="javascript:window.close();"/><br>';
}
if ($menu!="hide") {
	include '../navs/mainnav.php';
	}
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
include '../navs/patnavarray.php';
include '../navs/renalnav.php';
include '../navs/clinpathdiv.php' ;
include '../navs/allergiesdiv.php';
?>