<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php

/*
$nr = number of results
$pp = results per page
$pnp = page navigation pages
$pn = current page
$url = base url to append navigation to
$sr = starting row
//NEW
$navtext = text to append e.g. 'operations recorded'
*/
  $pnav = '';
  $link = '';
  $start = '';
  $previous = '';
  $next = '';
  $end = '';

  if( $pn >= 2 )
  {
    $previous .= " <a href=\"" . $url . "sr=" . ( $sr - $pp );
    $previous .= "&pp=" . $pp . "&cp=" . ( $pn - 1) . "\"><< Back</a> ... ";
  }

  if( $pn < $nr and ( $pn * $pp) < $nr )
  {
    $next .= " ... <a href=\"" . $url . "sr=" . ( $sr + $pp );
    $next .= "&pp=" . $pp . "&cp=" . ( $pn + 1) . "\">Next >></a> ";
  }

  if( $nr > $pp )
  {
    $tp = $nr / $pp;

    if( $tp != intval( $tp ) )
    {
      $tp = intval( $tp) + 1;
    }

    $cp = 0;

    while( $cp++ < $tp )
    {
      if( ( $cp < $pn - $pnp or $cp > $pn + $pnp) and $pnp != 0 )
      {
        if( $cp == 1 )
        {
          $start .= " <a href=\"" . $url;
          $start .= "sr=0&";
          $start .= "pp=" . $pp . "&cp=1\"><< Start</a> ... ";
        }

        if( $cp == $tp )
        {
          $end .= " ... <a href=\"" . $url;
          $end .= "sr=";
          $end .= ( $tp - 1 ) * $pp . "&pp=" . $pp . "&cp=";
          $end .= $tp . "\">End >></a> ... ";
        }
      }
      else
      {
        if( $cp == $pn )
        {
          $link .= ' <span class="selNav">[ ' . $cp . ' ]</span> ';
        }
        else
        {
          $link .= " <a href=\"" . $url;
          $link .= "sr=" . ( $cp - 1) * $pp;
          $link .= "&pp=" . $pp . "&cp=" . $cp . "\">[ $cp ]</a> ";
        }
      }
    }

    $pnav .= $start;
    $pnav .= $previous;
    $pnav .= $link;
    $pnav .= $next;
    $pnav .= $end;
  }

  if( $nr == 0 )
  {
    $nom = 0;
  }
  else
  {
    $nom = 1;
  }

  $pnav .= "  ... #" . ( $sr + $nom );

  if( $pp > 1 )
  {
    $pnav .= " - ";

    if( $sr + $nom + $pp < $nr )
    {
      $pnav .= ( $sr + $nom + $pp ) - 1;
    }
    else
    {
      $pnav .= $nr;
    }
  }

  $pnav .= " of " . $nr . " ";
echo $pnav . ' ' . $navtext . " <i><a href=\"$url&show=all\">Show all</a></i>";
?>