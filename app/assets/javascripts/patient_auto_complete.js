$(document).ready(function() {
  $("[data-autocomplete-source]").each(function() {
    var url = $(this).data("autocomplete-source");
    var target = $(this).data("autocomplete-rel");
    $(this).autocomplete({
      minLength: 2,
      source: function(request,response) {
        $.ajax({
          url: url,
          data: { term: request.term },
          success: function(data) {
            var list = $.map(data, function(patient) {
              return {
                label: patient.label,
                id: patient.id
              };
            });
            response(list);
          },
          error: function(jqXHR, textStatus, errorThrown) {
            var msg = "An error occurred.  Please contact an administrator.";
            response({ label: msg, id: 0});
          }
        });
      },
      search: function(event, ui) {
        $(target).val("");
      },
      select: function(event, ui) {
        $(target).val(ui.item.id);
      }
    });
  });
});
