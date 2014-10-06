<?php
//----Fri 28 Feb 2014----formstatus
//--Sat Dec 28 12:18:46 EST 2013--
//start page config
$thispage="view_patforms";
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=false;
//include fxns and config
require 'req_fxnsconfig.php';
//get pat data
$zid=(int)$get_zid;
include '../data/patientdata.php';
include '../data/renaldata.php';
$pagetitle=$pat_ref;
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/sharedcare_config.php';
require 'incl/sharedcare_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
//show addr info
bs_Para("info",$pat_addr);
//navs and info
require "../bs3/incl/pat_navbars.php";
?>

<?php
    if ($_SESSION['successmsg']) {
        echo '<div class="alert alert-success">'.$_SESSION['successmsg'].'</div>';
		unset($_SESSION['successmsg']);
    }
?>
<?php
//show all forms for pat
$sql = "SELECT * FROM sharedcaredata WHERE sharedcarezid=$zid ORDER BY sharedcare_id DESC";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
    echo '<h4>' .$numrows . ' Shared Care forms for this patient. Latest form is highlighted. I=Interest; P=Participating; C=Completed</h4>';
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
    <tr><th colspan="2">&nbsp;</th>';
    for ($i=1; $i < 15; $i++) { 
        echo '<th colspan="3">Q '.$i. '</th>';
    }
    echo '</tr>
    <tr>
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
            $trclass = ($row["currentflag"]==1) ? 'success' : 'info' ;
        	echo '<tr class="'.$trclass.'">
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
/*
    echo '<hr>
    <h3>Key to Question Numbers</h3>
    <table class="table table-condensed">';
     $topicno=0;
        foreach ($questions as $qno => $question) {
            $topicno ++;
            echo '<tr><th>'.$topicno.'</th><td>'.$question.'</td></tr>';
        }
    echo '</table>';
    */
} else {
        bs_Alert("danger","No forms retrieved for this patient!");
}
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
