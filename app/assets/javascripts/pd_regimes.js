// Define the global Renalware namespace if not already defined.
var Renalware = typeof Renalware == 'undefined' ? {} : Renalware;

// Define the Renalware.PdRegimes closure.
Renalware.PdRegimes = (function () {
  // private functions and vars here

  // public functions and vars here
  return {
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
$(document).ready(Renalware.PdRegimes.toggleAddRemoveBags);
$(document).on('nested:fieldAdded:pd_regime_bags',
    Renalware.PdRegimes.toggleAddRemoveBags);
