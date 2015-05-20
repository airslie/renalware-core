class User < ActiveRecord::Base
  include Deviseable
  include Permissible

  validates_uniqueness_of :username
  validates_presence_of :first_name
  validates_presence_of :last_name
end
