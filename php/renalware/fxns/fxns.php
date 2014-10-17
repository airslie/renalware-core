<?php
function dmy($ymd)
{
	if ($ymd !=NULL AND $ymd != '0000-00-00') {
	$y_m_d=explode("-",$ymd);
	$dmy=$y_m_d[2].'/'.$y_m_d[1].'/'.substr($y_m_d[0],2);
	return($dmy);
	}
}
function dmyyyy($ymd)
{
	if ($ymd !=NULL AND $ymd != '0000-00-00') {
	list($y,$m,$d)=explode("-",$ymd);
	$dmyyyy="$d/$m/$y";
	return($dmyyyy);
	}
}
function unstamp($timestamp)
{
	$y_m_d=explode("-",substr($timestamp,0,10));
	$dmyyyy=$y_m_d[2].'/'.$y_m_d[1].'/'.$y_m_d[0];
	return($dmyyyy);
}
//new Fri May 16 11:06:57 CEST 2008 to handle datestamps as well
function dmy4($ymdhms)
{
	$dmyyyy=date("d/m/Y",strtotime("$ymdhms"));
	return $dmyyyy;
}
function dmy2($ymdhms)
{
	$dmy=date("d/m/y",strtotime("$ymdhms"));
	return $dmy;
}


function fixDate($datefield)
{
	if ($datefield=='' OR $datefield=='0000-00-00') {
		$datefield=NULL;
		return($datefield);
	}
	else {
		if(strstr($datefield,"/") OR strstr($datefield,"."))
		{
			//14/3/04 or 14.3.2005 e.g.
			if(strstr($datefield,"/"))
				{
				$date_expl = explode("/",$datefield);
				}
			if(strstr($datefield,"."))
				{
				$date_expl = explode(".",$datefield);
				}
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
}

function incrStat($stat, $zid)
{
	include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
	$sql= "UPDATE renalware.patstats SET $stat=$stat+1, statstamp=NOW() WHERE statzid=$zid";
	$result = $mysqli->query($sql);
}
function decrStat($stat, $zid)
{
	include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
	$sql= "UPDATE renalware.patstats SET $stat=$stat-1, statstamp=NOW() WHERE statzid=$zid";
	$result = $mysqli->query($sql);
}
function stampPat($zid)
{
	include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
	$sql= "UPDATE renalware.patientdata SET modifstamp=NOW() WHERE patzid=$zid";
	$result = $mysqli->query($sql);
}
$thisurl="http://". $_SERVER['HTTP_HOST'].htmlentities($_SERVER['REQUEST_URI']);

function runsql($sql, $debug)
{
	if ($debug) {
		echo "<p class=\"alertsmall\">$sql</p>";
	} else {
		include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
		$mysqli = new mysqli($host, $dbuser, $pass, $db);
		$result = $mysqli->query($sql);
		return $result;
	}
}
function microtime_float()
{
    list ($msec, $sec) = explode(' ', microtime());
    $microtime = (float)$msec + (float)$sec;
    return $microtime;
}
extract($_GET,EXTR_PREFIX_ALL,'get');
extract($_POST,EXTR_PREFIX_ALL,'post');
extract($_COOKIE,EXTR_PREFIX_ALL,'cookie');
extract($_SESSION,EXTR_PREFIX_ALL,'sess');
//for escaped POSTs ----Sun 20 Jun 2010----

while(list($k,$v)=each($_POST)){
	$vfix = $mysqli->real_escape_string($v);
	$$k = (substr(strtolower($k),-4)=="date") ? fixDate($vfix) : $vfix ;
}

// Get starting time.
$start = microtime_float();
//---------------Sat Jan 23 10:34:36 GMT 2010---------------
function makeredButton($linkval,$linkurl)
{
	echo '<p class="buttonsdiv"><button style="color: red;" onclick="self.location=\''.$linkurl.'\'">'.$linkval.'</button></p>';
}
function showError($errormsg) {
	echo "<script type=\"text/javascript\">
		$.pnotify({
			pnotify_title: 'Something went wrong',
			pnotify_text: '".$errormsg."',
			pnotify_type: 'error'
		});
	</script>";
}
function showUrgent($urgentmsg) {
	echo "<script type=\"text/javascript\">
		$.pnotify({
			pnotify_text: '".$urgentmsg."',
			pnotify_type: 'error',
			pnotify_shadow: true,
		});
	</script>";
}

function showAlert($alertmsg) {
	echo "<script type=\"text/javascript\">
		$.pnotify({
			pnotify_text: '".$alertmsg."',
			pnotify_shadow: true,
		});
	</script>";
}
function showSticky($alertmsg) {
	echo "<script type=\"text/javascript\">
		$.pnotify({
			pnotify_text: '".$alertmsg."',
			pnotify_shadow: true,
			pnotify_hide: false,
		});
	</script>";
}
//for var defaults
$vw = (isset($_GET['vw'])) ? $get_vw : FALSE ;
$mode = (isset($_GET['mode'])) ? $get_mode : FALSE ;
$scr = (isset($_GET['scr'])) ? $get_scr : FALSE ;

//----Sun 04 Jul 2010----
function lastWord($sentence) {
// Break the sentence into its component words:
$words = explode(' ', $sentence);
// Get the last word and trim any punctuation:
$lastword = trim($words[count($words) - 1], '.?![](){}*');
// Return a result:
return $lastword;
}
//----Mon 28 Mar 2011----
function makeAlert($alertlbl,$alerttext)
{
	echo '<div class="ui-state-highlight" style="padding: .3em; margin-bottom: 3px; border: 1px solid #f00;">
					<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
					<strong>'.$alertlbl.'</strong> '.$alerttext.'
				</div>';
}
function spanAlert($alertlbl,$alerttext)
{
	echo '<span class="ui-state-highlight" style="padding: .3em; margin-bottom: 3px;">
					<span style="color: #f00;"><strong>'.$alertlbl.'</strong></span>&nbsp;&nbsp;'.$alerttext.'</span>';
}

function makeInfo($infolbl,$infotext)
{
	echo '<div class="ui-state-highlight uiinfo" style="padding: .1em; margin-bottom: 3px;">
					<span class="ui-icon ui-icon-info" style="float:left; margin-right: .4em;"></span>
					<strong>'.$infolbl.'</strong> '.$infotext.'
				</div>';
}
function showInfo($infolbl,$infotext)
{
	echo '<p class="ui-state-highlight uiinfo" style="padding: 3px; margin-bottom: 2px; width: 900px;">
<strong>'.$infolbl.'</strong> '.$infotext.'
		</p>';
}

function makeError($errorlbl,$errortext)
{
	echo '<p class="ui-state-error" style="padding: 2px; margin-bottom: 3px;">
					<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
					<strong>'.$errorlbl.'</strong> '.$errortext.'
				</p>';
}
function ae_detect_ie()
{
    if (isset($_SERVER['HTTP_USER_AGENT']) &&
    (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false))
        return true;
    else
        return false;
}
?>