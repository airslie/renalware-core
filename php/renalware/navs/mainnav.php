<div id="mainnavdiv">
	<ul id="mainnav">
		<li><a style="color: green;" href="user/userhome.php"><?php echo $user; ?></a>
			<ul>
				<li><a href="user/userhome.php">my Home Screen</a></li>
				<li><a href="user/userprofile.php">my Profile</a></li>
				<li><a href="user/userletters.php">my Letters</a></li>
				<li><a href="user/userdrafts.php">my DRAFTS</a></li>
				<li><a href="user/usermarks.php">my Bookmarks</a></li>
				<li><a href="user/usertemplates.php">my Templates</a></li>
			</ul>
		</li>
		<li><a href="lists/patientlist.php">Patients</a>
			<ul>
				<li><a href="lists/patientlist.php">Renal Patient List</a></li>
				<li><a href="lists/clinstudieslist.php">Clinical Studies</a></li>
				<li><a href="pat/addpatient.php">Add Patient</a></li>
			</ul>
		</li>
		<li><a href="admissions/admissionslist.php">Admissions</a>
			<ul>
				<li><a href="admissions/inpatientlist.php">View/Disch Inpatients</a></li>
				<li><a href="admissions/dischargedlist.php">Discharged Patients</a></li>
				<li><a href="admissions/wardreport.php">Print Ward Rpt</a></li>
				<li><a href="admissions/fortnightly.php">Print Fortnight Rpt</a></li>
				<li><a href="admissions/dischargesummlist.php">Disch Summ Lists</a></li>
				<li><a href="bedmgt/index.php?vw=user&amp;scr=systemguide">Bed Mgt</a></li>
			</ul>
		</li>
		<li><a href="lists/patientlist.php?show=1">Renal</a>
			<ul>
				<li><a href="renal/pdlist.php">PD Pat List</a></li>
				<li><a href="renal/lowclearlist.php">LowClear Pat List</a></li>
				<li><li><a href="renal/hdlists.php?list=hdpatlist&amp;site=<?php echo $HDsite1; ?>">HD Patients</a>
				<ul><li><a href="renal/hdscreens.php">HD Site Screens</a></li>
				<li><a href="renal/hdlists.php?list=hdpatlist&amp;site=<?php echo $HDsite1; ?>">HD Pat List</a></li>
				<li><a href="renal/hdlists.php?list=siteslist">HD Sites List</a></li>
				<li><a href="renal/hdlists.php?list=sitescheds">HD Scheds/Screens</a></li>
				</ul></li>
				<li><a href="ls/esalists.php">ESA Lists</a></li>
				<li><a href="ls/esrflist.php">ESRF/PRD List</a></li>
				<li><a href="renal/screens.php?s=tx_patients">Tx Patients</a>
				<ul>
				<li><a href="renal/txwaitlist.php">Tx Wait List</a></li>
				<li><a href="renal/txwaitlistreport.php">Tx Wait List Rpt</a></li>
				<li><a href="renal/txoplist.php">Tx Ops List</a></li>
				<li><a href="renal/txreciplist.php">Tx Recips List</a></li>
				</ul></li>
				<li><a href="immunosupprx/index.php">Immunosupp Rx</a></li>
				<li><a href="aki/index.php">AKI Module</a></li>
				<li><a href="sharedcare/index.php">Shared Care</a></li>
                
			</ul>
		</li>
		<li><a href="renal/screens.php">Screens</a>
			<ul>
				<li><a href="renal/screens.php?s=tx_patients">Tx Patients</a></li>
				<li><a href="renal/screens.php?s=lowclear_patients">Low Clear</a></li>
				<li><a href="renal/screens.php?s=pd_patients">PD Patients</a></li>
				<li><a href="renal/hdscreens.php">HD Site Screens</a></li>
				<li><a href="renal/hdlists.php?list=sitescheds">HD Scheds/Screens</a></li>
				<li><a href="renal/accesslist.php">Access List (LCC/HD)</a></li>
			</ul>
		</li>
		<li><a href="renal/screens.php">Lists</a>
			<ul>
				<li><a href="lists/modalslist.php">Modals Lists</a></li>
				<li><a href="ls/esalists.php">Renal--ESA</a></li>
				<li><a href="ls/txwaitlist.php">Tx Wait List</a></li>
				<li><a href="ls/consultlist.php">Consults</a></li>
				<li><a href="ls/tcilist.php">TCI List</a></li>
				<li><a href="ls/letterslists.php">Letters</a></li>
				<li><a href="ls/arclist.php">ARC List</a></li>
				<li><a href="ls/lupuslist.php">Lupus List</a></li>
				<li><a href="ls/mrsalist.php">MRSA Swabs</a></li>
				<li><a href="ls/rpvlist.php">RPV Pats</a></li>
				<li><a href="ls/immunosupplists.php">Immunosupp Lists</a></li>
				<li><a href="ls/pimslists.php">Search PIMS List</a></li>
			</ul>
		</li>
		<li><a href="lists/letterlist.php">Letters</a>
			<ul>
				<li><a href="lists/letterlist.php">Letters/Drafts</a></li>
				<li><a href="lists/draftlist.php">DRAFTs List</a></li>
				<li><a href="letters/newletter.php?stage=findpat">New Letter</a></li>
				<li><a href="letters/newdischarge.php?stage=findpat">New DischSumm</a></li>
				<li><a href="user/userletters.php">my Letters</a></li>
				<li><a href="user/userdrafts.php">my DRAFTS</a></li>
			</ul>
		</li>
		<li><a >Reports</a>
			<ul>
				<li><a href="renal/txwaitlistreport.php">Tx Wait List</a></li>
				<li><a href="renal/hdlists.php?list=siteslist">HD Site Pat Lists</a></li>
				<li><a href="renal/hdlists.php?list=holslist">HD Holidays List</a></li>
				<li><a href="admissions/wardreport.php">Ward (Inpats) Report</a></li>
				<li><a href="admissions/fortnightly.php">Fortnight Admissions</a></li>
				<li><a href="audits/audits.php">AUDITS</a></li>
			</ul>
		</li>
		<li><a href="search/renalsearch.php">Search</a>
			<ul>
				<li><a href="search/renalsearch.php">Renal Search</a></li>
			</ul>
		</li>
		<li><a href="lists/downloads.php">Downloads</a></li>
		<?php if ($zid): ?>
		<li><a style="background: green; color: white" href="pat/patient.php?zid=<?php echo $zid ?>&amp;vw=clinsumm"><?php echo "$firstnames $lastname"; ?></a>
			<ul>
			<li><a href="pat/patient.php?zid=<?php echo $zid ?>&amp;vw=clinsumm">Clin Summary</a></li>
			<li><a href="letters/createletter.php?zid=<?php echo $zid; ?>">New Letter</a></li>
			<?php if (substr($modalcode,0,2)== 'HD'): ?>
				<li><a href="renal/patient_info/printHDsheets.php?zid=<?php echo $zid; ?>" target="new">HD Info Sheet</a></li>
			<?php endif ?>
			<?php if ($modalcode== 'nephrology' or $modalcode=='diabetic'): ?>
				<li><a href="renal/patient_info/printDMsheet.php?zid=<?php echo $zid; ?>" target="new">DM Nephrol Info</a></li>
			<?php endif ?>
			<?php if ($modalcode== 'nephrology'): ?>
				<li><a href="renal/patient_info/printNephrosheet.php?zid=<?php echo $zid; ?>" target="new">Nephrol Info</a></li>
			<?php endif ?>
			<?php if ($modalcode== 'lowclear'): ?>
				<li><a href="renal/patient_info/printLCCsheet.php?zid=<?php echo $zid; ?>" target="new">LCC Info Sheet</a></li>
			<?php endif ?>
			</ul>
		</li>
		<?php endif ?>
		<li><a style="color: red;" href="logout.php">Logout</a></li>
	</ul>
</div>
<div id="quicksearchdiv" class="clear" style="clear: both;">
<form action="ls/searchresults.php" method="get">
	<input type="text" name="findpat" id="findpatinput" placeholder="lastname[,first] or HospNo" /> <input type="submit" id="submitfindpat" class="btn btn-mini" value="Find!" /></form>
</div>
<div id="content">