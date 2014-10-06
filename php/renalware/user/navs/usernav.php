<?php
if (isset($_SESSION['runmsg'])) {
	$alertmsg=$_SESSION['runmsg'];
	showAlert("$alertmsg");
	unset($_SESSION['runmsg']);
	}
?>
<div class="buttonsdiv">
<a class="gr" href="user/userhome.php">Home</a> 
<a href="user/editprofile.php">Edit Profile</a> 
<a href="user/userletters.php">Lttrs &amp; Drafts</a> 
<a href="user/userdrafts.php">DRAFTS &amp; TYPED</a> 
<a href="user/usertemplates.php">Letter Templates</a> 
<a href="user/usermarks.php">Bookmarks</a> 
<?php if ($adminflag or $printflag==1): ?>
<a href="user/printqueue.php">Print Queue</a> 
<a href="admin/lettersaudit.php">Lttrs Audit</a> 
<?php endif ?>
<?php if ($_SESSION['authorflag']==1): ?>
<a href="admin/dischsummaudit.php">Disch Summ Audit</a> 	
<?php endif ?>
<?php if ($adminflag or $user==$supertypist): ?>
<a href="admin/typistaudit.php">Typist Audit</a> 
<?php endif ?>
<?php if ($adminflag or $user==$supertypist or $consultantflag==1): ?>
<a href="admin/addnewdrugname.php">Add New Drug</a> 
<?php endif ?>
</div>
<?php if ($adminflag==1): ?>
<div id="admindiv" class="buttonsdiv">
<a href="admin/sessionlist.php">View Sessions</a> 
<a href="user/userlist.php">View Users</a> 
<a href="user/userprivs.php">User Privs</a> 
<a href="user/userstats.php">User Stats</a> 
<a href="admin/addnewuser.php">Add New User</a> 
<a href="admin/userpwlist.php">Reset User Password</a> 
<a href="admin/clinstudiesadmin.php">Add New Clin Study</a> 
<a href="admin/letterdescrlist.php">Letter Descr List</a>  
<a href="admin/tablelist.php">Table Status</a> 
<a href="renalreg/index.php">Renal Reg</a> 
</div>
<?php endif ?>