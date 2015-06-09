require 'rails_helper'

RSpec.describe PdRegimesController, :type => :controller do

  before do
    @patient = create(:patient)
    @pd_regime = create(:pd_regime)
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new, patient_id: @patient.id
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it 'creates a new PD Regime' do
        expect { post :create, patient_id: @patient.id, pd_regime: { start_date: '01/02/2015' } }.to change(PdRegime, :count).by(1)
        expect(response).to redirect_to(pd_info_patient_path(@patient))
      end
    end

    context "with invalid attributes" do
      it 'creates a new PD Regime' do
        expect { post :create, patient_id: @patient.id, pd_regime: { start_date: nil } }.to change(PdRegime, :count).by(0)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context "with valid attributes" do
      it 'updates a PD Regime' do
        put :update, id: @pd_regime.id, patient_id: @patient.id, pd_regime: { start_date: '15/02/2015' }
        expect(response).to redirect_to(pd_info_patient_path(@patient))
      end
    end

    context "with invalid attributes" do
      it 'update a PD Regime' do
        put :update, id: @pd_regime.id, patient_id: @patient.id, pd_regime: { start_date: nil }
        expect(response).to render_template(:edit)
      end
    end
  end

end
