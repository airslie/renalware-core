<?php
//----Fri 28 Feb 2014----episodestatus
//--Sat Dec 28 12:18:46 EST 2013--
//start page config
$thispage="view_episode";
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
require 'incl/aki_config.php';
require 'incl/aki_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
//show addr info
bs_Para("info",$pat_addr);
//navs and info
require "../bs3/incl/pat_navbars.php";
?>
<!-- Nav tabs -->
<ul class="nav nav-tabs">
  <li><a href="#home" data-toggle="tab">AKI Episode(s)</a></li>
  <li><a href="#clinsumm" data-toggle="tab">Clinical Summary</a></li>
</ul>
<!-- Tab panes -->
<div class="tab-content">
<div class="tab-pane active" id="home">
    <?php
            if ($_SESSION['successmsg']) {
                echo '<div class="alert alert-success">'.$_SESSION['successmsg'].'</div>';
        		unset($_SESSION['successmsg']);
            }
    ?>
<?php
//only if episode ID passed
if ($get_id) {
    $id=(int)$get_id;
    $subtitle= "View AKI Episode #$id";
    echo "<h3>$subtitle</h3>";
$sql = "SELECT * FROM akidata WHERE aki_id=$id";
$result = $mysqli->query($sql);
$akidata = $result->fetch_assoc();
foreach ($akidata as $key => $value) {
	$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
}
//start 3-col display
echo '<div class="container">
    <div class="row">';
//first col
echo '<div class="col-md-4">';
$showfields=array(
    // 'aki_id'=>'aki_id',
    // 'akistamp'=>'created',
    // 'akimodifdt'=>'updated',
    // 'akiuid'=>'UID',
    // 'akiuser'=>'User',
    // 'akizid'=>'ZID',
    // 'akiadddate'=>'added',
    // 'akimodifdate'=>'modified',
    'episodedate'=>'episode date',
    'episodestatus'=>'episode status',
    'referraldate'=>'referral date',
    'admissionmethod'=>'admission method',
    'elderlyscore'=>'elderly?',
    //'existingckdscore'=>'existing CKD?',
    'ckdstatus'=>'CKD Status?',
    'cardiacfailurescore'=>'cardiac failure?',
    'diabetesscore'=>'diabetes?',
    'liverdiseasescore'=>'liver disease?',
    'vasculardiseasescore'=>'vascular disease?',
    'nephrotoxicmedscore'=>'nephrotoxic meds?',
);
include 'incl/make_showfields.php';
//end first col
echo '</div>';
//2nd col
echo '<div class="col-md-4">';
$showfields=array(
    'akiriskscore'=>'AKI Risk Score',
    'cre_baseline'=>'Baseline CRE',
    'cre_peak'=>'Peak CRE',
    'egfr_baseline'=>'baseline eGFR',
    'urineoutput'=>'urine output',
    'urineblood'=>'urine blood',
    'urineprotein'=>'urine protein',
    'akinstage'=>'AKIN Score',
    'stopdiagnosis'=>'STOP diagnosis',
    'stopsubtype'=>'STOP subtype',
    'stopsubtypenotes'=>'STOP notes',
    'akicode'=>'AKI code',
);
include 'incl/make_showfields.php';
//end 2nd col
echo '</div>';
//3rd col
echo '<div class="col-md-4">';
$showfields=array(
    'ituflag'=>'ITU?',
    'itudate'=>'ITU date',
    'renalunitflag'=>'renal unit?',
    'renalunitdate'=>'renal unit date',
    'itustepdownflag'=>'ITU stepdown?',
    'rrtflag'=>'RRT in Renal Unit?',
    'rrttype'=>'RRT Type',
    'rrtduration'=>'RRT duration',
    'rrtnotes'=>'RRT descr',
    'mgtnotes'=>'Management Notes',
    'akioutcome'=>'Outcome',
    'ussflag'=>'USS?',
    'ussdate'=>'USS date',
    'ussnotes'=>'USS results',
    'biopsyflag'=>'biopsy?',
    'biopsydate'=>'biopsy date',
    'biopsynotes'=>'biopsy results',
    'otherix'=>'other Investigations',
    'akinotes'=>'AKI notes/comments',
);
include 'incl/make_showfields.php';
//end 2nd col
echo '</div>';

//end row, container
echo '</div>
    </div>';
echo '<a class="btn btn-primary btn-sm" href="aki/upd_episode.php?zid='.$zid.'&amp;id='.$id.'">Update Episode</a>';
} //end if get_id
//show all episodes for pat
$sql = "SELECT * FROM akidata WHERE akizid=$zid";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows>1) {
    echo '<h4>AKI episodes for this patient</h4>';
}
echo '<table class="table table-condensed table-bordered">
<thead><tr>
<th>Options</th>
<th>episode date</th>
<th>Status</th>
<th>AKI<br>Diagnosis</th>
<th>ITU<br>Adm?</th>
<th>Renal<br>Unit?</th>
<th>RRT On<br>Renal Unit?</th>
<th>Outcome</th>
</tr></thead>
<tbody>';
while($row = $result->fetch_assoc())
    {
    	$view = '<a href="aki/view_episode.php?ls=list_episodes&amp;zid='.$zid.'&amp;id='.$row["aki_id"].'">view #'.$row["aki_id"].'</a>';
        //get STOP :(
        //consider using str_replace and/or CSS to make b red
        switch ($akicode) {
            case 'S':
            $showdiag='<b>S</b>top<br>';
                break;
            case 'T':
            $showdiag='s<b>T</b>op<br>';
                break;
            case 'O':
            $showdiag='st<b>O</b>p<br>';
                break;
            case 'P':
            $showdiag='sto<b>P</b><br>';
                break;
        }
        $showdiag.=$row["stopdiagnosis"].':<br>'.$row["stopsubtype"];
        //urine
        $showurine=$row["urineblood"].' Blood<br>'.$row["urineprotein"].' Protein';
        $showstepdown = ($row["itustepdownflag"]=="Y") ? 'ITU Stepdown<br>' : '' ;
        $showrenalunit = ($row["renalunitflag"]=='Y') ? 'Yes<br>'.$showstepdown.dmy($row["renalunitdate"]) : $row["renalunitflag"];
        $showrrt = ($row["rrtflag"]=='Y') ? 'Yes<br>'.$row["rrtnotes"] : 'No' ;
    	echo '<tr>
        <td>'.$view. '</td>
        <td>' . dmy($row["episodedate"]) . '</td>
        <td>' . $row["episodestatus"] . '</td>
        <td>' . $showdiagn . '</td>
        <td>' . $row["ituflag"] . '</td>
        <td>' . $showrenalunit. '</td>
        <td>' . $showrrt . '</td>
        <td>' . $row["akioutcom"] . '</td>
    	</tr>';
    }
    echo '</tbody>
        </table>';
?>
</div>
<div class="tab-pane" id="clinsumm">
<?php
include '../bs3/incl/pat_clinsumm.php';
echo '<hr>';
include '../bs3/incl/pat_letters.php';
echo '<hr>';
include '../bs3/incl/pat_encounters.php';
?>
</div>
</div>
<?php
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
