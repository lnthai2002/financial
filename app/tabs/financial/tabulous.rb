module Financial
  Tabulous.setup do
    tabs do
      daily_tab do
        text          { 'Daily tracking' }
        link_path     { new_expense_path }
        visible_when  { true }
        enabled_when  { true }
        active_when   { a_subtab_is_active }
        end
      end
  
      report_subtab do
        text          { 'Report' }
        link_path     { reports_path }
        visible_when  { true }
        enabled_when  { true }
        active_when do
          in_action('any').of_controller('reports')
        end
      end
  
      expense_subtab do
        text          { 'Expense' }
        link_path     { new_expense_path }
        visible_when  { true }
        enabled_when  { true }
        active_when   { in_action('any').of_controller('expenses') }
      end
  
      income_subtab do
        text          { 'Income' }
        link_path     { new_income_path }
        visible_when  { true }
        enabled_when  { true }
        active_when   { in_action('any').of_controller('incomes') }
      end
  
      recurring_subtab do
        text          { 'Recurring' }
        link_path     { recurring_payments_path }
        visible_when  { true }
        enabled_when  { true }
        active_when   { in_action('any').of_controller('recurring_payments') }
      end
  
      category_subtab do
        text          { 'Categories' }
        link_path     { categories_path }
        visible_when  { true }
        enabled_when  { true }
        active_when   { in_action('any').of_controller('categories') }
      end
  
      payment_method_subtab do
        text          { 'Payment methods' }
        link_path     { payment_types_path }
        visible_when  { true }
        enabled_when  { true }
        active_when   { in_action('any').of_controller('payment_types') }
      end
  
      planning_tab do
        text          { 'Planning' }
        link_path     { plans_path }
        visible_when  { true }
        enabled_when  { true }
        active_when   { a_subtab_is_active }
      end
    end
  end
end