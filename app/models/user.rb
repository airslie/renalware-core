class User < ActiveRecord::Base
  include Deviseable
  include Permissible
end
