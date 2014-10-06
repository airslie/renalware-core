<p><label for="elecsigflag">Signature</label><input type="checkbox" name="elecsigflag" value="1" checked="checked" />Use ELECTRONIC SIGNATURE (default=yes)</p>
<p><input type="radio" name="stage" value="refresh" checked="checked" /><b>SAVE/REFRESH and view changes</b> or <a href="letters/previewletter.php?zid=<?php echo $zid ?>&amp;letter_id=<?php echo $letter_id ?>" target="new">view in new window (for pagebreak preview)</a></p>
<div class="DRAFT"><input type="radio" name="stage" value="draft" /><b>Save as DRAFT</b> (return to listing)</div>
<div class="TYPED"><input type="radio" name="stage" value="typed" /><b>Mark Letter TYPED for review by author</b></div>
<div class="ARCHIVED"><input type="radio" name="stage" value="archive" /><b>ARCHIVE Letter for printing</b> (Marks as "reviewed")<b>CAUTION</b>: CANNOT BE UNDONE (return to listing)</div>
<div class="DELETE"><input type="radio" name="stage" value="delete" /><b>DELETE Draft</b> <span style="color: red;" /><b>CAUTION</b>: CANNOT BE UNDONE <input type="checkbox" name="confirmdelete" value="Y" id="confirmdelete" /><b>Confirm DELETE</b></span></div>
