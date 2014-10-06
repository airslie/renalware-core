<?php
//--Mon Oct 15 09:39:26 SGT 2012--
//Mon Dec 15 12:44:55 JST 2008, Thu Nov 26 16:51:49 CET 2009
$txtsql="SELECT *, DATE_FORMAT(txtdate, '%d/%m/%Y') as txtdmy, rrmodalcode, rregsitecode, sitetype 
FROM renalreg.qtr_txtdata LEFT JOIN renalreg.krusitelist ON modalsitecode=sitecode WHERE txtzid=$zid ORDER BY txtzid, txtdate";
$txtresult = $mysqli->query($txtsql);
$seqno=0;
while($txtrow = $txtresult->fetch_assoc())
	{
	$seqno++;
	$sitecode = ($txtrow["rregsitecode"]) ? $txtrow["rregsitecode"] : $center ;
	$sitetype = ($txtrow["sitetype"]) ? $txtrow["sitetype"] : "HOSP" ;
	$patoutput.= '!TXT:$TXT00='.$txtrow["txtdmy"].'|$TXT02=%RR='.$txtrow["rrmodalcode"].'|$TXT20='.$sitecode.'|$TXT21=%RR='.$sitetype.'|$TXT99='.$seqno.'|!ENDTXT'."\r";
	}
