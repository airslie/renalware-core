$(document).ready(function() {

  $("a.add-problem").click(function(e) {
    e.preventDefault();
    var nextNumber =  $(".problem-form").data("index") + 1;
    $(".problem-form").data("index", nextNumber);

    var newProblem = $(".problem-form").html();

    var updateNumberMarkup = newProblem.replace(/\d/g, nextNumber);

    var updatedMarkup = updateNumberMarkup.replace("add-x", "fi-x");

    $("#additional-form").append(updatedMarkup);

    $(".fi-x").click(function(e) {
      $(e.currentTarget).closest(".problem-form").remove();
    });

  });

  var $snomedSelect2 = $('#snomed_term');

  $snomedSelect2.select2({
    minimumInputLength: 3,
    width: '100%',
    placeholder: 'Search for a snomed term',
    ajax: {
      url: '/snomed',
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          snomed_term: params.term, // search term
          page: params.page
        };
      },
      processResults: function (data, page) {
        return {
          results: $.map(data.matches, function(m) {
            return { id: m.conceptId, text: m.term }
          })
        };
      },
      cache: true
    }
  });

  $snomedSelect2.on("select2:select", function(e) {
    var $snomedIdField = $(e.target).closest('form').find('.selected-snomed-id');
    $snomedIdField.val(e.params.data.id);
  });
});
