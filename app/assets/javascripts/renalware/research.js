var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Research = (function() {
  var focusPatientInput = function() {
    $('.patient-ajax-search').select2('open');
    $('select2-patient-ajax-search-container .select2-search__field').focus();
  };

  return {
    init: function () {
      initDatepickersIn(".modal");
      Renalware.PatientSearch.init();
      focusPatientInput();
    }
  };
})();

$(document).on('opened.fndtn.reveal', '#study-participant-modal', Renalware.Research.init);
