# frozen_string_literal: true

module Renalware
  # To satisfy zeitwerk we have renamed this file version_number and make sure
  # to creat that class even though its not used. If we don't do this zeitwerk
  # complains that version.rb does export a constant called Version.
  class VersionNumber
    VERSION = "2.0.155"
  end
end
