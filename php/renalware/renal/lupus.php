<?php
//----Sun 07 Apr 2013----C3 etc special OBX path display latest only
//----Sat 09 Mar 2013----layout rearrangement per Andi punchlist
//----Fri 09 Nov 2012----enatypes and special path portal
//----Mon 05 Nov 2012----metadata tweaks and optionlists
//----Fri 02 Nov 2012----form tweaks
include "$rwarepath/optionlists/lupus_options.php";
//--Thu Nov  1 14:12:56 CET 2012--
//if lupusdata updated
if ($_GET['mode']=="updlupusdata")
	{
	$updatefields="lupusmodifdt=NOW(),lupusmodifdate=CURDATE()";
	foreach ($_POST as $field => $value) {
		$fieldvalue=$mysqli->real_escape_string($value);
		${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
		$updatefields .= ", $field='${$field}'";
	}	
	//update the table
	$sql= "UPDATE lupusdata SET $updatefields WHERE lupuszid=$zid";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Lupus data updated";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
} // end update IF
//start insert biopsy
if ($_GET['mode']=="addlupusbx")
	{
	foreach ($_POST as $field => $value) {
		$fieldvalue=$mysqli->real_escape_string($value);
		${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
	}
	//update the lupus table
	$sql= "UPDATE lupusdata SET lupusmodifdt=NOW(),lastbxdate='$lupusbxdate' WHERE lupuszid=$zid";
	$result = $mysqli->query($sql);
	//insert into data
	$table="lupusbxdata";
	$insertfields="lupusbxzid, lupusbxuid, lupusbxuser,lupusbxadddate, lupusbxdate, lupusbxclass, activityindex, chronicityindex,lupusbxnotes";
	$insertvalues="$zid, $uid, '$user', CURDATE(),'$lupusbxdate', '$lupusbxclass', '$activityindex', '$chronicityindex', '$lupusbxnotes'";
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Lupus Biopsy added ($lupusbxdate)";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
} // end add IF
//refresh data
include "$rwarepath/data/lupusdata.php";
echo '<div id="uitabs">
	<ul>
		<li><a href="#lupusinfodiv">Lupus Overview</a></li>
		<li><a href="#updlupusformdiv">Update Profile</a></li>
		<li><a href="#lupusbxformdiv">Add Lupus Biopsy</a></li>
	</ul>
	<div id="lupusinfodiv">
	    <div id="lupusprofilediv" style="width: 50%; float: left;">
        <h3>Lupus Profile</h3>
		    <ul class="portal">
            <li><b>Diagnosed:</b>&nbsp;&nbsp;'.$lupusdxdate.' <b>Date Added:</b> '.$lupusadddate.' <b>Date Modif</b>: '.$lupusmodifdate.'</li>
			<li><b>ANA Titre:</b> '.$anatitre_dx.' <b>Titre Date:</b> '.$anatitre_dxdate.'</li>
			<li><b>DS DNA Dx:</b> '.$dsdna_dx.' <b>DS DNA Date:</b> '.$dsdna_dxdate.'</li>
			<li><b>ENA:</b> ';
            //$enatypes in lupus_options.php
            foreach ($enatypes as $fld => $lbl) {
                echo "<b>$lbl</b> ${$fld}&nbsp;&nbsp;";
            }
            echo '</li>
			<li><b>Anti-cardiolipin Ab:</b> '.$anticardiolipin.' <b>Last Biopsy:</b> '.$lastbxdate.'</li>
			<li><b>Notes:</b><br> '.nl2br($lupusnotes).'</li>
		    </ul>
        </div>
		<div id="biopsies_specialpath" style="width: 50%; float: left;">
		<h3>Lupus Biopsies</h3>';
        //get bxdata
        $sql = "SELECT * FROM lupusbxdata WHERE lupusbxzid=$zid ORDER BY lupusbx_id DESC";
        $result = $mysqli->query($sql);
        $numrows=$result->num_rows;
        if (!$numrows)
        	{
        	echo "<p class=\"headergray\">There are no recorded lupus biopsies.</p>";
        	}
        else
        	{
        	echo '<p class="header">'.$numrows .' biopsies displayed</p>
        	<table class="list">
        	<tr><th>Bx Date</th>
        	<th>Class</th>
        	<th>Activity</th>
        	<th>Chronicity</th>
        	<th>Notes</th>
        	</tr>';
        	while($row = $result->fetch_assoc()) {
        		echo "<tr>
        		<td>" . dmy($row["lupusbxdate"]) . "</td>
        		<td>" . $row["lupusbxclass"] . "</td>
        		<td>" . $row["activityindex"] . "</td>
        		<td>" . $row["chronicityindex"] . "</td>
        		<td>" . $row["lupusbxnotes"] . "</td>
        		</tr>";
        		}
        		echo "</table>";
        	}
            // //special Pathol
            // echo '<h3>Special Pathology: C3, C4, DS-DNA, ANA (Max 12)</h3>';
            // //from obx
            // $sql = "SELECT * FROM hl7data.pathol_obxdata WHERE obpid='$hospno1' AND obxcode IN ('C3','C4','DNA','ANA') ORDER BY obx_id DESC LIMIT 12";
            // $result = $mysqli->query($sql);
            // $numrows=$result->num_rows;
            // if ($numrows) {
            //     echo "<p class=\"header\">$numrows displayed</p>
            //         <table class=\"list\">
            //         <tr>
            //         <th>Code</th>
            //         <th>Date</th>
            //         <th>Result</th>
            //         </tr>";
            //     while($row = $result->fetch_assoc())
            //         {
            //         echo '<tr>
            //         <td>' . $row['obxcode'] . '</td>
            //         <td>' . dmy($row['obxdate']) . '</td>
            //         <td>' . $row['obxresult'] . '</td>
            //         </tr>';
            //         }
            //     echo '</table>';
            // } else {
            //     echo "<p class=\"headergray\">No such results located.</p>";
            // }
            
echo '</div>
<div class="clear"><br>
<h3>Pathology</h3>';
//----Sun 07 Apr 2013----show special results here
echo '<ul class="portal">
            <li>';
$desiredobx = array('C3','C4','DNA','ANA');
foreach ($desiredobx as $obxcode) {
    //get latest
     $sql = "SELECT obxdate,obxresult FROM hl7data.pathol_obxdata WHERE obxpid='$hospno1' AND obxcode='$obxcode' ORDER BY obx_id DESC LIMIT 1";
     $result = $mysqli->query($sql);
     $row = $result->fetch_assoc();
     //fix date and display prn
     $showdmy = ($row["obxdate"]) ? ' ('.dmyyyy($row["obxdate"]).')' : '' ;
     //display in single <li>
    echo "<b>Latest $obxcode:</b> ".$row["obxresult"].$showdmy.'&nbsp;&nbsp;&nbsp;';
}
echo '</li></ul>';
$portallimit=6;
include "$rwarepath/pathology/lupus_pathresults.php";
echo '</div>';
//letters portal
echo '<div class="clear"><br>
<h3>Recent Letters</h3>';
$portallimit=10;
include '../portals/lettersportal.php';
echo '</div>';
//start Immunosuppr
echo '<div class="clear"><br>
<h3>Immunosuppressant History</h3>';
//get immunosupps
$sql = "SELECT medsdata_id, drugname, dose, route, freq,drugnotes, adddate, termdate, medmodal, modifstamp FROM medsdata WHERE medzid=$zid AND immunosuppflag=1 ORDER BY drugname, adddate";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	echo "<p class=\"header\">Recorded Immunosuppressant History ($numrows prescriptions; yellow=current) </p>
		<table class=\"list\">
		<tr>
		<th>drug</th>
        <th>dose route freq</th>
		<th>started</th>
		<th>term date</th>
		<th>modality</th>
		</tr>";
	while($row = $result->fetch_assoc())
		{
		$trclass = ($row["termdate"]) ? "" : "hilite" ;
		$drugnotes = ($row["drugnotes"]) ? "<br /><i>".$row["drugnotes"]."</i>" : "" ;
		echo '<tr class="' . $trclass . '">
		<td>' . $row['drugname'] . '</td>
        <td>' . $row['dose'] . ' ' . $row['route'] . ' ' . $row['freq'] . $drugnotes. '</td>
		<td class="start">' . dmy($row['adddate']) . '</td>
		<td class="term">' . dmy($row['termdate']) . '</td>
		<td>' . $row['medmodal'] . '</td>
		</tr>';
		}
	echo '</table>';
} else {
	echo "<p class=\"headergray\">No immunosuppressant prescriptions located.</p>";
}

echo '</div>
</div>
	<div id="updlupusformdiv">
		<form action="renal/renal.php?zid='.$zid.'&amp;scr=lupus&amp;mode=updlupusdata" method="post">
		<fieldset>
		<ul class="form">
        <li><label for="lupusdxdate">Date of Dx</label>&nbsp;&nbsp;<input type="text" name="lupusdxdate" class="datepicker" value="'.$lupusdxdate.'" size="12" id="lupusdxdate" />
        <li><label for="anatitre_dxdate">ANA titre at Dx Date</label>&nbsp;&nbsp;<input type="text" name="anatitre_dxdate" class="datepicker" value="'.$anatitre_dxdate.'" size="12" id="anatitre_dxdate"/>
		<li><label for="anatitre_dx">ANA titre at Dx</label>&nbsp;&nbsp;<input type="text" name="anatitre_dx" value="'.$anatitre_dx.'" size="10" id="anatitre_dx"/></li>
        <li><label for="dsdna_dxdate">DS DNA at Dx Date</label>&nbsp;&nbsp;<input type="text" name="dsdna_dxdate" class="datepicker" value="'.$dsdna_dxdate.'" size="12" id="dsdna_dxdate"/>
		<li><label for="dsdna_dx">DS DNA at Dx</label>&nbsp;&nbsp;<input type="text" name="dsdna_dx" value="'.$dsdna_dx.'" size="10" id="dsdna_dx"/></li>
		<li><label for="anticardiolipin">Anti-cardiolipin Ab?</label>&nbsp;&nbsp;';
        //start update select
        $selectfield="anticardiolipin";
        $selectvalue=${$selectfield};
        $defaultoption = ($selectvalue) ? "<option>$selectvalue</option>" : '<option value="">Select...</option>' ;
        echo '<select name="'.$selectfield.'" id="'.$selectfield.'">';
        echo $defaultoption . ${$selectfield."_options"};
        echo '</select></li>';
        //end update select
        
        // echo '<li><label for="ena">ENA</label>&nbsp;&nbsp;';
        //         //start update select
        //         $selectfield="ena";
        //         $selectvalue=${$selectfield};
        //         $defaultoption = ($selectvalue) ? "<option>$selectvalue</option>" : '<option value="">Select...</option>' ;
        //         echo '<select name="'.$selectfield.'" id="'.$selectfield.'">';
        //         echo $defaultoption . ${$selectfield."_options"};
        //         echo '</select></li>';
        //         //end update select
        foreach ($enatypes as $fld => $lbl) {
            $checked = (${$fld}=="Y") ? 'checked="checked"' : '' ;
            echo '<li><label for="'.$fld.'">ENA: '.$lbl.'</label>&nbsp;&nbsp;<input type="checkbox" name="'.$fld.'" value="Y" '.$checked.' />Yes</li>';
        }
		echo '<li><label for="lupusnotes">Notes/Comments</label><br><textarea name="lupusnotes" rows="4" cols="120">'.$lupusnotes.'</textarea></li>
		</ul>
		<input type="submit" style="color: green;" value="Update Lupus Info" />
		</fieldset>
		</form>
	</div>
	<div id="lupusbxformdiv">
		<form action="renal/renal.php?zid='.$zid.'&amp;scr=lupus&amp;mode=addlupusbx" method="post">
		<fieldset>
		<ul class="form">
		<li><label>Biopsy Date</label>&nbsp;&nbsp;<input type="text" name="lupusbxdate" class="datepicker" value="'.Date("d/m/Y").'" size="12" /></li>
		<li><label>Biopsy Class</label>&nbsp;&nbsp;';
        //start insert select
        $selectfield="lupusbxclass";
        echo '<select name="'.$selectfield.'" id="'.$selectfield.'">';
        echo '<option value="">Select...</option>' . ${$selectfield."_options"};
        echo '</select></li>';
        //end insert select
        
        echo '<li><label>Activity Index</label>&nbsp;&nbsp;';
        //start insert select
        $selectfield="activityindex";
        echo '<select name="'.$selectfield.'" id="'.$selectfield.'">';
        echo '<option value="">Select...</option>' . ${$selectfield."_options"};
        echo '</select></li>';
        //end insert select
        
		echo '<li><label>Chronicity Index</label>&nbsp;&nbsp;';
        //start insert select
        $selectfield="chronicityindex";
        echo '<select name="'.$selectfield.'" id="'.$selectfield.'">';
        echo '<option value="">Select...</option>' . ${$selectfield."_options"};
        echo '</select></li>';
        //end insert select
        echo '<li><label>Biopsy Notes</label>&nbsp;&nbsp;<input type="text" name="lupusbxnotes" size="120" /></li>
		</ul>
		<input type="submit" style="color: green;" value="Submit Lupus Biopsy Info" />
		</fieldset>
		</form>
	</div>
</div>';
