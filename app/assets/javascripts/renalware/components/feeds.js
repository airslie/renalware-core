$(document).ready(function(){
  $(".hl7-file-browser a").on("click", function(e) {
    console.log($(this).data("body"));
    $("#feeds_hl7_test_form_body").val($(this).data("body"))
  });

//   $(".file-viewer form").on("submit", function(event) {
//     console.log("asassas");
//     event.preventDefault();
//     console.log(this)

//     var valuesToSubmit = this.el.serialize();
//     var self = this;
// //#url: self.el.attr("action"), //submits it to the given url of the form

//     $.ajax({
//       type: "POST",
//       data: valuesToSubmit,
//       dataType: "JSON",
//       statusCode: {
//         201: function(contact) {
//           // self._onSuccess(contact);
//           console.log("asass")
//         },
//         400: function(jqXHR) {
//           var errors = jqXHR.responseJSON;
//           // self._onErrors(errors);
//           console.log("error")
//         }
//       }
//     });
//   });

  // this.el.on("submit", function(event) { self._onSubmit(event) });
  // $.ajax({
  //   type: "POST",
  //   url: self.el.attr("action"), //submits it to the given url of the form
  //   data: valuesToSubmit,
  //   dataType: "JSON",
  //   statusCode: {
  //     201: function(contact) {
  //       self._onSuccess(contact);
  //     },
  //     400: function(jqXHR) {
  //       var errors = jqXHR.responseJSON;
  //       self._onErrors(errors);
  //     }
  //   }
  // });
});
