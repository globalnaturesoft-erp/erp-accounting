Erp::Qdeliveries::Delivery.class_eval do

  after_save :update_cache_payment_status

  # class const
  PAYMENT_STATUS_PAID = 'paid'
  PAYMENT_STATUS_OWING = 'owing'
  PAYMENT_STATUS_OVERPAID = 'overpaid'

  # Trường hợp phiếu delivery đã hủy và (có/đã) thanh toán thì hiển thị thế nào?
  def self.accounting_sales_deliveries
    self.where(status: Erp::Qdeliveries::Delivery::STATUS_DELIVERED)
        .where(delivery_type: Erp::Qdeliveries::Delivery::TYPE_SALES_IMPORT)
        .where(payment_for: Erp::Qdeliveries::Delivery::PAYMENT_FOR_ORDER)
  end
  
  def self.accounting_purchase_deliveries
    self.where(status: Erp::Qdeliveries::Delivery::STATUS_DELIVERED)
        .where(delivery_type: Erp::Qdeliveries::Delivery::TYPE_PURCHASE_IMPORT)
        .where(payment_for: Erp::Qdeliveries::Delivery::PAYMENT_FOR_ORDER)
  end

  # set payment status
  def payment_status
    status = ''
    if self.status == Erp::Qdeliveries::Delivery::STATUS_DELIVERED
      if remain_amount == 0
        status = Erp::Qdeliveries::Delivery::PAYMENT_STATUS_PAID
      elsif remain_amount > 0
          status = Erp::Qdeliveries::Delivery::PAYMENT_STATUS_OWING
      else
        status = Erp::Qdeliveries::Delivery::PAYMENT_STATUS_OVERPAID
      end
    elsif self.status == Erp::Qdeliveries::Delivery::STATUS_DELETED
      if remain_amount == 0
        status = ''
      else
        status = Erp::Qdeliveries::Delivery::PAYMENT_STATUS_OVERPAID
      end
    end

    return status
  end

  # update cache payment status
  def update_cache_payment_status
    if [Erp::Qdeliveries::Delivery::TYPE_SALES_IMPORT].include?(self.delivery_type)
      self.update_columns(cache_payment_status: payment_status)
    end
  end

  # get waiting qdeliveries not paid
  def self.get_waiting_not_paid_return_sales_deliveries
    self.accounting_sales_deliveries
      .where(cache_payment_status: [self::PAYMENT_STATUS_OWING, self::PAYMENT_STATUS_OVERPAID])
  end

  def self.get_waiting_not_paid_return_sales_deliveries_count
    self.get_waiting_not_paid_return_sales_deliveries.count
  end
  
  def self.get_waiting_not_paid_return_purchase_deliveries
    self.accounting_purchase_deliveries
      .where(cache_payment_status: [self::PAYMENT_STATUS_OWING, self::PAYMENT_STATUS_OVERPAID])
  end

  def self.get_waiting_not_paid_return_purchase_deliveries_count
    self.get_waiting_not_paid_return_purchase_deliveries.count
  end
end
