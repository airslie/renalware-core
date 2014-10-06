<?php
if ($get_add==$addtype) {
 	include 'run/'.$addtype.'add.php';
 }
//toggle form here
echo '<div id="'.$addtype.'form" style="display:none;padding-top:0px;font-size: 10px;">';
include 'forms/'.$addtype.'form.html';
echo "</div>";
//end toggle form
$addmore='<button type="button" class="ui-state-default" style="color: green;"  onclick="$(\'#'.$addtype.'form\').toggle()">Add new '.$addtype.'</button>';
?>