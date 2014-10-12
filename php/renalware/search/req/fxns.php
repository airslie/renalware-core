<?php
//created on 2009-05-05.
//versionstamp 
// Function to calculate script execution time.
realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
function microtime_float()
{
    list ($msec, $sec) = explode(' ', microtime());
    $microtime = (float)$msec + (float)$sec;
    return $microtime;
}
function sanitize($value)
{
    realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
	$value = stripslashes($value);
	if (!is_numeric($value)) {
	    $value=$mysqli->real_escape_string($value);
	}
	return $value;
}
array_walk($_GET,'sanitize');
array_walk($_POST,'sanitize');
array_walk($_COOKIE,'sanitize');

extract($_GET,EXTR_PREFIX_ALL,'get');
extract($_POST,EXTR_PREFIX_ALL,'post');
extract($_COOKIE,EXTR_PREFIX_ALL,'cookie');
extract($_SESSION,EXTR_PREFIX_ALL,'sess');

function fixDate($datefield)
{
		if(strstr($datefield,"/") OR strstr($datefield,"."))
		{
			//14/3/04 or 14.3.2005 e.g.
			$badstuff= array("/", ".");
			$pipe = '|';
			$rawdate = str_replace($badstuff, $pipe, $datefield);
			$date_expl=explode("|",$rawdate);
			// ****NB FOR UK STYLE ENTRY
			$dd = $date_expl[0];
			$mm = $date_expl[1];
			if ( count($date_expl) <3 ) //year omitted
			{
			$yyyy = date("Y");
			}
			else
			{
			$yyyy = $date_expl[2];
			if (strlen($yyyy)=="2") //only e.g. '05'
				{
					$yyyy = "20" . $yyyy;
				}
			}
			$datefield = sprintf("%04d-%02d-%02d", $yyyy, $mm, $dd);
			return($datefield);
		}
}

?>