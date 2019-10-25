var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.PersonSearch = (function() {

  var initPersonSearch = function(){
    var dropDown = $(".person-ajax-search");

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
      minimumInputLength: 2
    });
  };

  return {
    init: function () {
      initPersonSearch()
    }
  };
}());

$(document).ready(Renalware.PersonSearch.init);
$(document).on('opened.fndtn.reveal', '[data-reveal]', function() {
  Renalware.PersonSearch.init();
});
