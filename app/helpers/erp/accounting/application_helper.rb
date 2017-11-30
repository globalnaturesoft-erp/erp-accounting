module Erp
  module Accounting
    module ApplicationHelper

      # Order dropdown actions
      def accounting_order_dropdown_actions(order)
        actions = []
        actions << {
          text: '<i class="fa fa-print"></i> Xem & In',
          url: erp_orders.backend_order_path(order)
        } if can? :read, order
        actions << { divider: true }
        actions << {
          text: '<i class="icon-action-redo"></i> ' + t('.receive_kh'),
          url: erp_payments.new_backend_payment_record_path(
                  order_id: order.id,
                  pay_receive: Erp::Payments::PaymentRecord::TYPE_RECEIVE,
                  payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_SALES_ORDER))
        } if can? :receive_sales_order, order
        actions << {
          text: '<i class="icon-action-undo"></i> ' + t('.pay_kh'),
          url: erp_payments.new_backend_payment_record_path(
                  order_id: order.id,
                  pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
                  payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_SALES_ORDER))
        } if can? :pay_sales_order, order
        actions << {
          text: '<i class="icon-action-redo"></i> ' + t('.receive_ncc'),
          url: erp_payments.new_backend_payment_record_path(
                  order_id: order.id,
                  pay_receive: Erp::Payments::PaymentRecord::TYPE_RECEIVE,
                  payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PURCHASE_ORDER))
        } if can? :receive_purchase_order, order
        actions << {
          text: '<i class="icon-action-undo"></i> ' + t('.pay_ncc'),
          url: erp_payments.new_backend_payment_record_path(
                  order_id: order.id,
                  pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
                  payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PURCHASE_ORDER))
        } if can? :pay_purchase_order, order

        erp_datalist_row_actions(
          actions
        )
      end

      def accounting_delivery_dropdown_actions(delivery)
        actions = []
        actions << {
          text: '<i class="icon-action-undo"></i> ' + t('.pay_product_return'),
          url: erp_payments.new_backend_payment_record_path(
                  delivery_id: delivery.id,
                  pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
                  payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PRODUCT_RETURN))
        }

        erp_datalist_row_actions(
          actions
        )
      end

    end
  end
end
