Erp::Ability.class_eval do
  def accounting_ability(user)
    
    can :read, Erp::Orders::Order do |order|
      order.is_confirmed?
    end
    
    can :receive_sales_order, Erp::Orders::Order do |order|
      order.sales?
    end
    
    can :pay_sales_order, Erp::Orders::Order do |order|
      order.sales?
    end
    
    can :receive_purchase_order, Erp::Orders::Order do |order|
      order.purchase?
    end
    
    can :pay_purchase_order, Erp::Orders::Order do |order|
      order.purchase?
    end
  end
end