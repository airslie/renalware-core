<?php
//----Fri 07 Feb 2014----display errormsg prn
//----Fri 20 Dec 2013----AKI list added
//Fri Oct 24 10:33:25 IST 2008
//----Sun 16 Oct 2011----upgr to datatable
include realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'activelist' => "All Active",
	'userconsults' => "$user&rsquo;s Active",
	'sitelist&site=KCH' => "Active KCH",
	'sitelist&site=QEH' => "Active QEH",
	'sitelist&site=DVH' => "Active DVH",
	'sitelist&site=BROM' => "Active BROM",
	'sitelist&site=GUYS' => "Active GUYS",
	'sitelist&site=Other' => "Active Other",
	'akiconsults' => "AKI Consults",
	'completedlist' => "Completed",
	'allconsults' => "All Consults",
	);
$thislistgroupname = "Renal Consults List";
$thislist = ($get_list) ? $get_list : "activelist";
$thislistname=$listslist["$thislist"];
if ($get_site) {
	$thislistname="Active $get_site Patients";
}
$thislistfolder="consultlists";
$thislistbase="consultlist";
$listitems="Consult patients";
$pagetitle= $thislistgroupname . ' -- ' . $thislistname;
// --------- ----Mon 10 Oct 2011---- SHOULD NOT NEED TO MODIFY BELOW -------------------
//get datatable header
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//navbar
echo '<div class="buttonsdiv">';
foreach ($listslist as $list => $listname) {
	$class = ($thislist==$list) ? 'class="hilit"' : "" ;
	echo "<button $class onclick=\"location.href='ls/$thislistbase.php?list=$list'\">$listname</button>&nbsp;&nbsp;";
	}
	echo '<button style="color: green;" onclick="$(\'#addformdiv\').toggle()">Add Consult</button>';
	echo "</div>";
if ($_SESSION['errormsg']) {
	showError($_SESSION['errormsg']);
	unset($_SESSION['errormsg']);
}
?>
	<div id="addformdiv" style="display: none;">
		<h3>Step 1: Find desired patient</h3>
        <form action="ls/consultlist.php" method="get" accept-charset="utf-8">
    		<fieldset>
    			<legend>Enter patient surname or <?php echo "$hosp1label/$hosp2label/$hosp3label/$hosp4label/NHS No" ?></legend>
        <input type="text" name="search" id="search" size="24" placeholder="surname or Hosp No"><br><br>
        <input type='submit' value='Search <?php echo $siteshort ?> Patients List' />
    	</fieldset>
        </form>
    </div>
<?php
if ($get_search) {
    include 'consultlists/runsearch_incl.php';
    echo '<form action="ls/consultlist.php" method="get" accept-charset="utf-8">
		<fieldset>
			<legend>Refine search term if desired</legend>
    <input type="text" name="search" value="'.$get_search.'" id="search">
    <input type="submit" value="Search again" /><br><br>
	</fieldset>
    </form>';
} else {
    echo '<div id="datatablediv">';
    include("$thislistfolder/$thislist.php");
    echo '</div>';
}
include '../parts/footer.php';
