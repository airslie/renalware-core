<?php
//--Fri Nov 22 15:33:16 EST 2013--
//miscell bootstrap fxns
/*
REF:
<p class="text-muted">...</p>
<p class="text-primary">...</p>
<p class="text-success">...</p>
<p class="text-info">...</p>
<p class="text-warning">...</p>
<p class="text-danger">...</p>

<div class="alert alert-success">...</div>
<div class="alert alert-info">...</div>
<div class="alert alert-warning">...</div>
<div class="alert alert-danger">...</div>
*/

function bs_Alert($alerttype,$alerttext)
{
    echo '<div class="alert alert-'.$alerttype.'">'.$alerttext.'</div>';
}

function bs_Para($ptype,$ptext)
{
    echo '<p class="text-'.$ptype.'">'.$ptext.'</p>';
}