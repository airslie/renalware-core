require "rails_helper"

module Renalware
  RSpec.describe PD::RegimesController, type: :controller do

    before do
      @patient = create(:patient)
      @bag_type = create(:bag_type)
      @capd_regime = create(:capd_regime,
                      regime_bags_attributes: [
                        bag_type: @bag_type,
                        additional_manual_exchange: true,
                        volume: 600,
                        sunday: true,
                        monday: true,
                        tuesday: true,
                        wednesday: true,
                        thursday: true,
                        friday: true,
                        saturday: true
                      ]
                    )
    end

    describe "GET #new" do
      it "renders the new template" do
        get :new, patient_id: @patient
        expect(response).to render_template("new")
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "creates a new CAPD Regime" do
          system = create(:capd_system)
          expect do
            post :create,
                 patient_id: @patient,
                 pd_regime: {
                   type: "Renalware::PD::CAPDRegime",
                   start_date: "01/02/2015",
                   treatment: "CAPD 3 exchanges per day",
                   system_id: system.id,
                   delivery_interval: 4,
                   regime_bags_attributes: [
                     bag_type_id: @bag_type.id,
                     additional_manual_exchange: true,
                     volume: 600,
                     sunday: true,
                     monday: true,
                     tuesday: true,
                     wednesday: true,
                     thursday: true,
                     friday: true,
                     saturday: true
                   ]
                 }
          end.to change(PD::Regime, :count).by(1)

          expect(response).to redirect_to(patient_pd_dashboard_path(@patient))

          regime = @patient.pd_regimes.first
          expect(regime.system).to eq(system)
          expect(regime.delivery_interval).to eq(4)
          expect(regime.regime_bags.count).to eq(1)

          bag = regime.regime_bags.first
          expect(bag.additional_manual_exchange).to eq(true)
        end
      end

      context "with invalid attributes" do
        it "does not create a new CAPD Regime" do
          system = create(:apd_system)
          expect {
            post :create,
            patient_id: @patient,
            system_id: system.id,
            delivery_interval: 4,
            pd_regime: { type: "Renalware::PD::CAPDRegime",
              start_date: nil,
              treatment: nil
            }
          }.to change(PD::Regime, :count).by(0)

          expect(response).to render_template(:new)
        end
      end

      context "add bag" do
        it "adds a bag to the unsaved CAPD Regime" do
          expect(PD::RegimeBag.count).to eq(1)
          expect {
            post :create,
            patient_id: @patient,
            actions: { add_bag: "Add Bag" },
            pd_regime: { type: "Renalware::PD::CAPDRegime",
              start_date: Time.zone.today,
              treatment: "CAPD 3 exchanges per day" }
          }.to change(PD::Regime, :count).by(0)
          expect(PD::RegimeBag.count).to eq(1)
        end
      end

      context "remove bag" do
        it "removes a bag from the unsaved CAPD Regime" do
          post :create,
          patient_id: @patient,
          actions: { remove: { "0" => "Remove" } },
          pd_regime: { type: "Renalware::PD::CAPDRegime",
            start_date: Time.zone.today,
            treatment: "CAPD 4 exchanges per day",
            regime_bags_attributes: [
              {
                bag_type_id: "100", volume: "2", per_week: "1", monday: true
              }
            ]
          }

          expect(PD::RegimeBag.count).to eq(1)
        end
      end
    end

    describe "GET show" do
      it "responds with success" do
        get :show, id: @capd_regime.id, patient_id: @patient
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET edit" do
      it "responds with success" do
        get :edit,
        id: @capd_regime.id,
        patient_id: @patient
        expect(response).to have_http_status(:success)
      end
    end

    describe "PUT #update" do
      context "with valid attributes" do
        it "updates a CAPD Regime" do
          put :update,
          id: @capd_regime.id,
          patient_id: @patient,
          pd_regime: { type: "Renalware::PD:CAPDRegime",
            start_date: "15/02/2015",
            treatment: "CAPD 5 exchanges per day"
          }

          expect(response).to redirect_to(patient_pd_dashboard_path(@patient))
        end
      end

      context "with invalid attributes" do
        it "update a CAPD Regime" do
          put :update,
          id: @capd_regime.id,
          patient_id: @patient,
          pd_regime: { type: "Renalware::PD::CAPDRegime",
            start_date: nil,
            treatment: nil
          }

          expect(response).to render_template(:edit)
        end
      end

      context "add bag" do
        it "adds a bag to the saved CAPD Regime" do
          expect {
            put :update,
            id: @capd_regime.id,
            patient_id: @patient,
            actions: { add_bag: "Add Bag" },
            pd_regime: { type: "Renalware::PD::CAPDRegime",
              start_date: Time.zone.today,
              treatment: "CAPD 3 exchanges per day"
            }
          }.to change(PD::Regime, :count).by(0)

          expect(assigns(:pd_regime).regime_bags.size).to eq(2)
        end
      end

      context "remove bag" do
        before do
          # ensure regime has at least one bag
          create(:pd_regime_bag, regime: @capd_regime)
        end

        it "removes a bag from the unsaved CAPD Regime" do
          put :update,
            id: @capd_regime.id,
            patient_id: @patient,
            actions: { remove: { "0" => "Remove" } },
            pd_regime: { type: "Renalware::PD::CAPDRegime",
              start_date: Time.zone.today,
              treatment: "CAPD 3 exchanges per day"
            }

          expect(assigns(:pd_regime).regime_bags.size).to eq(1)
        end
      end
    end
  end
end
