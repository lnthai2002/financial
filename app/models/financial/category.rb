module Financial
  class Category < ActiveRecord::Base
    has_many :payments
    has_many :recurring_payments
    validates :description, :type, :presence=>true
    after_destroy :remove_helper_categories
    after_save :update_helper_categories

    private
    def remove_helper_categories
      ApplicationHelper::CATEGORIES.delete(id)
    end
    
    def update_helper_categories
      ApplicationHelper::CATEGORIES[id] = description
    end
  end
end
