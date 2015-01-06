$(document).ready(function() {
  
  $("a.add-problem").click(function(e) {
    e.preventDefault();
    var next_number =  $(".problem-form").data("index") + 1;
    $(".problem-form").data("index", next_number);

    var new_problem = $(".problem-form").html();

    var update_markup = new_problem.replace(/\d/g, next_number);

    $("#additional-form").append(update_markup);
    
  
  });

  
});