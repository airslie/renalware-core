$(document).ready(function() {

  $("a.add-problem").click(function(e) {
    e.preventDefault();
    var next_number =  $(".problem-form").data("index") + 1;
    $(".problem-form").data("index", next_number);

    var new_problem = $(".problem-form").html();

    var update_number_markup = new_problem.replace(/\d/g, next_number);

    var updated_markup = update_number_markup.replace("add-x", "fi-x");

    $("#additional-form").append(updated_markup);

    $(".fi-x").click(function(e) {
      $(e.currentTarget).closest(".problem-form").remove();
    });

  });

  var snomedQueryTimeout,
      lastQueryTerm;

  $('.snomed-lookup').bind('keyup', function(e) {
    var enteredText = e.currentTarget.value;

    clearTimeout(snomedQueryTimeout);
    snomedQueryTimeout = setTimeout(function() {
      if (enteredText.length > 2) {
        $.ajax({
          url: '/snomed.json?snomed_term=' + enteredText,
          success: function(json) {
            var len = json.length;
            $('.snomed-results').html('');
            if (len) {
              for(var i = 0; i < len; i++) {
                var snomedId = json[i].id;
                var snomedTerm = json[i].label;
                var term = _.template("<li class='snomed-select-link' data-snomed-id=<%= id %>><%= term %></li>")({ id: snomedId, term: snomedTerm });
                $('.snomed-results').append(term);
              }
            } else {
              $('.snomed-results').html("<li>No results for '" + enteredText + "'</li>");
            }
          }
        });
      } else {
        $('.snomed-results').html("<li>Please enter at least 3 characters</li>");
      }
    }, 500);
  });

  $('body').on('click', '.snomed-select-link', function(e) {
    var bullet = $(e.currentTarget);
    var problem_form = bullet.closest('.problem-form');
    var snomedId = bullet.data('snomed-id');
    console.log("clicked on a snomed term" + snomedId);
    problem_form.find('.selected-snomed-id').val(snomedId);

    // Show the selected drug
    problem_form.find('.snomed-lookup').val(bullet.html());
    problem_form.find('.snomed-results').hide();

  });

});
