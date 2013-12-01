module Financial
  class Category < ActiveRecord::Base
    attr_accessible :description, :type
    validates :description, :type, :presence=>true
  end
end
