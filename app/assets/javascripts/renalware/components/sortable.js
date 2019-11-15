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
          success: function(sortedArrayOfModelIds) { // eg ["4", "3", "1", "2"]
            $(elem).effect("highlight", {}, 1000);
            // If the the sorted element and its siblings have a child element with a
            // .sortable-position-for-model-id-X class, update the content of each
            // with the new position returned from the server.
            // This lets us display the new sort order position eg for each row in a table
            // without having to reload all the sortables.
            var parent = $(elem).parent(".sortables")
            for (var position = 0; position < sortedArrayOfModelIds.length; position++) {
              modelId = sortedArrayOfModelIds[position];
              var sortable = $(".sortable-position-for-model-id-" + modelId, parent);
              $(sortable, parent).html(position + 1);
            };
          }
        });
      }
    }).disableSelection();
  }
}

$(function() {
  initSortables();
});
