module Erp
  module Accounting
    module ApplicationHelper
      
      # Order dropdown actions
      def accounting_order_dropdown_actions(order)
        actions = []
        actions << {
          text: '<i class="fa fa-file-text-o"></i> '+t('.view'),
          url: erp_orders.backend_order_path(order)
        } if can? :read, order
        actions << { divider: true }
        actions << {
          text: '<i class="icon-action-redo"></i> '+(order.purchase? ? t('.receive_ncc') : t('.receive_kh')),
          url: erp_payments.new_backend_payment_record_path(
                  order_id: order.id,
                  pay_receive: Erp::Payments::PaymentRecord::TYPE_RECEIVE,
                  payment_type: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::TYPE_FOR_ORDER))
        }
        actions << {
          text: '<i class="icon-action-undo"></i> '+(order.purchase? ? t('.pay_ncc') : t('.pay_kh')),
          url: erp_payments.new_backend_payment_record_path(
                  order_id: order.id,
                  pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
                  payment_type: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::TYPE_FOR_ORDER))
        }
        
        erp_datalist_row_actions(
          actions
        )
      end
      
    end
  end
end
