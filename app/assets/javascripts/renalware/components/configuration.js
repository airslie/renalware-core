var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;
Renalware.Configuration = function(){
  // configuration, change things here
  var config = {
    disable_inputs_controlled_by_tissue_typing_feed: false,
    disable_inputs_controlled_by_demographics_feed: false
  };

  var init = function(optional_config) {
    // provide for custom configuration via init()
    if (optional_config && typeof(optional_config) == 'object') {
        $.extend(Renalware.Configuration.config, optional_config);
    }
  }
  // make init a public method
  return {
    config:config,
    init:init
  };
}();
