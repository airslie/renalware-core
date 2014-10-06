<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//misc functions
//date fix
function fixDate($datefield)
{
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
	if ( $datefield=='' )
	{
	$datefield=NULL;
	return($datefield);
	}
}
function debug($query)
{
	if ( $_GET['debug'] )
	{
	echo "<div class=\"blockquote\">$query</div>"; 
	}
}
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
	$y_m_d=explode("-",$ymd);
	$dmyyyy=$y_m_d[2].'/'.$y_m_d[1].'/'.$y_m_d[0];
	return($dmyyyy);
	}
}
//Sun Sep 27 15:25:56 CEST 2009
extract($_GET,EXTR_PREFIX_ALL,'get');
extract($_POST,EXTR_PREFIX_ALL,'post');
extract($_COOKIE,EXTR_PREFIX_ALL,'cookie');
extract($_SESSION,EXTR_PREFIX_ALL,'sess');
