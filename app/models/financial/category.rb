module Financial
  class Category < ActiveRecord::Base
    attr_accessible :description, :type
  end
end
