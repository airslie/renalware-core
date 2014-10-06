<?php
//Mon Mar 31 12:22:52 GST 2008
//config optionlists in renal/config/workups_config.php
?>
<div id="pagetitlediv"><h3><?php echo $patref_addr ?></h3></div>
<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p>
<form action="renal/pd/workup.php?zid=<?php echo $zid; ?>&amp;run=<?php echo $runtype ?>" method="post">
<fieldset>
<legend><?php echo $get_mode ?> PD Assessment for <?php echo $firstnames . ' ' . $lastname; 
if ($workupmodifstamp) {
echo " (Created: $workupaddstamp; Updated: $workupmodifstamp)";
}?></legend>
<ul class="form">
<li><label for="workupdate">Assessment Date</label>&nbsp;&nbsp;
	<?php
	$showdate = ($workupdate) ? $workupdate : date("d/m/Y") ;
	?>
	<input type="text" id="workupdate" name="workupdate" size="12" value="<?php echo $showdate; ?>" class="datepicker" />
</li>
<?php
makeSelect("workupnurse","Assessor",$workupnurse, $workupnurse_options);
makeRadios("homevisitflag","Home visit?",$homevisitflag, $yesno);
?>
<li><label for="homevisitdate">Home visit date</label>&nbsp;&nbsp;
<input type="text" id="homevisitdate" name="homevisitdate" size="12" value="<?php echo $homevisitdate; ?>" class="datepicker" />
</li>
<?php
makeRadios("housingtype","Housing type",$housingtype, $housingtype_options);
makeRange("no_rooms","No of rooms",$no_rooms, range(1,9));
makeRange("no_occupants","No of occupants",$no_occupants, range(1,9));
inputText("occupantnotes","occupant notes",70,$occupantnotes);
inputText("exchangearea","exchange area",70,$exchangearea);
inputText("handwashing","handwashing",70,$handwashing);
inputText("fluidstorage","fluid storage",70,$fluidstorage);
inputText("bagwarming","bag warming",70,$bagwarming);
inputText("freqdeliveries","freq of deliveries",70,$freqdeliveries);
makeRadios("rehousingflag","Rehousing?",$rehousingflag, $yesno);
inputTextarea("rehousingreasons","Reasons for rehousing",3,100,$rehousingreasons);
makeRadios("socialworkerflag","social worker?",$socialworkerflag, $yesno);
echo "</ul></fieldset>
<fieldset><ul class=\"form\">";
makeRadios("seenvideo","seen DVD?",$seenvideo, $yesno);
makeRadios("ableopenbag","able to open bag?",$ableopenbag, $yesno);
makeRadios("ableliftbag","able to lift bag?",$ableliftbag, $yesno);
inputText("eyesight","eyesight",70,$eyesight);
inputText("hearing","hearing",70,$hearing);
inputText("dexterity","dexterity",70,$dexterity);
inputText("motivation","motivation",70,$motivation);
inputText("language","language",70,$language);
inputText("notes","other notes",70,$notes);
echo "</ul></fieldset><fieldset><ul class=\"form\">";
makeRadios("suitableflag","suitable for PD?",$suitableflag, $yesno);
makeSelect("systemchoice","system choice?",$systemchoice, $systemchoice_options);
makeRadios("insertdiscussflag","insertion discussed?",$insertdiscussflag, $yesno);
makeRadios("methodchosen","method chosen",$methodchosen, $methodchosen_options);
makeRadios("accessclinrefflag","access clinic referral?",$accessclinrefflag, $yesno);
?>
<li><label for="accessclinrefdate">Access Clin referral date</label>&nbsp;&nbsp;
	<input type="text" id="accessclinrefdate" name="accessclinrefdate" size="12" value="<?php echo $accessclinrefdate; ?>" class="datepicker" />
</li>
</ul>
</fieldset><fieldset>
    <ul class="form">
<?php
makeSelect("abdoassessor","Abdo Assessor",$abdoassessor, $abdoassessor_options);
makeRadios("boweldisflag","bowel disease?",$boweldisflag, $yesno);
inputText("boweldisnotes","bowel disease notes",70,$boweldisnotes);
inputTextarea("addedcomments","added comments",4,100,$addedcomments);
?>
<li class="submit"><input type="submit" style="color: green;"  value="submit assessment for <?php echo $firstnames . ' ' . $lastname; ?>" /></li>
</ul>
</fieldset>
</form>