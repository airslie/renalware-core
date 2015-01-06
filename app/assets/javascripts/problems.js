$(document).ready(function() {

  $("a.add-problem").click(function(e) {
    e.preventDefault();
    var next_number =  $(".problem-form").data("index") + 1;
    $(".problem-form").data("index", next_number);

    var new_problem = $(".problem-form").html();

    var update_markup = new_problem.replace(/\d/g, next_number);

    $("#additional-form").append(update_markup);

  });

  $('.snomed-lookup').change(function(e) {

    var entered_text = e.currentTarget.value;

    $.ajax({
      url: '/snomed.json?snomed_term=' + entered_text,
      success: function(json) {
        for(var i = 0; i < json.length; i++) {
          var snomed_id = json[i].id;
          var snomed_term = json[i].concept;
          var term = _.template("<li class='snomed-select-link' data-snomed-id=<%= id %>><%= term %></li>")({ id: snomed_id, term: snomed_term });
          $('.snomed-results').append(term);
        }
      }
    });
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