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
  

  $('.snomed-lookup').change(function(e) {

    var enteredText = e.currentTarget.value;

    $.ajax({
      url: '/snomed.json?snomedTerm=' + enteredText,
      success: function(json) {
        for(var i = 0; i < json.length; i++) {
          var snomed_id = json[i].id;
          var snomed_term = json[i].label;
          var term = _.template("<li class='snomed-select-link' data-snomed-id=<%= id %>><%= term %></li>")({ id: snomed_id, term: snomed_term });
          $('.snomed-results').append(term);
        }
      }
    });
  });

  $('body').on('click', '.snomed-select-link', function(e) {
    var $bullet = $(e.currentTarget);
    var $problemForm = $bullet.closest('.problem-form');
    var snomedId = bullet.data('snomed-id');
    console.log("clicked on a snomed term" + snomedId);
    problemForm.find('.selected-snomed-id').val(snomedId);

    // Show the selected drug
    problemForm.find('.snomed-lookup').val(bullet.html());
    problemForm.find('.snomed-results').hide();

  });

});
