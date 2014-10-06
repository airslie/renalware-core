<?php
//--Tue Sep 30 16:39:04 EDT 2014--
//stub to hold questionnaire/form
$thispage="show_addform";
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
$pagetitle= "Enter Shared Care form data";
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/sharedcare_config.php';
require 'incl/sharedcare_nav.php';
include 'incl/sharedcare_options.php';
$showtoday=date("d/m/Y");
echo '<div class="container">';
echo "<h1>$pat_ref</h1>";
echo "<h3>$pagetitle</h3>";
//default
$currentflag=0;
//get current data if present
$sql = "SELECT * FROM sharedcaredata WHERE sharedcarezid=$zid AND currentflag=1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
    //use to populate form
    $sharedcaredata = $result->fetch_assoc();
    foreach ($sharedcaredata as $key => $value) {
    	$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
    }
    echo "<p>NOTE: This patient was last interviewed by $sharedcareuser on $shardcaredate.</p>";
    bs_Alert("info","Note: This patient was last interviewed by $sharedcareuser on $shardcaredate.");
    
} else {
    //first form for this patient
    bs_Alert("info","Note: This is the first interview to be recorded for this patient.");
}
?>
<form action="sharedcare/run_addform.php" method="post" accept-charset="utf-8">
    		<input type="hidden" name="sharedcarezid" value="<?php echo $zid ?>" />

        <div class="form-group">
          <label class="col-sm-2 control-label">Interview Date</label>
          <div class="col-sm-10">
              <input type="text" name="sharedcaredate" value="<?php echo $showtoday ?>" id="sharedcaredate">
          </div>
        </div>
        <br><br>
<table class="table table-bordered">
    <thead>
        <tr>
           <th>#</th>
           <th>Topic/Procedure</th>
           <th>Yes</th>
           <th>No</th>
           <th>Maybe</th>
           <th>Particip?</th>
           <th>Completed?</th>
           <th>Compl Date</th>
           <th>Compl By (inits)</th>
       </tr>
    </thead>
    <tbody>
    <?php
    $topicno=0;
    foreach ($questions as $qno => $question) {
        $topicno ++;
        echo '<tr><td>'.$topicno.'</td><td>'.$question.'</td>
            <td><input type="radio" name="'.$qno.'interest" value="Y"></td>
            <td><input type="radio" name="'.$qno.'interest" value="N"></td>
            <td><input type="radio" name="'.$qno.'interest" value="M"></td>
            <td><input type="checkbox" name="'.$qno.'participating" value="1"></td>
            <td><input type="checkbox" name="'.$qno.'completed" value="1"></td>
            <td><input type="text" name="'.$qno.'completed_date"></td>
            <td><input type="text" name="'.$qno.'completed_by"></td>
        </tr>';
    }
    ?>
</tbody>
</table>

    

    <input type="submit" class="btn btn-success btn-sm" value="Submit Shared Care form" /> or <a class="btn btn-danger btn-sm" href="sharedcare/add_form.php">Cancel</a>
</form>
<!--FORM GOES HERE -->
<!--
    TODO loop through eqch question and display radio buttons etc
-->
<?php
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
