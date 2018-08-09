// Generic select2 ajax autocomplete search using Select2
// Example usage (slim):
//   select.select2-ajax-search(
//     data: {
//       "ajax--url" => search_patients_path(format: :json),
//       "default-value" => {id: 23, text: "CROSBY, Bing (1234567913)",
//       "placeholder" => "Start entering the last name (min. 3 characters)"
//     }
//   )
//
//
// For default value to be loaded into the select2 correctly,
// the select  must have a data-value attribute which is a hash in the format
// that would also be returned from the api eg
//   = f.input :x, data: {
//      "default-value" => {id: 23, text: "WRIGHT, Katie (1234567913)",
//      "ajax--url" => "/patients/search.json"
//   }
var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.AjaxSearch = (function() {

  function processData(data) {
    // Note that the json api already formats the data as id: and text: so there
    // is nothing to do here, other than wrap it in a hash, but if that changes use something
    // like this to map the json objects into the {id:, text:} objects select2 expects.
    //   var mapdata = $.map(data, function (obj) {
    //     obj.id = obj.id;
    //     obj.text = obj.text;
    //     return obj;
    //   });
    return { results: data };
  }

  var initAjaxSearch = function(){

    $(".select2-ajax-search").each(function (index, element) {
      var item = $(element);

      // If there is a default item to display in the select2, wrap it in an array
      // and we'll load it in the initial data
      var defaultSelectedItem = [$(item).data("default-value")];

      // A place holder is required if you want to use the X button and allowClear to clear
      // the selection.
      var placeholder = $(item).data("placeholder") || "Start typing (min. 3 characters)";

      $(item).select2({
        allowClear: true,
        placeholder: placeholder,
        ajax: {
          dataType: 'json',
          delay: 250,
          processResults: processData,
          cache: false
        },
        data: processData(defaultSelectedItem).results,
        minimumInputLength: 3,
        escapeMarkup: function (m) { return m; }
      })
    });

    // When the select is cleared using the X link, it does not automatically remove any selected
    // <options>s from the <select> (you can see this e.g. in Chrome tools). So we have to
    // pragmatically do this - and using a timeout prevents clashing with the select2 clear
    // mechanism.
    $('.select2-ajax-search').on('select2:unselect', function (e) {
      var _this = $(this);
      var removeRedundantOptionFromSelect = function() {
        $(_this).html('<option></option>').trigger('change');
      }
      setTimeout(removeRedundantOptionFromSelect, 200);
    });
  };

  return {
    init: function () {
      initAjaxSearch()
    }
  };
}());

$(document).ready(Renalware.AjaxSearch.init);
$(document).on('opened.fndtn.reveal', '[data-reveal]', function() {
  Renalware.AjaxSearch.init();
});
