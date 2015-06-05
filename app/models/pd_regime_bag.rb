class PdRegimeBag < ActiveRecord::Base

  belongs_to :bag_type
  belongs_to :pd_regime

end
