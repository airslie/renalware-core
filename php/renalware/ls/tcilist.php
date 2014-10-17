<?php
//----Thu 02 Feb 2012----
include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'activelist' => "Active Patients",
	'usertcilist' => "$user&rsquo;s Active List",
	'removedlist' => "Admitted/Removed",
	'alltcilisted' => "All Patients",
	'bedmgrlist' => "Bed Mgt List",
	);
$thislistgroupname = "Renal TCI List";
$thislist = ($get_list) ? $get_list : "activelist";
$thislistname=$listslist["$thislist"];
$thislistfolder="tcilists";
$thislistbase="tcilist";
$listitems="TCI patients";
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
	echo '<button style="color: green;" onclick="$(\'#addformdiv\').toggle()">Add TCI List patient</button>';
	echo "</div>";
?>
	<div id="addformdiv" style="display: none;">
		<h3>Step 1: Find desired patient</h3>
	<form name="searchpatdata" id="searchpatdata">
		<fieldset>
			<legend>Enter patient hospital number</legend>
	Enter <acronym title="Enter full or partial patient surname[,forenames] or complete Hosp No. Search is not case-sensitive">patient last name or Hosp No</acronym> then TAB: <br><br>
	<input type="text" onchange="findHospNo();" id="ajaxsearch"/><input type="button" onclick="findHospNo()" value="Search <?php echo $siteshort ?> Patients List" /><br><br>
	</fieldset></form><br>
	<div id='searchresultsDiv'></div>
	</div>
<div id="datatablediv">
<?php
include("$thislistfolder/$thislist.php");
?>
</div>
<?php
include '../parts/footer.php';
?>
<script charset="utf-8">
	function findHospNo(this_id){
		$('#datatablediv').hide();
		var thisajaxsearch=$('#ajaxsearch').val();
		$.get("ajax/run-gettcilistpat.php", {ajaxsearch: thisajaxsearch},
		   function(data){
			$('#searchresultsDiv').html(data);
			});
		}
</script>