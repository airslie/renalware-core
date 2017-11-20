require "rails_helper"
require "liquid"

module Renalware
  module System
    describe RenderLiquidTemplate do
      describe "#call" do
        class TestPatientDrop < Liquid::Drop
          def name
            "John Smith"
          end
        end

        def template
          Template.new(name: "test",
                       description: "test",
                       body: "<h1>{{ patient.name }}</hi>")
        end

        it "finds and renders a liquid template" do
          expect(Template).to receive(:find_by!).and_return(template)

          output = RenderLiquidTemplate.call(template_name: "test",
                                             variables: { "patient" => TestPatientDrop.new })

          expect(output).to eq("<h1>John Smith</hi>")
        end

        it "raises an error if the correct variable was not passed" do
          expect(Template).to receive(:find_by!).and_return(template)

          expect {
            RenderLiquidTemplate.call(template_name: "test")
          }.to raise_error(Liquid::UndefinedVariable)
        end

        it "raises an error if the template is not found" do
          expect {
            RenderLiquidTemplate.call(template_name: "nonexistent_template_name")
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
