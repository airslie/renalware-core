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

  /**
   * TODO: Create a Snomed namespace for these functions and test them!
   */
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
          semantic_tag: 'disorder'
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
    var $form = $(e.target).closest('form'),
        $snomedId = $form.find('.selected-snomed-id'),
        $snomedDescription = $form.find('.selected-snomed-description');

    if (typeof e.params.data.id != 'undefined') {
      $snomedId.val(e.params.data.id);
      $snomedDescription.val(e.params.data.text);
    }
  });
});
