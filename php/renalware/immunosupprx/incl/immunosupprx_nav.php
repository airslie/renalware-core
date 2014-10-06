<!-- Fixed navbar -->
<div class="navbar navbar-default navbar-fixed-top">
  <a class="navbar-brand" href="user/userhome.php" style="color: #fff; background: #63f"><?php echo $brandlabel ?></a>
<div class="container">
  <div class="collapse navbar-collapse">
    <ul class="nav navbar-nav">
        <li><a href="<?php echo $modulebase ?>/index.php" ><span class="glyphicon glyphicon-th-list"></span> <?php echo $modulelabel ?></a></li>
        
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">Options <b class="caret"></b></a>
          <ul class="dropdown-menu">
<?php
foreach ($pagetitles as $page => $label) {
echo '<li><a href="'.$modulebase.'/'.$page.'.php">'.$label.'</a></li>';
}
?>
          </ul>
        </li>
        
<?php
//if zid
if ($get_zid) {
    //show pat and return link prn
    if ($get_ls) {
        $srclabel=$pagetitles["$get_ls"];
        echo '<li><a href="'.$modulebase.'/'.$get_ls.'.php"><span class="glyphicon glyphicon-list"></span>  '.$srclabel.'</a></li>';
    }
    $label="$title $firstnames " . strtoupper($lastname) . " ($age $sex KCH No: $hospno1 $modalcode)";
    echo '<li class="active"><a href="pat/patient.php?zid='.$zid.'&amp;vw=clinsumm"><span class="glyphicon glyphicon-user"></span> '.$label.'</a></li>';
    
} else {
    //show current page
    $pagelabel=$pagetitles["$thispage"];
    echo '<li class="active"><a href="'.$modulebase.'/'.$thispage.'.php">'.$pagelabel.'</a></li>';
}
?>
     </ul>
     <ul class="nav navbar-nav navbar-right">
       <li><a href="user/userhome.php" style="color: green;"><span class="glyphicon glyphicon-home"></span> <?php echo $user ?></a></li>
       <li><a href="logout.php" style="color: red;">Logout</a></li>
     </ul>
     
  </div><!--/.nav-collapse -->
</div>
</div>