module Financial
  class Category < ActiveRecord::Base
    attr_accessible :description, :type
    validates :description, :presence=>true
  end
end
