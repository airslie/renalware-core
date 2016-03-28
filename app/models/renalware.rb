module Renalware
  VERSION = "2.0.0 BETA1".freeze

  def self.table_name_prefix
    # 'renalware_' # TODO: eventually, prefix the tables
    ''
  end

  def self.use_relative_model_naming?
    true
  end
end
