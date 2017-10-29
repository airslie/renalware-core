// Generic select2 ajax search for patients.
// Example usage
//   select#patient-ajax-search("data-ajax--url" => search_patients_path(format: :json))
//

var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.PatientSearch = (function() {

  var initPatientSearch = function(){
    var dropDown = $(".patient-ajax-search");
    console.log(dropDown);

    $(dropDown).select2({
      language: {
        inputTooShort: function(args) {
          return $(dropDown).data("hint");
        }
      },
      ajax: {
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            term: params.term
          };
        },
        processResults: function (data, params) {
          return {
            results: data
          };
        },
        cache: true
      },
      minimumInputLength: 3
    });
  };

  return {
    init: function () {
      initPatientSearch()
    }
  };
})();

$(document).ready(Renalware.PatientSearch.init);
$(document).on('opened.fndtn.reveal', '[data-reveal]', function() {
  Renalware.PatientSearch.init();
});
