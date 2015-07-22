class Letter < ActiveRecord::Base
  include LetterType

  belongs_to :author, class_name: 'User'
  belongs_to :reviewer, class_name: 'User'
  belongs_to :doctor
  belongs_to :patient
  belongs_to :letter_description
  belongs_to :recipient_address, class_name: 'Address'

  validates_with LetterSignatureValidator
  validates_presence_of :patient
  validates_presence_of :recipient
  validates_presence_of :recipient_address
  validates_presence_of :letter_description_id
  validates_presence_of :state, in: [:draft, :review] # TODO: Final states TBC.
  validates_presence_of :type, in: LetterType.all

  def title
    self.class.name.underscore.titleize
  end
end
