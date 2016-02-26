var fixHelper;

fixHelper = function(e, ui) {
  ui.children().each(function() {
    return $(this).width($(this).width());
  });
  return ui;
};

function initSortables() {
  if ($(".sortables").length > 0) {
    $(".sortables").sortable({
      items: ".sortable",
      handle: ".handle",
      helper: fixHelper,
      forceHelperSize: true,
      start: function(e, ui) {
        ui.placeholder.height(ui.item.height());
      },
      update: function(e, ui) {
        var elem = ui.item
        return $.ajax({
          type: 'POST',
          url: $(this).data("rel"),
          dataType: 'json',
          data: $(this).sortable("serialize"),
          success: function() {
            $(elem).effect("highlight", {}, 1000);
          }
        });
      }
    }).disableSelection();
  }
};

$(function() {
  initSortables();
});
