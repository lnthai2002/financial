module Financial
  class Category < ActiveRecord::Base
    validates :description, :type, :presence=>true
  end
end
