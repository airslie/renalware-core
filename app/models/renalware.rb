module Renalware
  def self.table_name_prefix
    # 'renalware_' # TODO: eventually, prefix the tables
    ''
  end

  def self.use_relative_model_naming?
    true
  end
end
