Erp::Ability.class_eval do
  def accounting_ability(user)
    
    can :read, Erp::Orders::Order do |order|
      order.is_confirmed?
    end
    
    can :receive_sales_order, Erp::Orders::Order do |order|
      if order.payment_for == Erp::Orders::Order::PAYMENT_FOR_ORDER
        order.sales? and order.remain_amount > 0
      end
    end
    
    can :pay_sales_order, Erp::Orders::Order do |order|
      if order.payment_for == Erp::Orders::Order::PAYMENT_FOR_ORDER
        order.sales? and order.remain_amount < 0
      end
    end
    
    can :receive_purchase_order, Erp::Orders::Order do |order|
      if order.payment_for == Erp::Orders::Order::PAYMENT_FOR_ORDER
        order.purchase? and order.remain_amount < 0
      end
    end
    
    can :pay_purchase_order, Erp::Orders::Order do |order|
      if order.payment_for == Erp::Orders::Order::PAYMENT_FOR_ORDER
        order.purchase? and order.remain_amount > 0
      end
    end
  end
end