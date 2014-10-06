<?php
//--Sun Dec  1 15:51:47 CET 2013--
//start page config
$thispage="manage_repeatrx";
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=false;
//include fxns and config
require 'req_fxnsconfig.php';
$thisstage = ($get_stage) ? $get_stage : 'upload' ;
//get pat data
$pagetitle= "Manage Repeat Prescriptions (Evolution Import)";
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/immunosupprx_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
switch ($thisstage) {
    case 'upload':
    echo '<h3>Step 1: Import CSV Data</h3>';
    bs_Alert("warning","IMPORTANT: Please save the Evolution spreadsheet file in .csv format first with an appropriate filename, e.g. &ldquo;Evolution_Sept2013.csv&rdquo;");
    
    echo '<form class="well" enctype="multipart/form-data" action="immunosupprx/manage_repeatrx.php?stage=preview" method="post">
	<label>Evolution Data File (CSV):</label><br>
    <input name="uploaded" type="file" maxlength="20" /><br>
    <input type="submit" class="btn btn-success" name="upfile" value="Upload File">&nbsp;&nbsp;<a class="btn btn-danger" href="immunosupprx/manage_repeatrx.php">Start Over</a>
</form>';
        break;

    case 'preview':
    echo '<h3>Step 2: Review Data Upload</h3>';
    if (isset($_POST['upfile'])) {
        ini_set("auto_detect_line_endings", true); //to handle Mac-style \r line endings prn
    bs_Alert("success","Your .CSV file has been uploaded! Review the data below and then click Proceed or Start Over.");
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
        $row = 0;
        $postdata="";
        if (($handle = fopen($_FILES["uploaded"]["tmp_name"], "r")) !== false) {
            while (($data = fgetcsv($handle, 200, ",")) !== false) {
                $row++;
                if ($row>1) {
                    //omit headers
                    $num = count($data);
                    echo "<tr><th>$row</th>";
                    $postdata.="$row";
                    for ($c=0; $c < $num; $c++) {
                        $val = ($c==3 or $c==5) ? fixDate($data[$c]) : $data[$c] ;
                        echo '<td>'.$val.'</td>';
                        $postdata.=",$val";
                    }
                    echo '</tr>';
                    $postdata.="|";
                }
            }
            fclose($handle);
        }
        echo '</tbody></table>';
        echo '<form action="immunosupprx/manage_repeatrx.php?stage=process" method="post">
 <input type="hidden" name="postdata" value="'.$postdata.'" id="postdata">
        <input type="submit" class="btn btn-success" name="proceed" value="Process Data">&nbsp;&nbsp;<a class="btn btn-danger" href="immunosupprx/manage_repeatrx.php">Start Over</a>
    </form>';
    } else {
        bs_Alert("danger","Oops! Something went wrong. Please go back and try again.");
        echo '<a class="btn btn-danger" href="immunosupprx/manage_repeatrx.php">Start Over</a>';
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
        $sql="INSERT INTO $table ($insertflds) VALUES $values";
        //echo "<hr>$sql</hr>";
        $result = $mysqli->query($sql);
        $numinserted=$mysqli->affected_rows;
        bs_Alert("info","$numinserted rows were processed.");
         echo '<a class="btn btn-success" href="immunosupprx/index.php">Main Menu</a>&nbsp;&nbsp;<a class="btn btn-danger" href="immunosupprx/manage_repeatrx.php">Start Over</a>';
    } else {
        bs_Alert("danger","Oops! Something went wrong. Please go back and try again.");
        echo '<a class="btn btn-danger" href="immunosupprx/manage_repeatrx.php">Start Over</a>';
    }
        break;
}

//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
