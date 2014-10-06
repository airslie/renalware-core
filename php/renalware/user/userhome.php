<?php
//----Thu 13 Jun 2013----pathlogs DEPR
//----Wed 06 Mar 2013----review
include '../req/confcheckfxns.php';
$pagetitle= "Home Screen: $user";
//get header
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//--------Page Content Here----------
include "$rwarepath/user/navs/usernav.php";
include 'portals/userletterccs_incl.php';
include 'portals/usermessages_incl.php';
include 'portals/userletters_incl.php';
include 'portals/bookmarkdata_incl.php';
include '../parts/footer.php';
