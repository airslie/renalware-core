module Renalware
  class Patients::TimelineComponent < Base
    PER_PAGE = 100

    def initialize(patient:, current_user:)
      super()
      @patient = patient
      @current_user = current_user
      @total = ::Renalware::Patients::Timeline.all(patient)
      @items = @total.page(1, limit: PER_PAGE)
    end

    def render? = true

    def view_template
      div(class: "summary-part--timeline") do
        article do
          header do
            h1 { a(href: patient_timeline_path(@patient)) { "Timeline (#{count})" } }
          end
          Table(class: %w(plx toggleable), data: { controller: "toggle" }) do
            build_header
            build_body
          end
        end
      end
    end

    private

    attr_reader :items

    def rows_toggler
      a(
        href: "#",
        data: { action: "toggle#table", turbo: "false" },
        class: "toggler",
        title: "Toggle all rows"
      ) { i }
    end

    def row_toggler(toggleable)
      return unless toggleable

      a(
        href: "#",
        data: { action: "click->toggle#row", turbo: "false" },
        class: "toggler",
        title: "Toggle"
      ) { i }
    end

    def title_friendly_collection_count(actual, total)
      total > actual ? "#{actual} of #{total}" : actual
    end

    def count
      title_friendly_collection_count(@items.count, @total.count)
    end

    def build_header
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

    def build_body
      items.each do |item|
        TableBody do
          TableRow do
            TableCell(class: "noprint") { row_toggler(item.detail.present?) }
            TableCell { I18n.l(item.date) }
            TableCell { item.type }
            TableCell { item.description }
            TableCell { item.created_by }
          end

          # This is always rendered because we hide the last row automatically and
          # if there is only the one row above that gets hidden. Not great.
          build_detail_row(item.detail) if item.detail.present?
        end
      end
    end

    def build_detail_row(detail)
      TableRow(class: "hidden") do
        TableCell()
        TableCell(colspan: 4) do
          div(class: "text-sm") do
            render detail
          end
        end
      end
    end
  end
end
