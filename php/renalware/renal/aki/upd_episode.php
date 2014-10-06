<?php
//----Tue 05 Mar 2013----
$thisid=(int)$get_id;
$sql = "SELECT * FROM akidata WHERE aki_id=$thisid";
$showlabel="Update AKI Episode $thisid";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
$row = $result->fetch_assoc();
foreach ($row as $key => $value) {
	$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
//display latest
echo "<h3>$showlabel: $episodedate</h3>";
include 'aki/incl_akinav.php';
include 'aki/aki_options.php';
//display episode data using config array
echo '<div id="updakidataformtab">
	<form action="renal/renal.php?scr=aki&amp;zid='.$zid.'&amp;mode=view_episode&amp;id='.$thisid.'" method="post" accept-charset="utf-8">
		<input type="hidden" name="runscript" value="run_updepisode" />
		<input type="hidden" name="akizid" value="'.$zid.'" />
		<input type="hidden" name="aki_id" value="'.$thisid.'" />
		<fieldset>
			<legend>Update AKI Episode '.$thisid.'</legend>
			<ul class="form">';
$datamap=$akiupdmap1;
include 'incl/makeupdfields_incl.php';
?>
<!-- special for cascading select -->
<div id="S" class="subtypeoptions">
    <li><label>STOP Subtype S</label><select name="stopsubtype"><option value="">Select (S) subtype...</option>
        <?php echo $s_options; ?>
    </select></li>
</div>
<div id="T" class="subtypeoptions">
    <li><label>STOP Subtype T</label><select name="stopsubtype"><option value="">Select (T) subtype...</option>
        <?php echo $t_options; ?>
    </select></li>
</div>
<div id="O" class="subtypeoptions">
    <li><label>STOP Subtype O</label><select name="stopsubtype"><option value="">Select (O) subtype...</option>
        <?php echo $t_options; ?>
    </select></li>
</div>
<div id="P" class="subtypeoptions">
    <li><label>STOP Subtype P</label><select name="stopsubtype"><option value="">Select (P) subtype...</option>
        <?php echo $t_options; ?>
    </select></li>
</div>

<?php
$datamap=$akiupdmap2;
include 'incl/makeupdfields_incl.php';
echo '<li class="submit">
				<input type="submit" style="color: green;" value="Update AKI episode &rarr;" />&nbsp;&nbsp;
				<input type="button" class="ui-state-default" style="color: red;" onclick="location.href=\'renal/renal.php?zid='.$zid.'&amp;scr=aki&amp;mode=view_episode&amp;id='.$thisid.'\'" value="Cancel" />
			</li>
			</ul>
		</fieldset>
	</form>
</div>';
?>
<script type="text/javascript">
$(document).ready(function(){
    $('.subtypeoptions').hide();
  $('#akicode').change(function() {
      $('.subtypeoptions').hide();
      var subtypeval = $('#akicode').val();
      if (subtypeval=='S') {
          $('#S').show();
      };
      if (subtypeval=='T') {
          $('#T').show();
      };
      if (subtypeval=='O') {
          $('#O').show();
      };
      if (subtypeval=='P') {
          $('#P').show();
      };
      
 });
});
</script>
