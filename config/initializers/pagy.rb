# frozen_string_literal: true

#
# See here for all options: https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb
#

# Foundation extra: Add nav, nav_js and combo_nav_js helpers and templates for Foundation pagination
# See https://ddnexus.github.io/pagy/extras/foundation
require "pagy/extras/foundation"

# Allow the client to request a custom number of items per page with an optional selector UI.
# It is useful with APIs or higly user-customizable apps.
# Usefule for testing pagination from testing by supplying eg :items => 1
require "pagy/extras/items"
