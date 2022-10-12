# frozen_string_literal: true

module Renalware
  module Patients
    class MDMsController < BaseController
      include Renalware::Concerns::Pageable
      include Pagy::Backend

      class MDMListOptions
        attr_reader_initialize [
          :search!,
          :rows!,
          :current_view!,
          :view_proc!,
          :pagination!
        ]
      end

      # rubocop:disable Metrics/MethodLength
      def show
        authorize Patient, :index?
        sql_view_klass = Reporting::SqlView.new(view_name).klass
        sql_view_klass.reset_column_information
        search = sql_view_klass.ransack(params[:q])
        view_proc = lambda { |patient|
          send(:"patient_#{scope_name}_mdm_path", patient_id: patient.secure_id)
        }
        pagy, patients = pagy(search.result)
        options = MDMListOptions.new(
          search: search,
          rows: patients.load,
          current_view: current_view,
          view_proc: view_proc,
          pagination: pagy
        )
        render locals: { options: options }
      end
      # rubocop:enable Metrics/MethodLength

      private

      # Some 'mdm' entries in system.view_metadata have a #scope that does not yet have its own
      # MDM patient view so we use a default scope for when building the route to the mdm view.
      def scope_name
        default_scope = "low_clearance"
        case current_view.scope
        when "akcc", "supportive_care", "dietetic" then default_scope
        else current_view.scope
        end
      end

      def view_name
        "#{current_view.schema_name}.#{current_view.view_name}"
      end

      def current_view
        @current_view ||=
          views.detect { |vw| vw.slug == params.fetch(:filter, "all") } || views.first
      end

      def views
        @views ||= begin
          scope = params[:scope]
          System::ViewMetadata.where(
            category: "mdm",
            scope: scope
          ).tap do |relation|
            if relation.empty?
              raise "No SQL views for found for category 'mdm' scope: '#{scope}'"
            end
          end
        end
      end

      # class SqlView
      #   pattr_initialize :view_name

      #   # Create a class under Renalware:: for this SQL name
      #   # Note that Ransack search_form_for requires our otherwise anonymous class to have a name.
      #   def klass
      #     return Renalware.const_get(class_name) if class_exists?

      #     underlying_view_name = view_name
      #     Class.new(ApplicationRecord) do
      #       self.table_name = underlying_view_name
      #       define_method(:to_s, ->(_x) { patient_name })
      #       define_method(:to_param, -> { secure_id })
      #     end.tap do |klass|
      #       Renalware.const_set(class_name, klass)
      #       # klass.connection # not sure this is required.
      #     end
      #   end

      #   private

      #   def class_name
      #     @class_name ||= begin
      #       unless view_name.match?(/^[.a-z_0-9]*$/)
      #         raise ArgumentError, "Invalid view name '#{view_name}'"
      #       end

      #       "AnonymousView#{view_name.split('.').last.camelcase}"
      #     end
      #   end

      #   def class_exists?
      #     Renalware.const_get(class_name)
      #   rescue NameError
      #     false
      #   end
      # end
    end
  end
end
