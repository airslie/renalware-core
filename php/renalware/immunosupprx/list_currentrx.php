<?php
//--Sat Nov 23 11:24:48 EST 2013--
//start page config
$thispage="list_currentrx";
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
bs_Alert("warning","DEVELOPMENT NOTE: this may not be terribly useful, or we can change the filter e.g. 'last 12 months'");
//set tables incl JOINs
$table="medsdata JOIN patientdata ON medzid=patzid";
//set fields and preferred labels/headers
//use patzid to build options
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
//	'medmodal'=>'modal at Rx',
	'adddate'=>'started',
	'medsdata.adduser'=>'added by',
	"drugname"=>'drug name',
	"CONCAT(dose,' ',route,' ',freq)"=>'prescription',
//	'immunosuppdrugdelivery'=>'delivery?',
);
$where="WHERE medsdata.termflag=0 AND medsdata.immunosuppflag=1 AND medsdata.adddate>20091231";
$listnotes="Includes all currently prescribed immunosuppressants starting 1/1/2010."; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	"immunosupprx/view_pat.php?ls=$thispage" => "view", 
);
$omitfields=array('patzid','medsdata_id');
$listnotes.=" Click on headers to sort; search operates across all fields"; //appears before "Last run"
//------------END SET UP---------
include '../bs3/incl/make_bs3datatable.php';
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
