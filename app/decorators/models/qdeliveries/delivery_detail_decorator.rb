Erp::Qdeliveries::DeliveryDetail.class_eval do
  after_save :update_cache_payment_status
  def update_cache_payment_status
    if delivery.present?
      delivery.update_cache_payment_status
    end
  end
end