require 'rails_helper'

describe Doctor, type: :model do

  it_behaves_like 'Personable'

  it { should belong_to :address }

  it { should validate_presence_of :practitioner_type }
end
