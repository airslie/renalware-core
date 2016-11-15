// Define the global Renalware namespace if not already defined.
var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

// Define the Renalware.PdRegimes closure.
Renalware.PdRegimes = (function () {
  // private functions and vars here
  var deselectAllBagDays = function() {
    $(document).on( "click", "a.deselect-bag-days", function(event) {
      event.preventDefault();
      var parent = $(this).closest(".bag-days");
      var checkboxes = $(parent).find("input[type='checkbox']");
      checkboxes.prop('checked', false);
    });
  }

  // public functions and vars here
  return {
    init : function() {
      deselectAllBagDays();
    },
    toggleAddRemoveBags : function () {
      $('input.add-bag').hide();
      $('input.remove-bag').hide();
      $('a.add-bag').show();
      $('a.remove-bag').show();
    }
  }
})();
// Bind DOM ready and nested_form:fieldAdded events
// so that buttons are toggled when JS is active.
$(document).ready(Renalware.PdRegimes.init);
$(document).ready(Renalware.PdRegimes.toggleAddRemoveBags);
$(document).on('nested:fieldAdded:regime_bags', Renalware.PdRegimes.toggleAddRemoveBags);


