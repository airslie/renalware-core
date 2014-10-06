<?php
//Thu May  7 15:42:44 CEST 2009
//defaults -- add path prn
//default flds in every display
$fields="patzid,hospno1,CONCAT(lastname,', ',firstnames) as patient,sex,birthdate,age,modalcode,ethnicity,endstagedate";
$corefields=explode(",",$fields);
$searchtables="renalware.patientdata p JOIN renalware.renaldata r ON patzid=renalzid";
if ($post_currsite or $post_currsched) {
    //add table
    $searchtables.=" JOIN renalware.hdprofile ON patzid=hdpatzid";
}
$where="WHERE"; //default to permit any AND
//simplefields to handle as popups thus "=" only
$simplefields=array(
    'modalcode',
    'sex',
    'ethnicity',
    'esdstatus',
    'accessCurrent',
    'accessPlan',
    'txWaitListStatus',
    'lowDialPlan',
    'currsite',
    'currsched',
    );
foreach ($simplefields as $key => $fld) {
    if ($_POST["$fld"]) {
        $searchval=$_POST["$fld"];
        $where.=" AND $fld='$searchval'";
        if (!in_array($fld, $corefields)) {
            $fields.=",$fld";
        }
    }
}
//text inputs
//map opers
$sqlopers=array(
'eq' => '=',
'gt' => '>',
'gte' => '>=',
'lt' => '<',
'lte' => '<=',
'startswith' => 'starts with',
'contains' => 'contains',
'matches' => 'matches',
'neq' => '!=',
'eqd' => '=',
'gtd' => '>',
'gted' => '>=',
'ltd' => '<',
'lted' => '<=',
);
if ($post_birthdate) {
    $datefield="birthdate";
    $dateval=fixDate($post_birthdate);
    $dateoper=$sqlopers[$post_doboper];
    $where.=" AND $datefield $dateoper '$dateval'";
}
if ($post_dobstart && $post_dobend) {
    $startdate=fixDate($post_dobstart);
    $enddate=fixDate($post_dobend);
    $datefield="birthdate";
    $where.=" AND $datefield BETWEEN '$startdate' AND '$enddate'";
}
if ($post_deathdate) {
    $datefield="deathdate";
    $dateval=fixDate($post_deathdate);
    $dateoper=$sqlopers[$post_dodoper];
    $where.=" AND $datefield $dateoper '$dateval'";
    $fields.=",deathdate";
}
if ($post_dodstart && $post_dodend) {
    $startdate=fixDate($post_dodstart);
    $enddate=fixDate($post_dodend);
    $datefield="deathdate";
    $where.=" AND $datefield BETWEEN '$startdate' AND '$enddate'";
    $fields.=",deathdate";
}
if ($post_age) {
    $ageval=(int)$post_age;
    $numoper=$sqlopers[$post_ageoper];
    $where.=" AND age $numoper '$ageval'";
}
if ($post_agestart && $post_ageend) {
    $startval=(int)$post_agestart;
    $endval=(int)$post_ageend;
    $where.=" AND age BETWEEN $startval AND $endval";
}
if ($post_endstagedate) {
    $datefield="endstagedate";
    $dateval=fixDate($post_endstagedate);
    $dateoper=$sqlopers[$post_endstagedateoper];
    $where.=" AND $datefield $dateoper '$dateval'";
}
if ($post_endstagedatestart && $post_endstagedateend) {
    $startdate=fixDate($post_endstagedatestart);
    $enddate=fixDate($post_endstagedateend);
    $datefield="endstagedate";
    $where.=" AND $datefield BETWEEN '$startdate' AND '$enddate'";
}
//PATHOLOGY FLD 1 prn
if ($post_path1) {
    //add table
    $searchtables.=" JOIN hl7data.pathol_current ON hospno1=currentpid";
    $fields.=",$post_path1";
    if ($post_path1val) {
        //simple OPER
        $pathoper=$sqlopers[$post_path1oper];
        $where.=" AND $post_path1 $pathoper '$post_path1val'";
    }
    //or handle RANGE
    if ($post_path1low && $post_path1hi) {
        $where.=" AND $post_path1 BETWEEN '$post_path1low' AND '$post_path1hi'";
    }
    //DATE if entered
    if ($post_path1date) {
        $pathdate1=fixDate($post_path1date);
        $pathdatefield=$post_path1."stamp";
        $dateoper=$sqlopers[$post_path1dateoper];
        $where.=" AND DATE($pathdatefield) $dateoper '$pathdate1'";
    }
    //or date RANGE
    if ($post_path1datestart && $post_path1dateend) {
        $path1datestart=fixDate($post_path1datestart);
        $path1dateend=fixDate($post_path1dateend);
        $pathdatefield=$post_path1."stamp";
        $where.=" AND DATE($pathdatefield) BETWEEN '$path1datestart' AND '$path1dateend'";
    }
    //PATH FLD 2 (NB assumes path1 used)
    if ($post_path2) {
        //simple OPER
        $fields.=",$post_path2";
        if ($post_path2val) {
            //simple OPER
            $pathoper=$sqlopers[$post_path2oper];
            $where.=" AND $post_path2 $pathoper '$post_path2val'";
        }
        //or handle RANGE
        if ($post_path2low && $post_path2hi) {
            $where.=" AND $post_path2 BETWEEN '$post_path2low' AND '$post_path2hi'";
        }
        //DATE if entered
        if ($post_path2date) {
            $pathdate2=fixDate($post_path2date);
            $pathdatefield=$post_path2."stamp";
            $dateoper=$sqlopers[$post_path2dateoper];
            $where.=" AND DATE($pathdatefield) $dateoper '$pathdate2'";
        }
        //or date RANGE
        if ($post_path2datestart && $post_path2dateend) {
            $path2datestart=fixDate($post_path2datestart);
            $path2dateend=fixDate($post_path2dateend);
            $pathdatefield=$post_path2."stamp";
            $where.=" AND DATE($pathdatefield) BETWEEN '$path2datestart' AND '$path2dateend'";
        }
    } //end pathfld2
}//end if pathfld1

