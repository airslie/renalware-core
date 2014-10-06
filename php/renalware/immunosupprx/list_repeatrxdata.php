<?php
//--Sun Dec  1 17:27:10 CET 2013--
//start page config
$thispage="list_repeatrxdata";
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
bs_Alert("info","This list mainly for development purposes. We may remove from the menu if not needed.");

//set tables incl JOINs
$table="immunosupprepeatrxdata";
//set fields and preferred labels/headers
//use patzid to build options
$fieldslist=array(
    'importstamp'=>'imported',
//    'importuid'=>'importuid',
//    'importuser'=>'import user',
 //   'rowno'=>'row no',
    'evolution_id'=>'Evolution ID',
    'firstname'=>'first name',
    'surname'=>'surname',
    'birthdate'=>'birth date',
    'prescriber'=>'prescriber',
    'nextdelivdate'=>'next deliv date',
//    'hospital'=>'hospital',
    'hospno'=>'hosp No',
//    'nhsno'=>'nhsno',
    'patientdx'=>'Patient Dx',
//    'runflag'=>'printed flag',
//    'runuid'=>'runuid',
    'runuser'=>'print user',
    'rundt'=>'printed',
);
$where="";
$listnotes="Includes imported Evolution data (CSV) starting $launchdate."; //appears before "Last run"
$listitems="records";
$omitfields=array();
$listnotes.=" Click on headers to sort; search operates across all fields"; //appears before "Last run"
//------------END SET UP---------
include '../bs3/incl/make_bs3datatable_optionless.php';
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
