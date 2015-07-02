module Personable
  extend ActiveSupport::Concern

  included do
    class_eval do
      validates_presence_of :first_name, :last_name
    end

    def full_name
      to_s(:full_name)
    end

    alias_method :orig_to_s, :to_s

    def to_s(format=nil)
      case format
      when :full_name
        "#{first_name} #{last_name}"
      when :last_first
        "#{last_name}, #{first_name}"
      else
        orig_to_s
      end
    end
  end
end
