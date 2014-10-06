<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta name="application-name" content="Renalware SQL" />
	<meta name="author" content="Paul Nordstrom August" />
	<meta name="description" content="renal patient clinical database system" />
	<base href="<?php echo $rwareroot ?>/" />
	<title><?php echo $pagetitle; ?></title>
	<link rel="Shortcut Icon" href="images/rware.ico" type="image/x-icon" />	
		<link rel="stylesheet" href="jq/css/smoothness/jquery-ui.custom.css" />
		<link rel="stylesheet" href="jq/pnotify/jquery.pnotify.default.css" />
		<link rel="stylesheet" href="css/renalware.css" media="screen, print" />
		<script src="jq/js/jquery.min.js"></script>
		<script src="jq/js/jquery-ui.custom.min.js"></script>
		<script src="jq/pnotify/jquery.pnotify.min.js"></script>
		<script src="jq/js/jquery.metadata.js"></script>
		<script src="jq/js/jquery.quicksearch.js"></script>
		<script src="jq/js/jquery.inputhints.min.js"></script>
		<script src="jq/js/jquery.textPlaceholder.js"></script>
		<script src="jq/js/jquery.tablesorter.min.js"></script>
		<script src="jq/js/jquery.uiforms.js"></script>
<script>
	$(document).ready(function() {
		$("#uitabs").tabs();
		$("button, a",".buttonsdiv").button();
	    $("[placeholder]").textPlaceholder();
	    $('input[title]').inputHints();
	    $('form').uiforms();
		$("input:submit, button,.btn").button();
        $(".datepicker").datepicker({
            dateFormat: 'dd/mm/yy',
            showOn: 'button',
            buttonImage: 'images/calendar.gif',
            buttonImageOnly: true
            });
		$(".tablesorter").tablesorter({widthFixed: false})
		$("#tblsearch").quicksearch("#searchtbl tbody tr", {noResults: '#noresults',});
	    $("#accordion").accordion();
	  });
	function toggl(tid) {
		$('#'+tid).toggle();
	}
	function medPopup(url,title) {
	window.open(url, title, "status = 0, height = 600, width = 1000,left=100,top=100,menubar=0,scrollbars=1, resizable = 1" )
	}
</script>
</head>
<body>