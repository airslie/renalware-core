require 'rails_helper'

describe Letter, type: :model do
  it { should belong_to :author }
  it { should belong_to :reviewer }
  it { should belong_to :doctor }
  it { should belong_to :patient }
  it { should belong_to :letter_description }
  it { should validate_presence_of :letter_description }
  it { should validate_presence_of :recipient }
  it { should validate_presence_of :recipient_address }
  it { should validate_presence_of :state }
  it { should validate_presence_of :letter_type }
end
