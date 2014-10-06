<?php
//----Fri 28 Feb 2014----episodestatus
//--Sat Dec 28 14:14:52 EST 2013--
//start page config
$thispage="upd_episode";
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=false;
//include fxns and config
require 'req_fxnsconfig.php';
//get pat data
$zid=(int)$get_zid;
$id=(int)$get_id;
include '../data/patientdata.php';
include '../data/renaldata.php';
$pagetitle= "Update AKI Episode #$id";
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/aki_config.php';
require 'incl/aki_nav.php';
include 'incl/aki_options.php';

echo '<div class="container">';
echo "<h1>$pat_ref</h1>";
//show addr info
//bs_Para("info",$pat_addr);
//navs and info
//require "../bs3/incl/pat_navbars.php";
?>
<!-- Nav tabs -->
<h3><?php echo $pagetitle ?></h3>
<?php
$sql = "SELECT * FROM akidata WHERE aki_id=$id";
$result = $mysqli->query($sql);
$akidata = $result->fetch_assoc();
foreach ($akidata as $key => $value) {
	$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
}
 $akiupdmap1=array(
     'aki_id'=>'x^aki_id',
     'akistamp'=>'x^created',
     'akimodifdt'=>'x^updated',
     'akiuid'=>'x^UID',
     'akiuser'=>'x^User',
     'akizid'=>'x^ZID',
     'akiadddate'=>'x^added',
     'akimodifdate'=>'x^modified',
     'episodedate'=>'c^episode date',
     'episodestatus'=>'s^episode status',
     'referraldate'=>'c^referral date',
     'admissionmethod'=>'s^admission method',
     'elderlyscore'=>'n^elderly?',
     //'existingckdscore'=>'n^existing CKD?',
     'ckdstatus'=>'s^CKD Status?',
     'cardiacfailurescore'=>'n^cardiac failure?',
     'diabetesscore'=>'n^diabetes?',
     'liverdiseasescore'=>'n^liver disease?',
     'vasculardiseasescore'=>'n^vascular disease?',
     'nephrotoxicmedscore'=>'n^nephrotoxic meds?',
     'akiriskscore'=>'x^AKI Risk Score',
     'cre_baseline'=>'t5^Baseline CRE',
     'cre_peak'=>'t5^Peak CRE',
     'egfr_baseline'=>'t5^baseline eGFR',
     'urineoutput'=>'s^urine output',
     'urineblood'=>'s^urine blood',
     'urineprotein'=>'s^urine protein',
     'akinstage'=>'x^AKIN Score',
     'akicode'=>'s^STOP diagnosis',
);
 $akiupdmap2=array(
     'stopsubtypenotes'=>'t100^STOP notes',
     'ituflag'=>'f^ITU?',
     'itudate'=>'c^ITU date',
 	);
    $renalunitmap=array(
        'renalunitdate'=>'c^renal unit date',
        'itustepdownflag'=>'f^ITU stepdown?',
        'rrtflag'=>'f^RRT in Renal Unit?',
        'rrttype'=>'s^RRT Type',
        'rrtduration'=>'s^RRT duration',
        'rrtnotes'=>'t50^RRT descr',
    );
    $akiupdmap3=array(
        'mgtnotes'=>'a3x70^Management Notes',
        'akioutcome'=>'s^Outcome',
        'otherix'=>'a3x70^other Investigations',
        'akinotes'=>'a3x70^AKI notes/comments',
    	);
        $ussmap=array(
            'ussdate'=>'c^USS date',
            'ussnotes'=>'a6x70^USS results',
        );
    $biopsymap=array(
       'biopsydate'=>'c^biopsy date',
        'biopsynotes'=>'a6x70^biopsy results',
    );

    echo '<form class="form-horizontal" role="form" action="aki/run_updepisode.php" method="post" accept-charset="utf-8">
    		<input type="hidden" name="akizid" value="'.$zid.'" />
    		<input type="hidden" name="aki_id" value="'.$id.'" />
    		<fieldset>';
    $datamap=$akiupdmap1;
    include '../bs3/incl/makeupdfields_incl.php';
    ?>
    <!-- special for cascading select -->
    <div id="S" class="subtypeoptions">
        <div class="form-group">
          <label class="col-sm-2 control-label">STOP Subtype S</label>
          <div class="col-sm-10">
              <select name="stopsubtype"><option value="">Select (S) subtype...</option>
            <?php echo $s_options; ?>
            </select>
          </div>
        </div>
    </div>
    <div id="T" class="subtypeoptions">
        <div class="form-group">
          <label class="col-sm-2 control-label">STOP Subtype T</label>
          <div class="col-sm-10">
              <select name="stopsubtype"><option value="">Select (T) subtype...</option>
            <?php echo $t_options; ?>
            </select>
          </div>
        </div>
    </div>
    <div id="O" class="subtypeoptions">
        <div class="form-group">
          <label class="col-sm-2 control-label">STOP Subtype O</label>
          <div class="col-sm-10">
              <select name="stopsubtype"><option value="">Select (O) subtype...</option>
            <?php echo $o_options; ?>
            </select>
          </div>
        </div>
    </div>
    <div id="P" class="subtypeoptions">
        <div class="form-group">
          <label class="col-sm-2 control-label">STOP Subtype P</label>
          <div class="col-sm-10">
              <select name="stopsubtype"><option value="">Select (P) subtype...</option>
            <?php echo $p_options; ?>
            </select>
          </div>
        </div>
    </div>
