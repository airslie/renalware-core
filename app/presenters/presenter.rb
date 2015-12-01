module Presenter
  def self.for(value)
    begin
      klass = "#{value.class.name}Presenter".constantize
      klass.send(:new, value)
    rescue NameError
      value.to_s
    end
  end
end
