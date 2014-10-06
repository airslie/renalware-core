<?php
//--Sun Dec 29 10:13:11 EST 2013--
//start page config
$thispage="list_akiconsults";
//include fxns and config
require 'req_fxnsconfig.php';
$pagetitle= $pagetitles["$thispage"];
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=true;
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/aki_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
//set tables incl JOINs
$table="consultdata JOIN patientdata ON consultzid=patzid JOIN akidata ON consult_id=consultid";
//set fields and preferred labels/headers
//use patzid to build options
$fieldslist=array(
	'consult_id'=>'ID',
	'aki_id'=>'aki ID',
	'patzid'=>'ZID',
	"concat(lastname,', ',firstnames)"=>'patient',
	"concat(consultsite,' ',othersite)"=>'Site',
	'sitehospno'=>'HospNo',
	'age'=>'age',
	'sex'=>'sex',
	'consultstaffname' => 'staff name',
	'consultmodal' => 'modal',
	'consultstartdate' => 'startdate',
	'consultenddate' => 'end date',
	'consulttype' => 'consult type',
	//'consultward' => 'consult ward',
);
$where="";
$omitfields=array('consult_id','patzid','aki_id');
$listitems="AKI consults";
$listnotes="Patients with the Consult AKI Risk marked Y have an AKI Episode created automatically";
//------------END SET UP---------
include 'incl/make_akiconsult-list.php';
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
