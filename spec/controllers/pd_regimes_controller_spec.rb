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

    context 'add bag' do
      it 'adds a bag to the unsaved PdRegime' do
        expect {
          post :create, patient_id: @patient.id, actions: {add_bag: 'Add Bag'}, pd_regime: {start_date: Date.today}
        }.to change(PdRegime, :count).by(0)

        expect(assigns(:pd_regime).pd_regime_bags.size).to eq(1)
      end
    end

    context 'remove bag' do
      it 'removes a bag from the unsaved PdRegime' do
        post :create, patient_id: @patient.id, actions: {remove: {'0' => 'Remove'}}, pd_regime: {
          start_date: Date.today, pd_regime_bags_attributes: [{bag_type_id:'100',volume:'2',per_week:'1',monday:true}]}
        expect(assigns(:pd_regime).pd_regime_bags.size).to eq(0)
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

    context 'add bag' do
      it 'adds a bag to the saved PdRegime' do
        expect {
          put :update, id: @pd_regime.id, patient_id: @patient.id,
            actions: {add_bag: 'Add Bag'}, pd_regime: {start_date: Date.today}
        }.to change(PdRegime, :count).by(0)

        expect(assigns(:pd_regime).pd_regime_bags.size).to eq(1)
      end
    end

    context 'remove bag' do
      it 'removes a bag from the unsaved PdRegime' do
        @pd_regime.pd_regime_bags << create(:pd_regime_bag)
        put :update, id: @pd_regime.id, patient_id: @patient.id,
          actions: {remove: {'0' => 'Remove'}}, pd_regime: {start_date: Date.today}
        expect(assigns(:pd_regime).pd_regime_bags.size).to eq(0)
      end
    end
  end
end
