require "rails_helper"

module Renalware
  RSpec.describe PDRegimesController, type: :controller do

    before do
      @patient = create(:patient)
      @bag_type = create(:bag_type)
      @capd_regime = create(:capd_regime,
                      pd_regime_bags_attributes: [
                        bag_type: @bag_type,
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
          expect { post :create,
            patient_id: @patient,
            pd_regime: {
              type: "Renalware::CAPDRegime",
              start_date: "01/02/2015",
              treatment: "CAPD 3 exchanges per day",
              pd_regime_bags_attributes: [
                bag_type_id: @bag_type.id,
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
          }.to change(PDRegime, :count).by(1)

          expect(response).to redirect_to(patient_pd_summary_path(@patient))
        end
      end

      context "with invalid attributes" do
        it "creates a new CAPD Regime" do
          expect {
            post :create,
            patient_id: @patient,
            pd_regime: { type: "Renalware::CAPDRegime",
              start_date: nil,
              treatment: nil
            }
          }.to change(PDRegime, :count).by(0)

          expect(response).to render_template(:new)
        end
      end

      context "add bag" do
        it "adds a bag to the unsaved CAPD Regime" do
          expect {
            post :create,
            patient_id: @patient,
            actions: { add_bag: "Add Bag" },
            pd_regime: { type: "Renalware::CAPDRegime",
              start_date: Time.zone.today,
              treatment: "CAPD 3 exchanges per day" }
          }.to change(PDRegime, :count).by(0)

          expect(assigns(:pd_regime).pd_regime_bags.size).to eq(1)
        end
      end

      context "remove bag" do
        it "removes a bag from the unsaved CAPD Regime" do
          post :create,
          patient_id: @patient,
          actions: { remove: { "0" => "Remove" } },
          pd_regime: { type: "Renalware::CAPDRegime",
            start_date: Time.zone.today,
            treatment: "CAPD 4 exchanges per day",
            pd_regime_bags_attributes: [
              {
                bag_type_id:"100", volume:"2", per_week:"1", monday:true
              }
            ]
          }

          expect(assigns(:pd_regime).pd_regime_bags.size).to eq(0)
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
          pd_regime: { type: "Renalware::CAPDRegime",
            start_date: "15/02/2015",
            treatment: "CAPD 5 exchanges per day"
          }

          expect(response).to redirect_to(patient_pd_summary_path(@patient))
        end
      end

      context "with invalid attributes" do
        it "update a CAPD Regime" do
          put :update,
          id: @capd_regime.id,
          patient_id: @patient,
          pd_regime: { type: "Renalware::CAPDRegime",
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
            pd_regime: { type: "Renalware::CAPDRegime",
              start_date: Time.zone.today,
              treatment: "CAPD 3 exchanges per day"
            }
          }.to change(PDRegime, :count).by(0)

          expect(assigns(:pd_regime).pd_regime_bags.size).to eq(2)
        end
      end

      context "remove bag" do
        before do
          # ensure regime has at least one bag
          create(:pd_regime_bag, pd_regime: @capd_regime)
        end

        it "removes a bag from the unsaved CAPD Regime" do
          put :update,
            id: @capd_regime.id,
            patient_id: @patient,
            actions: { remove: { "0" => "Remove" } },
            pd_regime: { type: "Renalware::CAPDRegime",
              start_date: Time.zone.today,
              treatment: "CAPD 3 exchanges per day"
            }

          expect(assigns(:pd_regime).pd_regime_bags.size).to eq(1)
        end
      end
    end
  end
end
