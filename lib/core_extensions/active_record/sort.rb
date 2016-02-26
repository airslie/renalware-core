# Adds a sort method to ActiveRecord class.  Given a list of IDs, it will sort
# the records in the order of the ids.  Assumes that the model has the :position attribute.
#
# ActiveRecord::Base.class_eval do
#    include RailsExtensions::ActiveRecord::Sort
# end

module CoreExtensions
  module ActiveRecord
    module Sort
      def self.included(base)
        base.extend ClassMethods

        base.before_create :set_position
      end

      module ClassMethods
        def sort(ids)
          ids.each_with_index do |id, index|
            where(id: id).update_all(["position=?", index + 1])
          end
        end
      end

      def set_position
        return unless respond_to?(:position)
        self.position = (self.class.where("position < 99999").maximum(:position) || 0) + 1
      end
    end
  end
end