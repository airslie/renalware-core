<?php
//----Tue 15 Jul 2014----now uses INSERT IGNORE
//--Thu Feb 20 15:54:15 SGT 2014--
//start page config
$thispage="upload_repeatrxdata";
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=false;
//include fxns and config
require 'req_fxnsconfig.php';
$thisstage = ($get_stage) ? $get_stage : 'upload' ;
//get pat data
$pagetitle= "Upload Repeat Prescription Data (Evolution Import)";
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/immunosupprx_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
switch ($thisstage) {
    case 'upload':
    echo '<h3>Step 1: Cut-and-paste Excel Data</h3>';
    bs_Alert("warning","IMPORTANT: Please select only the Excel cells with data in them INCLUDING the headers row at the top of the spreadsheet.");
    echo '<form class="well" action="immunosupprx/upload_repeatrxdata.php?stage=preview" method="post">
	<label>Evolution Spreadsheet data (paste here):</label><br>
    <textarea name="exceldata" rows="100" cols="200"></textarea><br><br>
    <input type="submit" class="btn btn-success" name="upfile" value="Upload Data">&nbsp;&nbsp;<a class="btn btn-danger" href="immunosupprx/manage_repeatrx.php">Start Over</a>
</form>';
        break;
    case 'preview':
    echo '<h3>Step 2: Review Data Upload</h3>';
    if (isset($_POST['exceldata'])) {
    bs_Alert("success","Your spreadsheet data have been uploaded! Review the data below and then click Proceed or Start Over.");
    echo '<div class="progress">
          <div class="progress-bar" role="progressbar" aria-valuenow="33" aria-valuemin="0" aria-valuemax="100" style="width: 33%;"><span class="sr-only">33% Complete</span>
          </div>
        </div>';
        echo '<table class="table table-bordered table-striped table-condensed">
            <thead><tr>
        <th>Line No</th>
        <th>Evol ID</th>
        <th>First Name</th>
        <th>Surname</th>
        <th>DOB</th>
        <th>Prescriber</th>
        <th>Sched Next<br>Delivery Date</th>
        <th>Hospital</th>
        <th>Hosp No</th>
        <th>NHS No</th>
        <th>Patient Dx</th>
        </tr></thead>
        <tbody>';
        $rowno = 0;
        $postdata="";
        $rawdata = $mysqli->real_escape_string($_POST["exceldata"]);
       // echo "TEST: <br>$rawdata";
        $pipeddata=str_replace('\r\n',"|",$rawdata);
       // echo "TEST: <br>$pipeddata";
        $datarows=explode("|",$pipeddata);
        foreach ($datarows as $key => $thisrow) {
            $rowno++;
            if ($rowno>1) {
                //omit headers
                $data=explode("\t",$thisrow);
                $num = count($data);
                echo "<tr><th>$rowno</th>";
                $postdata.="$rowno";
                for ($c=0; $c < $num; $c++) {
                    $val = ($c==3 or $c==5) ? fixDate($data[$c]) : $data[$c] ;
                    echo '<td>'.$val.'</td>';
                    $postdata.=",$val";
                }
                echo '</tr>';
                $postdata.="|";
            }
        }
        echo '</tbody></table>';
        echo '<form action="immunosupprx/upload_repeatrxdata.php?stage=process" method="post">
 <input type="hidden" name="postdata" value="'.$postdata.'" id="postdata">
        <input type="submit" class="btn btn-success" name="proceed" value="Process Data">&nbsp;&nbsp;<a class="btn btn-danger" href="immunosupprx/upload_repeatrxdata.php">Start Over</a>
    </form>';
    } else {
        bs_Alert("danger","Oops! Something went wrong. Please go back and try again.");
        echo '<a class="btn btn-danger" href="immunosupprx/upload_repeatrxdata.php">Start Over</a>';
    }
        break;

    case 'process':
    echo '<h3>Step 3: File Processed</h3>';
    if (isset($_POST['postdata'])) {
    bs_Alert("success","The file has been processed.");
    echo '<div class="progress">
          <div class="progress-bar" role="progressbar" aria-valuenow="66" aria-valuemin="0" aria-valuemax="100" style="width: 66%;"><span class="sr-only">66% Complete</span>
          </div>
        </div>';
        //echo 'TEST<hr>'. $post_postdata .'<hr>';
        //insert into table
        $table="immunosupprepeatrxdata";
        $insertflds="importdate,importuid,importuser, rowno, evolution_id, firstname, surname, birthdate, prescriber, nextdelivdate, hospital, hospno, nhsno, patientdx";
        $values="";
        $postdatarows=explode("|",$post_postdata);
        foreach ($postdatarows as $datarow) {
            list($rowno, $evolution_id, $firstname, $surname, $birthdate, $prescriber, $nextdelivdate, $hospital, $hospno, $nhsno, $patientdx)=explode(",",$datarow);
            //check for actual row
            if ($rowno and $evolution_id) {
                $values.=",(CURDATE(),'$uid','$user',$rowno, $evolution_id, '$firstname', '$surname', '$birthdate', '$prescriber', '$nextdelivdate', '$hospital', '$hospno', '$nhsno', '$patientdx')";
            }
        }
        $values=substr($values,1);
        $sql="INSERT IGNORE INTO $table ($insertflds) VALUES $values";
        //echo "<hr>$sql</hr>";
        $result = $mysqli->query($sql);
        $numinserted=$mysqli->affected_rows;
        bs_Alert("info","$numinserted rows were processed.");
         echo '<a class="btn btn-success" href="immunosupprx/index.php">Main Menu</a>&nbsp;&nbsp;<a class="btn btn-danger" href="immunosupprx/upload_repeatrxdata.php">Start Over</a>';
    } else {
        bs_Alert("danger","Oops! Something went wrong. Please go back and try again.");
        echo '<a class="btn btn-danger" href="immunosupprx/upload_repeatrxdata.php">Start Over</a>';
    }
        break;
}

//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
