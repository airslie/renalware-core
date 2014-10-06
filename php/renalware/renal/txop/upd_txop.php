<?php
//--Sun Mar 10 12:03:22 EDT 2013--
require '../../config_incl.php';
require '../../incl/check.php';
require '../../fxns/fxns.php';
//set mod
$thismod="txop";
require 'config_'.$thismod.'.php';
require 'options_'.$thismod.'.php';
//handle GET
$zid=(int)$get_zid;
$thisid=(int)$get_id;
${$thismod."_id"}=$thisid;
//get patientdata
include "$rwarepath/data/patientdata.php";
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/data/renaldata.php";
if ($esdflag) {
    include "$rwarepath/data/esddata.php";
	}
include "$rwarepath/data/currentclindata.php";
// ---------RUN SPECIAL PRN HERE -----------
//for future use
$successmsgs = array();
$errormsgs = array();
$infomsgs = array();
/// -----------END RUN SPECIAL --------------
include 'get_txop.php';
$pagetitle="Update $thismodlbl $thisid";
//get header with wrap, container divs incl
include "$rwarepath/parts/head_bsnonav.php";
//start p content
echo '<div class="row">
  <div class="span12">
  <h1><small>'.$pagetitle.'</small></h1>
  <p class="text-error patref">'.$patref_addr.'</p>';
  echo '<div class="alert">NOTE: this is a PROTOTYPE only and will need feedback and updating of links before going live.</div>';
  //display notifs prn
  foreach ($errormsgs as $msg) {
      echo '<div class="alert alert-danger">'.$msg.'</div>';
  }
// --------------config links and nav options
$viewurl="renal/$thismod/view_{$thismod}.php?zid=$zid&amp;id=$thisid"; //used in buttons and form action below
//$viewurl='renal/'.$thismod.'/view_'.$thismod.'.php?zid='.$zid.'&amp;id='.$get_id.'; //used in buttons and form action below
//start view navbar
echo '<p><a class="btn btn-danger btn-mini" href="'.$viewurl.'">Cancel--Return to '.$thismodlbl.'</a></p>';
//close top div
  echo '</div>
</div>';
// -------------- START CONTENT ---------------------
// --------------START 1 COLUMN ------------------
echo '<div class="row">'; // ---------start row
echo '<div class="span12">'; // ---------start 1st col
// ---------------CONFIGURE FORM ------------------
//nb config here to allow separate form designs e.g. per usertype
//form labels come from config_MOD.php fldmap
$thismap=$txop_map;
$formspecs = array(
'txop_id'=>'t^large',
'txopdate'=>'d',
'txopno'=>'t^small',
'txoptype'=>'s^txtype_options',
'patage'=>'t^small',
'lastdialdate'=>'d',
'donortype'=>'s^donortype_options',
'donorsex'=>'s^sex_options',
'donorbirthdate'=>'d',
'donorage'=>'t^small',
'donorweight'=>'t^small',
'donor_deathcause'=>'t^xxlarge',
'donorHLA'=>'t^xxlarge',
'HLAmismatch'=>'t^xxlarge',
'donorCMVstatus'=>'s^posnegunk_options',
'recipCMVstatus'=>'s^posnegunk_options',
'donor_bloodtype'=>'s^bloodtype_options',
'recip_bloodtype'=>'s^bloodtype_options',
'kidneyside'=>'t^large',
'kidney_asyst'=>'t^large',
'txsite'=>'t^large',
'kidney_age'=>'t^small',
'kidney_weight'=>'t^small',
'coldinfustime'=>'t^small',
'failureflag'=>'s^yn_options',
'failuredate'=>'d',
'failurecause'=>'t^large',
'failuredescr'=>'t^large',
'stentremovaldate'=>'d',
'graftfxn'=>'s^graftfxn_options',
'immunosuppneed'=>'t^large',
'dsa_date'=>'d',
'dsa_result'=>'s^posnegunk_options',
'dsa_notes'=>'a^2',
'bkv_date'=>'d',
'bkv_result'=>'s^posnegunk_options',
'bkv_notes'=>'a^2',
);

echo '<form class="form-horizontal" action="'.$viewurl.'" method="post" accept-charset="utf-8">';
echo '<fieldset>';
echo '<input type="hidden" name="run" value="upd'.$thismod.'" id="run">';
echo '<input type="hidden" name="primid" value="'.$thisid.'" id="primid">';
//-------script
foreach ($formspecs as $fld => $specs) {
	$fldlbl=$thismap["$fld"];
	$fldval = (${$fld}) ? ${$fld} : "" ;
    list($fldtype,$fldspecs)=explode("^",$specs);
	echo '<div class="control-group">
        <label class="control-label" for="'.$fld.'">'.$fldlbl.'</label>
    <div class="controls">';
	switch ($fldtype) {
		case 't':
			echo '<input type="text" name="'.$fld.'" id="'.$fld.'" value="'.$fldval.'" class="input-'.$fldspecs.'" autocomplete="off">';
			break;
		case 'd':
			echo '<input type="text" name="'.$fld.'" id="'.$fld.'" value="'.$fldval.'" class="datepicker span2">';
			break;
		case 'a':
			echo '<textarea class="span9" rows="'.$fldspecs.'" name="'.$fld.'" id="'.$fld.'">'.$fldval.'</textarea>';
			break;
		case 's':
			echo '<select name="'.$fld.'" id="'.$fld.'" >';
			if (isset($fldval)) {
				echo '<option value="'.$fldval.'">'.$fldval.'</option>';
			} else {
				echo '<option value="">Select...</option>';
			}
			echo ${$fldspecs};
			echo '</select>';
			break;
        }
    echo '</div>
</div>';
}
echo '<div class="form-actions">
  <button type="submit" class="btn btn-primary">Save changes</button>
  <button type="button" class="btn" onclick="location.href=\''.$viewurl.'\'">Cancel</button>
</div>
</fieldset>
</form>';
echo '</div>'; // ------- end 1 col
echo '</div>'; // ------- end this row
// --------------END 1 COLUMN ------------------


// -------------- END CONTENT ---------------------
include "$rwarepath/parts/footer_bs.php";
