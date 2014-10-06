<?php
//--Tue Sep 30 16:03:26 EDT 2014--
$thispage="list_current";
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
//show all forms for pat
$sql = "SELECT concat(lastname,', ',firstnames) as patient, hospno1, sharedcaredata.* FROM sharedcaredata JOIN patientdata ON patzid=sharedcarezid WHERE currentflag=1 ORDER BY sharedcare_id DESC";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
    echo '<h4>' .$numrows . ' current Shared Care forms. I=Interest; P=Participating; C=Completed</h4>';
}
//generate key
$keytext="Key to Question Nos: ";
$topicno=0;
    foreach ($questions as $qno => $question) {
        $topicno ++;
        $keytext.= '<strong>'.$topicno.'</strong>: '.$question.'; ';
    }
bs_Alert("info","$keytext");

echo '<table class="table table-condensed table-bordered">
<thead>
<tr><th colspan="4">&nbsp;</th>';
for ($i=1; $i < 15; $i++) { 
    echo '<th colspan="3">Q '.$i. '</th>';
}
echo '</tr>
<tr>
<th>Patient</th>
<th>Hospno</th>
<th>Interviewer</th>
<th>Date</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
<th>I</th>
<th>P</th>
<th>C</th>
</tr></thead>
<tbody>';
while($row = $result->fetch_assoc())
    {
      //  $trclass = ($row["currentflag"]==1) ? 'success' : 'info' ;
      echo '<tr>
<td><a href="sharedcare/view_patforms.php?ls='.$thispage.'&amp;zid='.$row["sharedcarezid"].'">' . $row["patient"] . '</td>
<td>' . $row["hospno1"] . '</td>
<td>' . $row["sharedcareuser"] . '</td>
<td>' . $row["sharedcaredate"] . '</td>
<td>' . $row["q1interest"] . '</td>
<td>' . $row["q1participating"] . '</td>
<td>' . $row["q1completed"] . '</td>
<td>' . $row["q2interest"] . '</td>
<td>' . $row["q2participating"] . '</td>
<td>' . $row["q2completed"] . '</td>
<td>' . $row["q3interest"] . '</td>
<td>' . $row["q3participating"] . '</td>
<td>' . $row["q3completed"] . '</td>
<td>' . $row["q4interest"] . '</td>
<td>' . $row["q4participating"] . '</td>
<td>' . $row["q4completed"] . '</td>
<td>' . $row["q5interest"] . '</td>
<td>' . $row["q5participating"] . '</td>
<td>' . $row["q5completed"] . '</td>
<td>' . $row["q6interest"] . '</td>
<td>' . $row["q6participating"] . '</td>
<td>' . $row["q6completed"] . '</td>
<td>' . $row["q7interest"] . '</td>
<td>' . $row["q7participating"] . '</td>
<td>' . $row["q7completed"] . '</td>
<td>' . $row["q8interest"] . '</td>
<td>' . $row["q8participating"] . '</td>
<td>' . $row["q8completed"] . '</td>
<td>' . $row["q9interest"] . '</td>
<td>' . $row["q9participating"] . '</td>
<td>' . $row["q9completed"] . '</td>
<td>' . $row["q10interest"] . '</td>
<td>' . $row["q10participating"] . '</td>
<td>' . $row["q10completed"] . '</td>
<td>' . $row["q11interest"] . '</td>
<td>' . $row["q11participating"] . '</td>
<td>' . $row["q11completed"] . '</td>
<td>' . $row["q12interest"] . '</td>
<td>' . $row["q12participating"] . '</td>
<td>' . $row["q12completed"] . '</td>
<td>' . $row["q13interest"] . '</td>
<td>' . $row["q13participating"] . '</td>
<td>' . $row["q13completed"] . '</td>
<td>' . $row["q14interest"] . '</td>
<td>' . $row["q14participating"] . '</td>
<td>' . $row["q14completed"] . '</td>
      </tr>';
    }
    echo '</tbody>
        </table>';

//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
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
