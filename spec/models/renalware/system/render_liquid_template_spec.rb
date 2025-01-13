require "liquid"

module Renalware
  module System
    describe RenderLiquidTemplate do
      describe "#call" do
        let(:test_patient_drop_class) do
          Class.new(Liquid::Drop) do
            def name
              "John Smith"
            end
          end
        end

        def template
          Template.new(name: "test",
                       description: "test",
                       body: "<h1>{{ patient.name }}</hi>")
        end

        it "finds and renders a liquid template" do
          allow(Template).to receive(:find_by!).and_return(template)

          output = described_class.call(
            template_name: "test",
            variables: { "patient" => test_patient_drop_class.new }
          )

          expect(Template).to have_received(:find_by!)
          expect(output).to eq("<h1>John Smith</hi>")
        end

        it "raises an error if the correct variable was not passed" do
          allow(Template).to receive(:find_by!).and_return(template)

          expect {
            described_class.call(template_name: "test")
          }.to raise_error(Liquid::UndefinedVariable)
          expect(Template).to have_received(:find_by!)
        end

        it "raises an error if the template is not found" do
          expect {
            described_class.call(template_name: "nonexistent_template_name")
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
