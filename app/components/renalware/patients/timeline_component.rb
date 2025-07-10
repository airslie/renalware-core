module Renalware
  class Patients::TimelineComponent < Base
    PER_PAGE = 100

    def initialize(patient:, current_user:, **attrs)
      @patient = patient
      @current_user = current_user
      @total = ::Renalware::Patients::Timeline.all(patient)
      @items = @total.page(1, limit: PER_PAGE)
      super(**attrs)
    end

    def render? = true

    def view_template
      div(class: "summary-part--timeline") do
        article do
          article_header
          Table(class: %w(toggleable), data: { controller: "toggle" }) do
            table_header
            items.each do
              klass = NameService.from_model(it.record, to: "TimelineRow")
              render klass.new(sort_date: it.sort_date, record: it.record)
            end
          end
        end
      end
    end

    private

    attr_reader :items

    # TODO: Consider moving out as a separate component
    def rows_toggler
      a(
        href: "#",
        data: { action: "toggle#table", turbo: "false" },
        class: "toggler",
        title: "Toggle all rows"
      ) { i }
    end

    def title_friendly_collection_count(actual, total)
      total > actual ? "#{actual} of #{total}" : actual
    end

    def count
      title_friendly_collection_count(@items.count, @total.count)
    end

    def article_header
      header do
        h1 do
          a(href: patient_timeline_path(@patient)) do
            "Timeline (#{count})"
          end
        end
      end
    end

    def table_header
      TableHeader do
        TableRow do
          TableHead(class: %w(togglers noprint)) { rows_toggler }
          TableHead(class: %w(col-width-medium font-bold)) { "Date" }
          TableHead(class: "font-bold") { "Type" }
          TableHead(class: "font-bold") { "Description" }
          TableHead(class: %w(col-width-medium font-bold)) { "Created by" }
        end
      end
    end
  end
end
