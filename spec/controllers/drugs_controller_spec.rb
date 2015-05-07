require 'rails_helper'

RSpec.describe DrugsController, :type => :controller do
  describe "DELETE to destroy" do
    it "returns http success" do
      drug = FactoryGirl.create(:drug)
      delete :destroy, id: drug.id
      drug.reload
      expect(drug.deleted_at).not_to be nil
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET #new" do

    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end

  end

  describe 'GET #index' do

    let(:page) { double(:page) }
    let(:result) { double(:result, page: page) }
    let(:search) { double(:search, result: result) }

    it 'responds successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end

    context 'with no params' do
      it 'returns all drugs' do
        expect(page).to receive(:per)
        expect(Drug).to receive(:ransack)
          .with(active: true)
            .and_return(search)
        expect(search).to receive(:sorts=).with('name')

        get :index
      end
    end

    context 'with search params' do
      it 'ransacks for drugs' do
        expect(Drug).to receive(:ransack).and_return(search)
        expect(page).to receive(:per)
        expect(search).to receive(:sorts=).with('name')

        get :index, q: { name_cont: 'cillin' }
      end
    end
    context 'with pagination params' do
      it 'assigns paging variables' do
        get :index,  q: { name_cont: 'cillin', page: '2', per_page: '50' }

        expect(assigns(:page)).to eq('2')
        expect(assigns(:per_page)).to eq('50')
      end
    end
  end
end
