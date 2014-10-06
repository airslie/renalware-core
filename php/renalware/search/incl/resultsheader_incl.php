<p class="header"><?php 
echo "Displaying $numrows $thisitems $where $orderby. Click on headers to sort columns.";
?>
</p><p><a class="ui-state-default" style="color: green;" href="search/renalsearch.php">Search again</a>&nbsp;&nbsp;
<?php if ($adminflag): ?>
    &nbsp;&nbsp;<a class="ui-state-default" style="color: purple;" onclick='$("#showsqldiv").toggle();'>Show SQL (Admins only)</a>
</p>
<div id="showsqldiv" style="display: none; background-color: #ff9; border: thin solid #f00; padding: 3px; margin: 4px; font-size: .8em;">
        <?php
        echo "$sql";
        ?>
    </div>  
<?php endif ?>