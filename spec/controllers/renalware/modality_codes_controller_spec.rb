require 'rails_helper'

module Renalware
  describe ModalityCodesController, :type => :controller do

    describe 'DELETE destroy' do
      it 'soft deletes a modality code' do
        @modality_code = create(:modality_code)

        expect { delete :destroy, id: @modality_code }.to change(ModalityCode, :count).by(-1)

        expect(@modality_code.reload.deleted_at).not_to be_nil
      end
    end

  end
end