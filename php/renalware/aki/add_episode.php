<?php
//--Sun Dec 29 12:17:58 EST 2013--
//start page config
$thispage="add_episode";
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
?>
<?php if (!$get_mode): ?>
 <div class="alert alert-info">Please enter either the NHS or Hospital Number or the patient name (e.g. &ldquo;Smith,J&rdquo;).</div>
<form action="aki/add_episode.php" method="get" accept-charset="utf-8" role="form">
<fieldset>
    <input type="hidden" name="mode" value="find" id="mode">
    <div class="form-group">
        <label for="findpat">Enter search phrase</label>
        <input type="text" class="form-control" id="findpat" name="findpat" placeholder="NHS or Hosp No, or Lastname,Init">
    </div>
      <input type="submit" class="btn btn-success" value="Find Patient">
</fieldset>
</form>
    
<?php endif ?>

<?php
//process search
if ($get_mode=="find" and $get_findpat) {
    $listitems="patients";
    $limit="";
    $searchstring=$_GET["findpat"];
    //fix "’" entry
    $searchstring=str_replace("’","'",$searchstring);
    //to fix e.g. "O'Donnell":
    $searchstringfix = $mysqli->real_escape_string($searchstring);
    $searchstring_lc = strtolower($searchstringfix); //nb hospno may be entered in lc as well
    	if(strstr($searchstring_lc,",")) //firstname entered and NOT hospno
    		{
    		$lastfirst = explode(",",$searchstring_lc);
    		$ln = trim($lastfirst[0]);
    		$fn = trim($lastfirst[1]);
    		$where = "WHERE LOWER(lastname) LIKE '$ln%' AND LOWER(firstnames) LIKE '$fn%'";
    		}
    	else
    		{
            $where="WHERE LOWER(hospno1) = '$searchstring_lc' OR LOWER(hospno2) = '$searchstring_lc' OR LOWER(hospno3) = '$searchstring_lc' OR LOWER(hospno4) = '$searchstring_lc' OR LOWER(hospno5) = '$searchstring_lc' OR nhsno='$searchstring_lc' OR LOWER(lastname) LIKE '$searchstring_lc%'";
    		}
    	$displaytext = "<b>$searchstring</b> matches";

    $fieldslist=array(
    	'patzid'=>'ZID',
    	"concat(lastname,', ',firstnames)"=>'patient',
    	'nhsno'=>"NHS No",
    	'hospno1'=>"$hosp1label",
    	'hospno2'=>"$hosp2label",
    	'hospno3'=>"$hosp3label",
    	'hospno4'=>"$hosp4label",
    	'hospno5'=>"$hosp5label",
    	'birthdate'=>'DOB',
    	'age'=>'age',
    	'sex'=>'sex',
    	"modalcode"=>'modality',
    );
    $omitfields=array('patzid');
    $table="patientdata";
    $fields = "patzid, hospno1,hospno2,hospno3,hospno4,hospno5,nhsno, lastname, firstnames, sex, birthdate, age, modalcode";
    $orderby="ORDER BY lastname, firstnames";
    $listnotes="";
    //scr optionlinks-- suggest first 2 at least
    $showsql=false;
    $fields="";
    $theaders="<th>options</th>";
    foreach ($fieldslist as $key => $value) {
    	$fields.=", $key";
    	if (!in_array($key,$omitfields)) {
    	$theaders.='<th>'.$value. "</th>\r";
    	}
    }
    //remove leading commas
    $fields=substr($fields,1);
    $sql = "SELECT $fields FROM $table $where $orderby";
    $result = $mysqli->query($sql);
    $numrows=$result->num_rows;
    if ($showsql) {
    	echo "<p class=\"alertsmall\">$sql</p>";
    }
    if ($numrows) {
    	showInfo("$numrows $listitems found","$listnotes");
    } else {
    	showAlert("No matching $listitems located!");
    }
}
if ($numrows) {
    echo '<table class="table table-bordered table-condensed">
	<thead><tr>'.$theaders.'</tr></thead>
	<tbody>';
	while($row = $result->fetch_assoc())
		{
		$zid=$row["patzid"];
		echo "<tr>";
		//options links
		echo '<td><a href="aki/run_addepisode.php?newzid='.$zid.'">Add episode</a></td>';
		foreach ($row as $key => $value) {
			if (!in_array($key,$omitfields)) {
				$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
				echo '<td>'.$tdval.'</td>';
			}
		}
		echo '</tr>';
		}
echo '</tbody>
</table>';
}
?>
<?php if ($get_mode=="find"): ?>
    <form class="well" action="aki/add_episode.php" method="get" accept-charset="utf-8" role="form">
        <fieldset>
        <input type="hidden" name="mode" value="find" id="mode">
        <div class="form-group">
            <label for="findpat">Modify search phrase if indicated</label>
            <input type="text" class="form-control" id="findpat" name="findpat" value="<?php echo $searchstring ?>">
        </div>
          <input type="submit" class="btn btn-error" value="Try Again">
    </fieldset>
    </form>
    
<?php endif ?>

<?php
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
