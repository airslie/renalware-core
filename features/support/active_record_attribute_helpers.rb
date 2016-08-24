module ActiveRecordAttributeHelpers
  def bool_from_string(value)
    ActiveRecord::Type::Boolean.new.type_cast_from_user(value)
  end
end

World(ActiveRecordAttributeHelpers)