<?php
$datamap=$akiupdmap2;
include '../bs3/incl/makeupdfields_incl.php';
//start renalunit div
$checked = ($renalunitflag=='Y') ? 'checked' : '' ;
echo '<div class="form-group">
  <div class="col-sm-offset-2 col-sm-10">
      <div class="checkbox">
          <label>
            <input type="checkbox" '.$checked. ' name="renalunitflag" id="renalunitflag" value="Y" onclick="$(\'#renalunitdiv\').toggle()"> Renal Unit Transfer?
          </label>
       </div>
  </div>
</div>';
$divdisplay = ($renalunitflag=='Y') ? 'display' : 'none' ;
echo '<div id="renalunitdiv" style="display:'.$divdisplay.'">';
$datamap=$renalunitmap;
include '../bs3/incl/makeupdfields_incl.php';
echo '</div>';
//start uss div
$checked = ($ussflag=='Y') ? 'checked' : '' ;
echo '<div class="form-group">
  <div class="col-sm-offset-2 col-sm-10">
      <div class="checkbox">
          <label>
            <input type="checkbox" '.$checked. ' name="ussflag" id="ussflag" value="Y" onclick="$(\'#ussdiv\').toggle()"> Ultrasound Scan?
          </label>
       </div>
  </div>
</div>';
$divdisplay = ($ussflag=='Y') ? 'display' : 'none' ;
echo '<div id="ussdiv" style="display:'.$divdisplay.'">';
$datamap=$ussmap;
include '../bs3/incl/makeupdfields_incl.php';
echo '</div>';
//start biopsy div
$checked = ($biopsyflag=='Y') ? 'checked' : '' ;
echo '<div class="form-group">
  <div class="col-sm-offset-2 col-sm-10">
      <div class="checkbox">
          <label>
            <input type="checkbox" '.$checked. ' name="biopsyflag" id="biopsyflag" value="Y" onclick="$(\'#biopsydiv\').toggle()"> Renal Biopsy?
          </label>
       </div>
  </div>
</div>';
$divdisplay = ($biopsyflag=='Y') ? 'display' : 'none' ;
echo '<div id="biopsydiv" style="display:'.$divdisplay.'">';
$datamap=$biopsymap;
include '../bs3/incl/makeupdfields_incl.php';
echo '</div>';
//others
$datamap=$akiupdmap3;
 include '../bs3/incl/makeupdfields_incl.php';
 ?>
 
<input type="submit" class="btn btn-success btn-sm" value="Update AKI episode" /> or <a class="btn btn-danger btn-sm" href="aki/view_episode.php?zid=<?php echo $zid ?>&amp;id=<?php echo $id ?>">Cancel Update</a>
</fieldset>
</form>
<?php
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
?>
<script type="text/javascript">
$(document).ready(function(){
    $('.subtypeoptions').hide();
  $('#akicode').change(function() {
      $('.subtypeoptions').hide();
      var subtypeval = $('#akicode').val();
      if (subtypeval=='S') {
          $('#S').show();
      };
      if (subtypeval=='T') {
          $('#T').show();
      };
      if (subtypeval=='O') {
          $('#O').show();
      };
      if (subtypeval=='P') {
          $('#P').show();
      };
      
 });
});
</script>
