require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe 'errors_css_class' do
    let(:model_with_errors) { double(:model, errors: { foo: "can't be blank" }) }
    let(:model_without_errors) { double(:model, errors: {}) }

    it 'returns fields_with_errors for the model field with errors' do
      expect(errors_css_class(model_with_errors, :foo)).to eq(' field_with_errors')
    end
    it 'returns nil for the model field with no errors' do
      expect(errors_css_class(model_without_errors, :foo)).to be_nil
    end
  end
end
