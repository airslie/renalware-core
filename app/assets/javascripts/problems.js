$(document).ready(function() {
  
  $("a.add-problem").click(function(e) {
    e.preventDefault();
    var next_number =  $("#new-probs-template").data("index") + 1;
    $("#new-probs-template").data("index", next_number);

    var new_problem = $("#new-probs-template").html();

    var update_markup = new_problem.replace(/\d/g, next_number);

    $("#additional-form").append(update_markup);
    
  
  });

  
});