//CUSTOM FLDS
if ($post_searchfield1) {
    //handle any oper and change case
    $searchval = (is_string($post_searchval1)) ? strtolower($post_searchval1) : $post_searchval1 ;
    $customoper=$sqlopers[$post_searchoper1];
    switch ($customoper)
        {
       case 'matches':
        $searchval=strtolower($post_searchval1);
           $where.=" AND LOWER($post_searchfield1) = '$searchval'";
           break;
       case 'contains':
           $where.=" AND LOWER($post_searchfield1) LIKE '%$searchval%'";
           break;
       case 'starts with':
           $where.=" AND LOWER($post_searchfield1) LIKE '$searchval%'";
           break;
       default:
       //handles other opers
           $where.=" AND $post_searchfield1 $customoper '$searchval'";
           break;
        } //end switch sqlop
    if (!in_array($post_searchfield1, $corefields)) {
        $fields.=",$post_searchfield1";
    }
}
if ($post_searchfield2) {
    $searchval = (is_string($post_searchval2)) ? strtolower($post_searchval2) : $post_searchval2 ;
    $customoper=$sqlopers[$post_searchoper2];
    switch ($customoper)
        {
       case 'matches':
        $searchval=strtolower($post_searchval2);
           $where.=" AND LOWER($post_searchfield2) = '$searchval'";
           break;
       case 'contains':
           $where.=" AND LOWER($post_searchfield2) LIKE '%$searchval%'";
           break;
       case 'starts with':
           $where.=" AND LOWER($post_searchfield2) LIKE '$searchval%'";
           break;
       default:
       //handles other opers
           $where.=" AND $post_searchfield2 $customoper '$searchval'";
           break;
        } //end switch sqlop
    if (!in_array($post_searchfield2, $corefields)) {
        $fields.=",$post_searchfield2";
    }
}
//ARRANGE SORT
$orderby="ORDER BY lastname, firstnames"; //default
if ($post_sortoptiontype=="custom" && $post_sortfld1) {
    //need at least sortfld1
    $orderby="ORDER BY $post_sortfld1 $post_sortorder1";
    if ($post_sortfld2) {
        $orderby.=", $post_sortfld1 $post_sortorder2";
    }
}
//get rid of WHERE AND
$where=str_replace("WHERE AND","WHERE",$where);
$sql = "SELECT $fields FROM $searchtables $where $orderby";
//echo "<br>TEST: $sql <br>";
if (!$debug) {
   $result = $mysqli->query($sql);
} else {
    echo "<hr />SQL: $sql <hr />";
}
$numrows=$result->num_rows;
$numcols=$mysqli->field_count;
$tablefinfo=$result->fetch_fields();
//create display flds list by subtracting hidden fields
$displayfields=array();
foreach ($tablefinfo as $key => $fieldData)
	{
    $displayfields[]=$fieldData->name;
}
?>