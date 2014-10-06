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
        <link rel="stylesheet" href="jq/datatables/css/demo_table.css" media="screen, print">
		<script src="jq/js/jquery.min.js"></script>
		<script src="jq/js/jquery-ui.custom.min.js"></script>
		<script src="jq/pnotify/jquery.pnotify.min.js"></script>
		<script src="jq/js/jquery.metadata.js"></script>
        <script src="jq/datatables/js/jquery.dataTables.min.js" type="text/javascript"></script>
        <script src="jq/datatables/js/jquery.dataTables.ukdate.js" type="text/javascript"></script>
        <!-- Note: standard datatable script now in ls/renderdatatable_incl -->
	<script>
		$(document).ready(function() {
			$("button, a",".buttonsdiv").button();
		} );
		function toggl(tid) {
			$('#'+tid).toggle();
		}
    	function medPopup(url,title) {
    	window.open(url, title, "status = 0, height = 600, width = 1000,left=100,top=100,menubar=0,scrollbars=1, resizable = 1" )
    	}
	</script>
</head>
<body>