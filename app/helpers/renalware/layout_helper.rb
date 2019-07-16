# frozen_string_literal: true

module Renalware
  module LayoutHelper
    # If you don't want the title argument to be used in the browser bar, pass in
    # page_title: in opts also.
    def within_admin_layout(title: nil, **opts)
      within_layout(layout: "renalware/layouts/non_patient",
                    title: opts.fetch(:page_title, title),
                    **opts) { yield }
    end

    def within_patient_layout(title: nil, **opts)
      within_layout(layout: "renalware/layouts/patient",
                    title: title,
                    **opts) { yield }
    end

    def within_non_patient_layout
      within_layout(layout: "renalware/layouts/non_patient",
                    title: opts.fetch(:page_title, title),
                    **opts) { yield }
    end

    def within_new_admin_layout(title: nil, **opts)
      within_layout(layout: "renalware/layouts/admin",
                    title: opts.fetch(:page_title, title),
                    **opts) { yield }
    end

    def within_layout(layout:, title: nil, **opts)
      opts[:title] = title || resolve_page_title_for_layout(title)
      render(layout: layout, locals: opts) { yield }
    end

    # rubocop:disable Lint/HandleExceptions
    def resolve_page_title_for_layout
      t?(".page_title") ? t(".page_title") : t(".title", cascade: false)
    rescue RuntimeError
      # For now, ignore I18n error caused when the host application calls renalware_view
      # - it fails because @virtual_path is nil here.
      # # The error is 't(".xxxx") shortcut because path is not available' and is due to there being
      # a period at the start of the key.
      # This means if a host app overrides a view
      # eg hd/dashboards/show and tha view calls t(".something") then we would get an error.
      # https://apidock.com/rails/v5.2.3/ActionView/Helpers/TranslationHelper/scope_key_by_partial
      # We could do something clever like Spree do to set @virtual_path (search the GH repo).
    end
    # rubocop:enable Lint/HandleExceptions

    def generate_page_title(local_assigns:,
                            patient: nil,
                            separator: Renalware.config.page_title_spearator)
      parts = []
      parts << "#{patient} #{patient.age}y #{patient.sex}" if patient.present?
      parts << Array(local_assigns[:breadcrumbs]).map(&:title)
      parts << local_assigns[:title]
      title = parts.flatten.compact.join(separator)
      content_for(:page_title) { title&.html_safe }
      title
    end

    # Example usage for the edit patient (demographics) page
    # breadcrumbs_and_title(
    #   breadcrumbs: [
    #     Breadcrumb.new(title: "Demographics",
    #                    anchor: link_to("Demographics", patient_path)
    #   ],
    #   title: "Edit"
    # )
    # Returns
    #   Demographics / Edit
    # where Demographics is a link back in the navigation, like a true breadcrumb.
    # :breadcrumbs can be anchors or just a page name, and is single does not need to be an array.
    # :title is normally just a string as it represents the current page, and should not be a link.
    def breadcrumbs_and_title(breadcrumbs: [], title:)
      safe_join(Array(breadcrumbs).map(&:anchor).append(title), " / ")
    end

    # In order for pdf rendering to easily re-use html partials (despite a mime type of :pdf),
    # pass partial rendering code as a block to `with_format`.
    #
    # Example issues and usage trying to render my_partial.html.slim from my_template.pdf.slim:
    #
    #   = render 'my_partial' # cannot resolve the html partial
    #
    #   = render 'my_partial', format: :html # resolves partial but i18n requires an `html:` key
    #
    #   - with_format(:html) do
    #     = render 'my_partial' # resolves the html partial and existing i18n keys are used.
    #
    # See http://stackoverflow.com/questions/339130/how-do-i-render-a-partial-of-a-\
    # different-format-in-rails/3427634#3427634
    def with_format(format)
      old_formats = formats
      begin
        self.formats = [format]
        yield
      ensure
        self.formats = old_formats
      end
    end
  end
end
