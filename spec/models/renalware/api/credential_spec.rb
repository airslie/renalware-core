describe Renalware::API::Credential do
  describe ".issue!" do
    it "returns the token once and stores only its digest" do
      issued = described_class.issue!(
        user: create(:user),
        name: "Mirth outgoing documents",
        scopes: [described_class::OUTGOING_DOCUMENTS_READ]
      )

      expect(issued.token).to be_present
      expect(issued.credential).to have_attributes(
        token_digest: described_class.digest(issued.token),
        token_prefix: issued.token.first(8)
      )
      expect(issued.credential.attributes.values).not_to include(issued.token)
    end

    it "rejects unsupported scopes" do
      credential = described_class.new(
        user: create(:user),
        name: "Invalid credential",
        scopes: ["everything:write"],
        token_digest: described_class.digest("token"),
        token_prefix: "token"
      )

      expect(credential).not_to be_valid
      expect(credential.errors[:scopes].to_sentence).to include("unsupported")
    end
  end

  describe ".authenticate" do
    it "returns the enabled, unexpired credential for a valid token" do
      issued = described_class.issue!(
        user: create(:user),
        name: "Mirth",
        scopes: [described_class::PATIENTS_READ]
      )

      expect(described_class.authenticate(issued.token)).to eq(issued.credential)
    end

    it "does not authenticate a disabled credential" do
      issued = described_class.issue!(
        user: create(:user),
        name: "Mirth",
        scopes: [described_class::PATIENTS_READ]
      )
      issued.credential.update!(enabled: false)

      expect(described_class.authenticate(issued.token)).to be_nil
    end

    it "does not authenticate an expired credential" do
      issued = described_class.issue!(
        user: create(:user),
        name: "Mirth",
        scopes: [described_class::PATIENTS_READ],
        expires_at: 1.minute.ago
      )

      expect(described_class.authenticate(issued.token)).to be_nil
    end
  end

  describe "#permits?" do
    it "only permits an assigned scope" do
      credential = described_class.new(scopes: [described_class::PATIENTS_READ])

      expect(credential).to be_permits(described_class::PATIENTS_READ)
      expect(credential).not_to be_permits(described_class::MEDICATIONS_READ)
    end
  end
end
