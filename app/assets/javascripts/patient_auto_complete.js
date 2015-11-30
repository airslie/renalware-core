$(document).ready(function() {
  $("[data-autocomplete-source]").each(function() {
    var url = $(this).data("autocomplete-source");
    var target = $(this).data("autocomplete-rel");
    $(this).autocomplete({
      minLength: 2,
      source: function(request,response) {
        var path = url + "?term=" + request.term
        $.getJSON(path, function(data) {
          var list = $.map(data, function(patient) {
            return {
              label: patient.unique_label,
              value: patient.unique_label,
              id: patient.id
            };
          });
          response(list);
        })
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
