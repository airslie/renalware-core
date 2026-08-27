describe "Lab" do
  let(:connection) { ApplicationRecord.connection }

  before do
    @original_stage = ENV.fetch("RENALWARE_STAGE", nil)
  end

  after do
    @original_stage.nil? ? ENV.delete("RENALWARE_STAGE") : ENV["RENALWARE_STAGE"] = @original_stage
    connection.execute("DROP VIEW IF EXISTS site.lab_global_widget_view")
    connection.execute("DROP TABLE IF EXISTS site.lab_global_widget_rows")
    connection.execute("DROP VIEW IF EXISTS site.lab_global_patient_widget_view")
    connection.execute("DROP TABLE IF EXISTS site.lab_global_patient_widget_rows")
    connection.execute("DROP VIEW IF EXISTS site.lab_patient_widget_view")
    connection.execute("DROP TABLE IF EXISTS site.lab_patient_widget_rows")
    connection.execute("DROP VIEW IF EXISTS renalware.lab_global_widget_view")
    connection.execute("DROP TABLE IF EXISTS renalware.lab_global_widget_rows")
    connection.execute("DROP VIEW IF EXISTS renalware.lab_patient_widget_view")
    connection.execute("DROP TABLE IF EXISTS renalware.lab_patient_widget_rows")
    connection.execute("DROP VIEW IF EXISTS site.generic_patient_widget_view")
    connection.execute("DROP TABLE IF EXISTS site.generic_patient_widget_rows")
  end

  describe "GET /lab" do
    context "when the user has the lab feature flag" do
      it "responds with the lab page" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)

        get lab_path

        expect(response).to be_successful
      end

      it "renders widgets configured for global lab slots" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        widget = create_global_lab_widget
        create_global_lab_widget(schema_name: "renalware", title: "Ignored Global Widget")

        expect { get lab_path }
          .to change(Renalware::System::ViewCall, :count).by(1)

        expect(response.body).to include("Global Lab Widget")
        expect(response.body).to include("Global widget row")
        expect(response.body).not_to include("Ignored Global Widget")
        expect(widget.calls.last.user).to eq(@current_user)
      end

      it "can defer global widget rendering to a turbo frame" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        widget = create_global_lab_widget(async: true)

        expect { get lab_path }
          .not_to change(Renalware::System::ViewCall, :count)

        expect(response.body).to include("Global Lab Widget")
        expect(response.body).to include(%(id="sql-view-widget-#{widget.id}"))
        expect(response.body).to include(system_sql_view_widget_path(widget))
        expect(response.body).not_to include("Global widget row")

        expect {
          get system_sql_view_widget_path(
            widget,
            schema_name: "site",
            slot: "lab:global:top"
          )
        }.to change(Renalware::System::ViewCall, :count).by(1)

        expect(response.body).to include(%(id="sql-view-widget-#{widget.id}"))
        expect(response.body).to include("Global widget row")
        expect(widget.calls.last.user).to eq(@current_user)
      end

      it "does not render async widgets outside their configured lab context" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        widget = create_global_lab_widget(async: true)

        get system_sql_view_widget_path(
          widget,
          schema_name: "site",
          slot: "lab:global:bottom"
        )

        expect(response).to have_http_status(:not_found)
      end

      it "filters global patient widgets through the current patient policy scope" do
        visible_hospital = create(:hospital_centre, code: "VIS", name: "Visible Hospital")
        hidden_hospital = create(:hospital_centre, code: "HID", name: "Hidden Hospital")
        user = create(
          :user,
          :clinical,
          feature_flags: Renalware::FeatureFlags::LAB,
          hospital_centre: visible_hospital
        )
        visible_patient = create(:patient, :minimal, by: user, hospital_centre: visible_hospital)
        hidden_patient = create(:patient, :minimal, by: user, hospital_centre: hidden_hospital)
        widget = create_global_patient_lab_widget(
          visible_patient_id: visible_patient.id,
          hidden_patient_id: hidden_patient.id
        )
        allow(Renalware.config).to receive_messages(
          restrict_patient_visibility_by_user_site?: true,
          restrict_patient_visibility_by_research_study?: false
        )

        login_as_with_user(user)

        get lab_path

        expect(response.body).to include("Global Patient Lab Widget")
        expect(response.body).to include("Visible patient row")
        expect(response.body).not_to include("Hidden patient row")
        expect(widget.calls.last.user).to eq(user)
      end
    end

    context "when the user does not have the lab feature flag" do
      it "redirects to the dashboard" do
        @current_user.update!(feature_flags: 0)

        get lab_path

        expect(response).to redirect_to(dashboard_path)
      end

      it "does not render async widgets" do
        @current_user.update!(feature_flags: 0)
        widget = create_global_lab_widget(async: true)

        get system_sql_view_widget_path(
          widget,
          schema_name: "site",
          slot: "lab:global:top"
        )

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "GET /patients/:patient_id/lab" do
    let(:patient) { create(:patient, :minimal, by: @current_user) }

    before do
      allow(Renalware::Heidi::Client).to receive(:configured?).and_return(false)
    end

    context "when the user has the lab feature flag" do
      it "responds with the patient lab page" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)

        get patient_lab_path(patient)

        expect(response).to be_successful
      end

      it "renders widgets configured for patient lab slots" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        widget = create_patient_lab_widget(patient_id: patient.id)
        create_patient_lab_widget(
          patient_id: patient.id,
          schema_name: "renalware",
          title: "Ignored Patient Widget"
        )

        expect { get patient_lab_path(patient) }
          .to change(Renalware::System::ViewCall, :count).by(1)

        expect(response.body).to include("Patient Lab Widget")
        expect(response.body).to include("Current patient row")
        expect(response.body).not_to include("Other patient row")
        expect(response.body).not_to include("Ignored Patient Widget")
        expect(widget.calls.last.user).to eq(@current_user)
      end

      it "can defer patient widget rendering to a turbo frame" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        widget = create_patient_lab_widget(patient_id: patient.id, async: true)

        expect { get patient_lab_path(patient) }
          .not_to change(Renalware::System::ViewCall, :count)

        expect(response.body).to include("Patient Lab Widget")
        expect(response.body).to include(%(id="sql-view-widget-#{widget.id}"))
        expect(response.body).not_to include("Current patient row")

        expect {
          get system_sql_view_widget_path(
            widget,
            patient_id: patient.to_param,
            schema_name: "site",
            slot: "lab:patient:middle"
          )
        }.to change(Renalware::System::ViewCall, :count).by(1)

        expect(response.body).to include(%(id="sql-view-widget-#{widget.id}"))
        expect(response.body).to include("Current patient row")
        expect(response.body).not_to include("Other patient row")
        expect(widget.calls.last.user).to eq(@current_user)
      end

      it "does not render async patient widgets without a patient context" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        widget = create_patient_lab_widget(patient_id: patient.id, async: true)

        get system_sql_view_widget_path(
          widget,
          schema_name: "site",
          slot: "lab:patient:middle"
        )

        expect(response).to have_http_status(:not_found)
      end

      it "treats any patient slot segment as requiring patient context" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        widget = create_patient_lab_widget(
          patient_id: patient.id,
          async: true,
          slots: ["dashboard:patient:middle"]
        )

        get system_sql_view_widget_path(
          widget,
          schema_name: "site",
          slot: "dashboard:patient:middle"
        )

        expect(response).to have_http_status(:not_found)
      end

      it "does not render unscoped patient widgets" do
        ENV.delete("RENALWARE_STAGE")
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        widget = create_patient_lab_widget(patient_id: patient.id)
        create_patient_lab_widget(
          patient_id: patient.id,
          title: "Unsafe Patient Lab Widget",
          patient_id_column: nil
        )

        expect { get patient_lab_path(patient) }
          .to change(Renalware::System::ViewCall, :count).by(1)

        expect(response.body).to include("Patient Lab Widget")
        expect(response.body).to include("Current patient row")
        expect(response.body).to include("Unsafe Patient Lab Widget")
        expect(response.body).to include("This Lab item could not be loaded.")
        expect(response.body).not_to include("PatientScopeRequiredError")
        expect(widget.calls.last.user).to eq(@current_user)
      end

      it "shows debugging details for unscoped patient widgets in uat" do
        ENV["RENALWARE_STAGE"] = "uat"
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        create_patient_lab_widget(
          patient_id: patient.id,
          title: "Unsafe Patient Lab Widget",
          patient_id_column: nil
        )

        get patient_lab_path(patient)

        expect(response.body).to include("Unsafe Patient Lab Widget")
        expect(response.body).to include(
          "Patient lab widgets must define widget_options.patient_id_column"
        )
      end

      it "renders Heidi link status when Heidi is configured" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        client = instance_double(Renalware::Heidi::Client)
        allow(Renalware::Heidi::Client).to receive_messages(configured?: true, new: client)
        allow(client).to receive(:linked_account_access).with(@current_user).and_return(
          Renalware::Heidi::Client::Result.new(
            success: true,
            status: 200,
            body: {
              "is_linked" => true,
              "account" => {
                "ehr_email" => @current_user.email,
                "ehr_user_id" => @current_user.uuid
              }
            }
          )
        )

        get patient_lab_path(patient)

        expect(response.body).to include("Heidi WIP")
        expect(response.body).to include("linked")
        expect(response.body).to include(@current_user.email)
        expect(response.body).to include(patient_heidi_session_path(patient))
      end

      it "renders synced Heidi note content for recent patient Heidi sessions" do
        @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
        client = instance_double(Renalware::Heidi::Client)
        allow(Renalware::Heidi::Client).to receive_messages(configured?: true, new: client)
        allow(client).to receive(:linked_account_access).with(@current_user).and_return(
          Renalware::Heidi::Client::Result.new(
            success: true,
            status: 200,
            body: { "is_linked" => true }
          )
        )
        create(
          :heidi_session,
          patient:,
          user: @current_user,
          status: :synced,
          consult_note_status: "COMPLETED",
          consult_note: "Synced renal clinic note\nPlan: Continue monitoring"
        )

        get patient_lab_path(patient)

        expect(response.body).to include("Recent Heidi sessions")
        expect(response.body).to include("Synced note")
        expect(response.body).to include("Synced renal clinic note")
        expect(response.body).to include("Plan: Continue monitoring")
      end
    end

    context "when the user does not have the lab feature flag" do
      it "redirects to the dashboard" do
        @current_user.update!(feature_flags: 0)

        get patient_lab_path(patient)

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "GET /system/sql_view_widgets/:id" do
    it "renders async widgets for non-Lab slots without the Lab feature flag" do
      @current_user.update!(feature_flags: 0)
      patient = create(:patient, :minimal, by: @current_user)
      widget = create_generic_patient_widget(patient_id: patient.id)

      get system_sql_view_widget_path(
        widget,
        patient_id: patient.to_param,
        schema_name: "site",
        slot: "hd_mdm:middle"
      )

      expect(response).to be_successful
      expect(response.body).to include(%(id="sql-view-widget-#{widget.id}"))
      expect(response.body).to include("Current patient row")
      expect(response.body).not_to include("Other patient row")
    end
  end

  describe "GET /patients/:patient_id/heidi_linked_account" do
    let(:patient) { create(:patient, :minimal, by: @current_user) }

    before do
      @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
    end

    it "returns the current user's Heidi linked-account status as JSON" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(client).to receive(:linked_account_access).with(@current_user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: true,
          status: 200,
          body: { "is_linked" => true }
        )
      )

      get patient_heidi_linked_account_path(patient), headers: { "Accept" => "application/json" }

      expect(response).to be_successful
      expect(response.parsed_body).to eq("is_linked" => true)
    end

    it "returns a bad gateway response when Heidi status cannot be checked" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(client).to receive(:linked_account_access).with(@current_user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: false,
          status: 502,
          body: {},
          error: "Heidi unavailable"
        )
      )

      get patient_heidi_linked_account_path(patient), headers: { "Accept" => "application/json" }

      expect(response).to have_http_status(:bad_gateway)
      expect(response.parsed_body).to eq(
        "is_linked" => false,
        "error" => "Heidi unavailable"
      )
    end
  end

  describe "POST /patients/:patient_id/heidi_linked_account" do
    let(:patient) { create(:patient, :minimal, by: @current_user) }

    before do
      @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
    end

    it "redirects to Heidi's browser account-linking flow" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(client).to receive(:link_account_url_for).with(@current_user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: true,
          status: nil,
          body: { "url" => "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt-token" }
        )
      )

      post patient_heidi_linked_account_path(patient)

      expect(response).to redirect_to(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt-token"
      )
    end

    it "redirects with an alert when Heidi cannot build the link URL" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(client).to receive(:link_account_url_for).with(@current_user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: false,
          status: 400,
          body: {},
          error: "bad payload"
        )
      )

      post patient_heidi_linked_account_path(patient)

      expect(response).to redirect_to(patient_lab_path(patient))
      expect(flash[:alert]).to eq("Heidi account linking failed: bad payload")
    end
  end

  describe "POST /patients/:patient_id/heidi_session" do
    let(:patient) { create(:patient, :minimal, by: @current_user) }

    before do
      @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
    end

    it "creates a Heidi session and redirects to the Heidi session URL" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(Renalware::Heidi::Client).to receive(:launch_url_for)
        .with("1234567890")
        .and_return("https://registrar.scribe.heidihealth.com/scribe/session/1234567890")
      allow(client).to receive(:create_session_for_patient).with(@current_user, patient).and_return(
        Renalware::Heidi::Client::Result.new(
          success: true,
          status: 200,
          body: { "session_id" => "1234567890", "patient_profile_id" => "profile-1" }
        )
      )

      expect {
        post patient_heidi_session_path(patient)
      }.to change(Renalware::Heidi::Session, :count).by(1)

      expect(response).to redirect_to(
        "https://registrar.scribe.heidihealth.com/scribe/session/1234567890"
      )
      expect(Renalware::Heidi::Session.last).to have_attributes(
        patient:,
        user: @current_user,
        heidi_session_id: "1234567890",
        heidi_patient_profile_id: "profile-1",
        status: "launched"
      )
    end

    it "redirects back to the lab page when Heidi does not create a session" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(client).to receive(:create_session_for_patient).with(@current_user, patient).and_return(
        Renalware::Heidi::Client::Result.new(
          success: false,
          status: 403,
          body: {},
          error: "not linked"
        )
      )

      post patient_heidi_session_path(patient)

      expect(response).to redirect_to(patient_lab_path(patient))
      expect(flash[:alert]).to eq("Heidi session could not be created: not linked")
    end
  end

  describe "POST /patients/:patient_id/heidi_session_syncs/:heidi_session_id" do
    let(:patient) { create(:patient, :minimal, by: @current_user) }
    let(:heidi_session) { create(:heidi_session, patient:, user: @current_user) }

    before do
      @current_user.update!(feature_flags: Renalware::FeatureFlags::LAB)
    end

    it "syncs the selected Heidi session and redirects back to the lab page" do
      sync = instance_double(Renalware::Heidi::SyncSession, call: heidi_session)
      allow(Renalware::Heidi::SyncSession).to receive(:new)
        .with(session: heidi_session)
        .and_return(sync)

      post patient_heidi_session_sync_path(patient, heidi_session)

      expect(sync).to have_received(:call)
      expect(response).to redirect_to(patient_lab_path(patient))
      expect(flash[:notice]).to eq("Heidi session sync requested.")
    end
  end

  def create_global_lab_widget(schema_name: "site", title: "Global Lab Widget", async: false)
    connection.execute("CREATE SCHEMA IF NOT EXISTS #{schema_name}")
    connection.execute(<<~SQL.squish)
      CREATE TABLE IF NOT EXISTS #{schema_name}.lab_global_widget_rows (
        label text
      )
    SQL
    connection.execute(<<~SQL.squish)
      CREATE OR REPLACE VIEW #{schema_name}.lab_global_widget_view AS
      SELECT label
      FROM #{schema_name}.lab_global_widget_rows
    SQL
    connection.execute("DELETE FROM #{schema_name}.lab_global_widget_rows")
    connection.execute(<<~SQL.squish)
      INSERT INTO #{schema_name}.lab_global_widget_rows (label)
      VALUES ('Global widget row')
    SQL

    create(
      :view_metadata,
      category: :widget,
      schema_name: schema_name,
      view_name: "lab_global_widget_view",
      title: title,
      columns: [
        Renalware::System::ColumnDefinition.new(code: "label", name: "Label")
      ],
      widget_options: {
        slots: ["lab:global:top"],
        max_rows: 5,
        async: async
      }
    )
  end

  def create_global_patient_lab_widget(visible_patient_id:, hidden_patient_id:)
    connection.execute("CREATE SCHEMA IF NOT EXISTS site")
    connection.execute(<<~SQL.squish)
      CREATE TABLE IF NOT EXISTS site.lab_global_patient_widget_rows (
        patient_id bigint,
        label text
      )
    SQL
    connection.execute(<<~SQL.squish)
      CREATE OR REPLACE VIEW site.lab_global_patient_widget_view AS
      SELECT patient_id, label
      FROM site.lab_global_patient_widget_rows
    SQL
    connection.execute("DELETE FROM site.lab_global_patient_widget_rows")
    connection.execute(<<~SQL.squish)
      INSERT INTO site.lab_global_patient_widget_rows (patient_id, label)
      VALUES
        (#{visible_patient_id}, 'Visible patient row'),
        (#{hidden_patient_id}, 'Hidden patient row')
    SQL

    create(
      :view_metadata,
      category: :widget,
      schema_name: "site",
      view_name: "lab_global_patient_widget_view",
      title: "Global Patient Lab Widget",
      columns: [
        Renalware::System::ColumnDefinition.new(code: "patient_id", hidden: true),
        Renalware::System::ColumnDefinition.new(code: "label", name: "Label")
      ],
      widget_options: {
        slots: ["lab:global:middle"],
        max_rows: 5,
        patient_id_column: "patient_id"
      }
    )
  end

  def create_patient_lab_widget(
    patient_id:,
    schema_name: "site",
    title: "Patient Lab Widget",
    patient_id_column: "patient_id",
    async: false,
    slots: ["lab:patient:middle"]
  )
    connection.execute("CREATE SCHEMA IF NOT EXISTS #{schema_name}")
    connection.execute(<<~SQL.squish)
      CREATE TABLE IF NOT EXISTS #{schema_name}.lab_patient_widget_rows (
        patient_id bigint,
        label text
      )
    SQL
    connection.execute(<<~SQL.squish)
      CREATE OR REPLACE VIEW #{schema_name}.lab_patient_widget_view AS
      SELECT patient_id, label
      FROM #{schema_name}.lab_patient_widget_rows
    SQL
    connection.execute("DELETE FROM #{schema_name}.lab_patient_widget_rows")
    connection.execute(<<~SQL.squish)
      INSERT INTO #{schema_name}.lab_patient_widget_rows (patient_id, label)
      VALUES
        (#{patient_id}, 'Current patient row'),
        (#{patient_id + 1}, 'Other patient row')
    SQL

    create(
      :view_metadata,
      category: :widget,
      schema_name: schema_name,
      view_name: "lab_patient_widget_view",
      title: title,
      columns: [
        Renalware::System::ColumnDefinition.new(code: "patient_id", hidden: true),
        Renalware::System::ColumnDefinition.new(code: "label", name: "Label")
      ],
      widget_options: {
        slots: slots,
        max_rows: 5,
        patient_id_column: patient_id_column,
        async: async
      }.compact
    )
  end

  def create_generic_patient_widget(patient_id:)
    connection.execute("CREATE SCHEMA IF NOT EXISTS site")
    connection.execute(<<~SQL.squish)
      CREATE TABLE IF NOT EXISTS site.generic_patient_widget_rows (
        patient_id bigint,
        label text
      )
    SQL
    connection.execute(<<~SQL.squish)
      CREATE OR REPLACE VIEW site.generic_patient_widget_view AS
      SELECT patient_id, label
      FROM site.generic_patient_widget_rows
    SQL
    connection.execute("DELETE FROM site.generic_patient_widget_rows")
    connection.execute(<<~SQL.squish)
      INSERT INTO site.generic_patient_widget_rows (patient_id, label)
      VALUES
        (#{patient_id}, 'Current patient row'),
        (#{patient_id + 1}, 'Other patient row')
    SQL

    create(
      :view_metadata,
      category: :widget,
      schema_name: "site",
      view_name: "generic_patient_widget_view",
      title: "Generic Patient Widget",
      columns: [
        Renalware::System::ColumnDefinition.new(code: "patient_id", hidden: true),
        Renalware::System::ColumnDefinition.new(code: "label", name: "Label")
      ],
      widget_options: {
        slots: ["hd_mdm:middle"],
        max_rows: 5,
        patient_id_column: "patient_id",
        async: true
      }
    )
  end
end
