$(document).ready(function() {

  $("a.add-problem").click(function(e) {
    e.preventDefault();
    var next_number =  $("#new-probs-template").data("index") + 1;
    $("#new-probs-template").data("index", next_number);

    var new_problem = $("#new-probs-template").html();

    var update_markup = new_problem.replace(/\d/g, next_number);

    $("#additional-form").append(update_markup);


  });

  $('.snomed-lookup').change(function(e) {
    var whateverWeTypedInTheBox = e.currentTarget.value;

    $.ajax({
      url: '/snomed.json?snomed_term=' + whateverWeTypedInTheBox,
      success: function(json) {
        for(var i = 0; i < json.length; i++) {
          var snomed_term = json[i];
          var term = _.template("<li todo='add a data attribute'><%= term %></li>");
          $('.snomed-results').append(term({ term: snomed_term.concept }));
        }
      }
    });
  });

  // TODO - add a click event to the snomed result li items
  // that sticks the snomedid into the hidden field


});