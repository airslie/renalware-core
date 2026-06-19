describe Renalware::Heidi::LinkedAccountProbe do
  describe ".query_users" do
    it "finds users by email, given name, or family name" do
      matching_email = create(:user, email: "renal@example.com", family_name: "Other")
      matching_family_name = create(:user, email: "other@example.com", family_name: "Renal")
      create(:user, email: "miss@example.com", family_name: "Other")

      expect(described_class.query_users("renal")).to contain_exactly(
        matching_email,
        matching_family_name
      )
    end
  end

  describe "#call" do
    subject(:probe) { described_class.new(users: [user], client:, output:) }

    let(:user) do
      build_stubbed(
        :user,
        id: 123,
        email: "dr@example.com",
        uuid: "99f3fb36-dcbc-4c89-9138-c4ed04476a18"
      )
    end
    let(:client) { instance_double(Renalware::Heidi::Client) }
    let(:output) { StringIO.new }

    it "prints local user identifiers and Heidi linked-account details" do
      allow(client).to receive(:linked_account_access).with(user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: true,
          status: 200,
          body: {
            "is_linked" => true,
            "account" => { "ehr_email" => "dr@example.com" }
          }
        )
      )

      probe.call

      expect(JSON.parse(output.string)).to include(
        "renalware_user" => include(
          "id" => 123,
          "email" => "dr@example.com",
          "uuid" => "99f3fb36-dcbc-4c89-9138-c4ed04476a18"
        ),
        "heidi" => include(
          "is_linked" => true,
          "account" => { "ehr_email" => "dr@example.com" }
        )
      )
    end

    it "prints Heidi errors for users that cannot be checked" do
      allow(client).to receive(:linked_account_access).with(user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: false,
          status: 403,
          body: {},
          error: "not linked"
        )
      )

      probe.call

      expect(JSON.parse(output.string)).to include(
        "heidi" => include(
          "success" => false,
          "status" => 403,
          "error" => "not linked"
        )
      )
    end
  end
end
