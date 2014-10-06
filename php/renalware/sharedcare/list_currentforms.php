<?php
//--Tue Sep 30 16:03:26 EDT 2014--
$thispage="list_currentforms";
//include fxns and config
require 'req_fxnsconfig.php';
$pagetitle= $pagetitles["$thispage"];
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=true;
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/sharedcare_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
//set tables incl JOINs
$table="sharedcaredata JOIN patientdata ON sharedcarezid=patzid";
//set fields and preferred labels/headers
//use patzid to build options
$fieldslist=array(
  'sharedcare_id'=>'ID',
  'patzid'=>'ZID',
  'hospno1'=>'KCH No',
  "concat(lastname,', ',firstnames)"=>'patient',
  'age'=>'age',
  'sex'=>'sex',
  'modalcode'=>'modal',
  'sharedcaredate' => 'interview date',
  'sharedcareuser' => 'interviewer',
);
$where="WHERE currentflag=1";
$listnotes="Only the most recent form for each patient is displayed."; //appears before "Last run"
$omitfields=array('patzid');
$listnotes.=" Click on headers to sort; search operates across all fields"; //appears before "Last run"
//------------END SET UP---------
include 'incl/make_sharedcarelist.php';
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
