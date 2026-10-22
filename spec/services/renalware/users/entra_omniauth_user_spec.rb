describe Renalware::Users::EntraOmniauthUser do
  let!(:clinical_role) { create(:role, :clinical, ad_role_name: "renalware-clinical") }
  let!(:readonly_role) { create(:role, :read_only, ad_role_name: "renalware-readonly") }
  let!(:hospital_centre) { create(:hospital_centre, :default) }
  let(:tenant_id) { "11111111-2222-3333-4444-555555555555" }
  let(:app_roles) { ["Renalware-Clinical"] }
  let(:email) { "JOE.BLOGGS@EXAMPLE.COM" }
  let(:auth) do
    OmniAuth::AuthHash.new(
      provider: "entra_id",
      uid: "#{tenant_id}object-id-1",
      info: { email:, first_name: "Joe", last_name: "Bloggs" },
      extra: { raw_info: { "tid" => tenant_id, "roles" => app_roles } }
    )
  end

  let(:service_call) { -> { described_class.new(auth:).call } }

  before do
    allow(Renalware.config).to receive_messages(
      ldap_auto_approve_users: true,
      entra_tenant_id: tenant_id,
      entra_link_users_by_email: false
    )
  end

  it "creates an approved user with the roles from the Entra app roles claim" do
    user = described_class.new(auth:).call

    expect(user).to be_persisted
    expect(user).to have_attributes(
      azure_uid: auth.uid,
      email: "joe.bloggs@example.com",
      given_name: "Joe",
      family_name: "Bloggs",
      approved: true,
      hospital_centre:
    )
    expect(user.roles.reload).to contain_exactly(clinical_role)
  end

  it "does not give a new user the default clinical role when they hold a read-only app role" do
    auth.extra.raw_info["roles"] = ["renalware-readonly"]

    user = described_class.new(auth:).call

    expect(user.roles.reload).to contain_exactly(readonly_role)
  end

  it "rejects a new user with no managed app role and does not create them" do
    auth.extra.raw_info["roles"] = ["SomethingElse"]

    expect { described_class.new(auth:).call }
      .to raise_error(described_class::NotAuthorisedError)
      .and not_change(Renalware::User, :count)
  end

  it "rejects a user when the token has no roles claim" do
    auth.extra.raw_info.delete("roles")

    expect { described_class.new(auth:).call }
      .to raise_error(described_class::NotAuthorisedError)
  end

  it "rejects an existing user who no longer holds a managed app role" do
    create(:user, :minimal, azure_uid: auth.uid, roles: [clinical_role])
    auth.extra.raw_info["roles"] = []

    expect { described_class.new(auth:).call }
      .to raise_error(described_class::NotAuthorisedError)
  end

  it "rejects a token issued by a different tenant" do
    auth.extra.raw_info["tid"] = "99999999-2222-3333-4444-555555555555"

    expect { described_class.new(auth:).call }
      .to raise_error(described_class::NotAuthorisedError, /tenant/i)
  end

  it "rejects sign-in when no tenant has been configured" do
    allow(Renalware.config).to receive(:entra_tenant_id).and_return(nil)

    expect { described_class.new(auth:).call }
      .to raise_error(described_class::NotAuthorisedError, /tenant/i)
  end

  it "syncs roles for an existing user matched by azure_uid" do
    user = create(:user, :minimal, azure_uid: auth.uid, roles: [readonly_role])

    described_class.new(auth:).call

    expect(user.roles.reload).to contain_exactly(clinical_role)
  end

  it "leaves approval, centre and profile of an existing user untouched" do
    other_centre = create(:hospital_centre)
    user = create(
      :user,
      :minimal,
      azure_uid: auth.uid,
      approved: false,
      hospital_centre: other_centre,
      given_name: "Existing",
      roles: [clinical_role]
    )

    described_class.new(auth:).call

    expect(user.reload).to have_attributes(
      approved: false,
      hospital_centre: other_centre,
      given_name: "Existing"
    )
  end

  context "when an unlinked user already has the same email" do
    let!(:existing_user) do
      create(
        :user,
        :minimal,
        email: "joe.bloggs@example.com",
        approved: false,
        given_name: "Legacy",
        roles: [readonly_role]
      )
    end

    it "does not link the account by email by default" do
      expect(service_call).to raise_error(described_class::NotAuthorisedError, /already exists/i)

      expect(existing_user.reload.azure_uid).to be_nil
    end
  end

  context "when an unlinked user has the same email and linking by email is enabled" do
    let!(:existing_user) do
      create(
        :user,
        :minimal,
        email: "joe.bloggs@example.com",
        approved: false,
        given_name: "Legacy",
        roles: [readonly_role]
      )
    end

    before do
      allow(Renalware.config).to receive(:entra_link_users_by_email).and_return(true)
    end

    it "links the azure_uid and syncs roles without resetting approval or centre" do
      other_centre = create(:hospital_centre)
      existing_user.update!(hospital_centre: other_centre)

      described_class.new(auth:).call

      expect(existing_user.reload).to have_attributes(
        azure_uid: auth.uid,
        approved: false,
        given_name: "Legacy",
        hospital_centre: other_centre
      )
      expect(existing_user.roles.reload).to contain_exactly(clinical_role)
    end
  end

  context "when roles come from the groups claim" do
    before { auth.extra.raw_info.delete("roles") }

    it "grants roles from group names such as a synced sAMAccountName" do
      auth.extra.raw_info["groups"] = %w(Renalware-Clinical Some-Other-Group)

      user = described_class.new(auth:).call

      expect(user.roles.reload).to contain_exactly(clinical_role)
    end

    it "grants roles from groups emitted as distinguished names" do
      auth.extra.raw_info["groups"] = ["CN=Renalware-ReadOnly,OU=Groups,DC=example,DC=com"]

      user = described_class.new(auth:).call

      expect(user.roles.reload).to contain_exactly(readonly_role)
    end

    it "grants roles from group object ids when the role's ad_role_name is the group id" do
      clinical_role.update!(ad_role_name: "0a1b2c3d-0000-1111-2222-333344445555")
      auth.extra.raw_info["groups"] = ["0a1b2c3d-0000-1111-2222-333344445555"]

      user = described_class.new(auth:).call

      expect(user.roles.reload).to contain_exactly(clinical_role)
    end

    it "combines groups with the roles claim, with clinical taking priority over read only" do
      auth.extra.raw_info["roles"] = ["renalware-readonly"]
      auth.extra.raw_info["groups"] = ["renalware-clinical"]

      user = described_class.new(auth:).call

      expect(user.roles.reload).to contain_exactly(clinical_role)
    end

    it "rejects a user whose groups match no managed role" do
      auth.extra.raw_info["groups"] = ["Unrelated-Group"]

      expect(service_call).to raise_error(described_class::NotAuthorisedError)
    end

    it "warns and relies on the roles claim when the group list was too long to include" do
      auth.extra.raw_info["_claim_names"] = { "groups" => "src1" }
      auth.extra.raw_info["roles"] = ["renalware-readonly"]
      allow(Rails.logger).to receive(:warn)

      user = described_class.new(auth:).call

      expect(user.roles.reload).to contain_exactly(readonly_role)
      expect(Rails.logger).to have_received(:warn).with(/groups claim overage/i)
    end
  end

  it "raises a validation error when the token has no email or name" do
    auth.info.email = nil
    auth.info.first_name = nil

    expect { described_class.new(auth:).call }
      .to raise_error(ActiveRecord::RecordInvalid)
  end
end
