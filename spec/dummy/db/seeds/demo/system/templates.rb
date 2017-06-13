module Renalware
  log "Adding Templates" do
     Renalware::System::Template.find_or_create_by!(name: "esi_printable_form") do |template|
      template.title = "ESI Printable Form"
      template.description = "Renders at /patients/1/pd/exit_site_infections/1.pdf as a PDF form "\
                             "a nurse can print"
      template_path = File.join(File.dirname(__FILE__), "templates", "esi_printable_form.html")
      template.body = File.read(template_path)
    end
  end
end
