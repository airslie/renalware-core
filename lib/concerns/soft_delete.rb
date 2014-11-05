module Concerns::SoftDelete

  def self.included(klass)
    klass.class_eval do
      default_scope{ where(deleted_at: nil) }
    end
  end
  
  def soft_delete
    update_attributes(:deleted_at => Time.now)
  end

  def soft_delete!
    update_attributes!(:deleted_at => Time.now)
  end

end