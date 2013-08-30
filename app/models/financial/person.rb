module Financial
  class Person < ActiveRecord::Base
    self.table_name = 'users'

    attr_accessible :email

    has_one :finance, :dependent => :destroy
    has_many :plans, :dependent => :destroy
    has_many :payments, :dependent => :destroy
    has_many :incomes, :dependent => :destroy
    has_many :expenses, :dependent => :destroy
    has_many :recurring_payments, :dependent => :destroy
  end
end
