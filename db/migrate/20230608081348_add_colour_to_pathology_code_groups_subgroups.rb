class AddColourToPathologyCodeGroupsSubgroups < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      # This enum comprises tailwindcss colour names. The idea is that in several tables
      # (eg pathology_code_groups.subgroup_colours and pathology_descriptions.colour) a color
      # configuration can be that will affect the UI. The chosen colour will be interpolated into
      # a tailwindcss class name eg bg-emerald-100. This allows more control than the more open
      # alternative of allowing any html #colorref from being entered, which could lead to elements
      # of the UI becoming unreadable in the worst case.
      # In the event that we stop using tailwindcss, the names can be mapped to custom css classes.
      create_enum :enum_colour_name, %w(
        slate
        gray
        zinc
        neutral
        stone
        red
        orange
        amber
        yellow
        lime
        green
        emerald
        teal
        cyan
        sky
        blue
        indigo
        violet
        purple
        fuchsia
        pink
        rose
      )
      add_column :pathology_code_groups, :subgroup_colours, :enum_colour_name, array: true
      add_column :pathology_code_groups, :subgroup_titles, :text, array: true, default: []
    end
  end
end
