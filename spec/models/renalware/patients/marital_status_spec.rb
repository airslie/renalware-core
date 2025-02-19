module Renalware
  module Patients
    describe MaritalStatus do
      it :aggregate_failures do
        is_expected.to validate_presence_of :code
        is_expected.to validate_presence_of :name
        is_expected.to have_db_index(:code)
      end

      describe "uniqueness" do
        subject { described_class.new(code: "M", name: "Married") }

        it { is_expected.to validate_uniqueness_of(:code) }
      end
    end
  end
end
