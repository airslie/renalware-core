// Based on https://css-tricks.com/row-and-column-highlighting/
// For tables with a class column_hover, highight the column the user is
// hovering over.

$(function() {
  $("table.column_hover").delegate('td','mouseover mouseleave', function(e) {
    if (e.type == 'mouseover') {
      $(this).parent().addClass("hover");
      $("colgroup").eq($(this).index()).addClass("hover");
    }
    else {
      $(this).parent().removeClass("hover");
      $("colgroup").eq($(this).index()).removeClass("hover");
    }
  });
});
