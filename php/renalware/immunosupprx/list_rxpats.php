<?php
//--Mon Nov 25 10:44:00 EST 2013--
//start page config
$thispage="list_rxpats";
//include fxns and config
require 'req_fxnsconfig.php';
$pagetitle= $pagetitles["$thispage"];
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=true;
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/immunosupprx_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
//custom SQL format
$headers="KCH No,patient,age,sex,modality,Rx No,first Rx,latest Rx";
$sql="SELECT patzid, hospno1, concat(lastname,', ',firstnames) AS patient, age, sex,modalcode, COUNT(medsdata_id) AS rx_no, MIN(adddate) AS firstrxdate, MAX(adddate) AS latestrxdate FROM medsdata JOIN patientdata ON medzid=patzid WHERE medsdata.termflag=0 AND medsdata.immunosuppflag=1 GROUP BY patzid";
$listitems="patients";
$listnotes=""; //appears before "Last run"
$omitfields=array('patzid'); //do not appear in list cells
$listnotes.=" Click on headers to sort; search operates across all fields";
//------------END SET UP---------
include '../bs3/incl/make_customdatatable.php';
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
?>
<script type="text/javascript">
$(document).ready(function() {
	$('.datatable').dataTable({
		"sPaginationType": "bs_normal",
		"bPaginate": true,
		"bLengthChange": false,
		"bFilter": true,
		"aaSorting": [[ 1, "asc" ]],
		"iDisplayLength": 30,
        "aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 0 ] }
          ],
		"bSort": true,
		"bInfo": false,
		"bAutoWidth": true        
	});	
	$('.datatable').each(function(){
		var datatable = $(this);
		// SEARCH - Add the placeholder for Search and Turn this into in-line form control
		var search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input');
		search_input.attr('placeholder', 'Search');
		search_input.addClass('form-control input-sm');
		// LENGTH - Inline-Form control
		var length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_length] select');
		length_sel.addClass('form-control input-sm');
	});
});
</script>
