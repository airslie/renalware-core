var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.PrimaryCarePhysicianSearch = (function() {

  var formatPractice = function(practice) {
    return practice.name;
  };

  var formatPracticeSelection = function(practice) {
    return practice.name;
  };

  var initPracticeAutocomplete = function(){
    var practiceDropDown = $("#practice-search");

    $(practiceDropDown).select2({
      language: {
        inputTooShort: function(args) {
          return $(practiceDropDown).data("hint");
        }
      },
      ajax: {
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            q: params.term
          };
        },
        processResults: function (data, params) {
          return {
            results: data
          };
        },
        cache: true
      },
      escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
      minimumInputLength: 3,
      templateResult: formatPractice,
      templateSelection: formatPracticeSelection
    }).select2('open');

    // When a Practice is selected from the autocomplete list,
    // Do an ajax replace on the <form> in this modal by sendin a .js request
    // to the url the modal was loaded from (this is in a data attribute on the pratice-search
    // select). This will load in just the form under the practice-search select, bringing
    // with it a list of pcps associated with this practice.
    $(practiceDropDown).on("select2:select", function(e) {
      var selectedPracticeOption = $("option:selected", this);
      var praticeId = $(selectedPracticeOption).val();
      var formRefreshUrl = $(this).data("form-refresh-url");

      $.ajax(formRefreshUrl, {
        type: 'GET',
        dataType: 'script',
        data: {
          practice_id: praticeId
        },
        error: function(jqXHR, textStatus, errorThrown) {
          console.log(errorThrown, textStatus ,jqXHR)
        },
        success: function(data, textStatus, jqXHR) {
          // console.log("OK!")
        }
      });
    });

  };
  return {
    init: function () {
      initPracticeAutocomplete()
    }
  };
})();

$(document).on('opened.fndtn.reveal', '[data-reveal]', Renalware.PrimaryCarePhysicianSearch.init);

