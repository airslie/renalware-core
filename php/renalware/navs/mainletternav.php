<div>
<ul id="menu-h" class="horizontal">
	<li><a href="lists/patientlist.php?show=1" title="Patients List">Patients</a>
	</li>
	<li><a href="admissions/admissionslist.php" title="admissions">Admissions</a>
	</li>
	<li><a href="lists/letterlist.php" title="Letters">Letters</a>
		<ul>
		<li><a href="lists/letterlist.php" title="All Letters">Letters/Drafts</a>
		<li><a href="lists/draftlist.php" title="preview drafts">Drafts List</a>
			<li><a href="letters/newletter.php?stage=findpat" title="create a new letter">New Letter</a></li>
			<li><a href="letters/newdischarge.php?stage=findpat" title="create a new discharge summary">New DischSumm</a></li>
			<li><a href="user/userletters.php" title="My typed or authored letters"><?php echo $user; ?>&rsquo;s Letters</a></li>
			<li><a href="user/userdrafts.php" title="My typed or authored drafts"><?php echo $user; ?>&rsquo;s DRAFTS</a></li>
		</ul>
	</li>
	<li><a href="lists/modalslist.php" title="Modalities List">Modals</a>
		<ul>
		<li><a href="lists/modalslist.php" title="Modalities List">Stats &amp; Downloads</a></li>
		<li><a href="renal/hdlists.php?list=siteslist" title="HD Sites">HD Sites List</a></li>
		</ul>
	</li>
	<li><a href="user/userhome.php" title="View/Edit your account"><?php echo $user; ?></a>
	</li>
	<li><a href="logout.php" title="Log out of Renalware">Logout</a></li>
</ul>
</div><br>