<?php
//----Mon 06 Jan 2014---- now uses medsdata printflag
//--Tue Nov 26 15:29:30 EST 2013--
//start page config
$thispage="list_unprintedrx";
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
//for alert msgs
if ($_SESSION['runsuccess']) {
   bs_Alert("success",$_SESSION['runsuccess']);
//bs_Alert("success","your form was printed and logged.");
    unset($_SESSION['runsuccess']);
}
echo "<h1>$pagetitle</h1>";
bs_Alert("warning","IMPORTANT: a given patient may appear more than once. Printing a single new prescription will process all relevant drugs for that patient. Only last 30 days are displayed.");
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
    'adddate'=>'Rx date',
    "CONCAT(drugname,' ',dose,' ',route,' ',freq)"=>'prescription',
);
$where="WHERE printflag=0 AND DATEDIFF(CURDATE(),adddate)<31";
$listnotes="Includes unprinted Rx Forms starting $launchdate."; //appears before "Last run"
$listitems="records";
//scr optionlinks-- &zid=$zid will be appended
$optionlinks = array(
	"immunosupprx/sign_rxform.php?src=unprinted" => "sign Rx", 
);
$omitfields=array('logzid');
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
