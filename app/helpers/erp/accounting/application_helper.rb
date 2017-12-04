module Erp
  module Accounting
    module ApplicationHelper

      # Order dropdown actions
      def accounting_order_dropdown_actions(order)
        actions = []
        actions << {
          text: '<i class="fa fa-print"></i> Xem & In HĐ',
          url: erp_orders.backend_order_path(order)
        } if can? :read, order
        actions << { divider: true }
        actions << {
          text: '<i class="fa fa-angle-double-left"></i> ' + t('.receive_kh'),
          url: erp_payments.new_backend_payment_record_path(
            order_id: order.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_RECEIVE,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_SALES_ORDER))
        } if can? :receive_sales_order, order
        actions << {
          text: '<i class="fa fa-angle-double-right"></i> ' + t('.pay_kh'),
          url: erp_payments.new_backend_payment_record_path(
            order_id: order.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_SALES_ORDER))
        } if can? :pay_sales_order, order
        actions << {
          text: '<i class="fa fa-angle-double-left"></i> ' + t('.receive_ncc'),
          url: erp_payments.new_backend_payment_record_path(
            order_id: order.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_RECEIVE,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PURCHASE_ORDER))
        } if can? :receive_purchase_order, order
        actions << {
          text: '<i class="fa fa-angle-double-right"></i> ' + t('.pay_ncc'),
          url: erp_payments.new_backend_payment_record_path(
            order_id: order.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PURCHASE_ORDER))
        } if can? :pay_purchase_order, order

        erp_datalist_row_actions(
          actions
        )
      end
      
      # Product return - Qdeliveries
      def accounting_delivery_dropdown_actions(delivery)
        actions = []
        actions << {
          text: '<i class="fa fa-angle-double-right"></i> ' + t('.pay_product_return'),
          url: erp_payments.new_backend_payment_record_path(
            delivery_id: delivery.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PRODUCT_RETURN))
        }

        erp_datalist_row_actions(
          actions
        )
      end
      
      # Order dropdown actions
      def accounting_payment_record_dropdown_actions(payment_record)
        actions = []
        actions << {
          text: '<i class="fa fa-print"></i> '+t('view_print'),
          url: erp_payments.show_modal_backend_payment_records_path(id: payment_record.id),
          class: "modal-link"
        }
        actions << {
            text: '<i class="fa fa-edit"></i> '+t('.edit'),
            url: erp_payments.edit_backend_payment_record_path(payment_record),
            class: "modal-link"
        }
        
        erp_datalist_row_actions(
          actions
        )
      end
    end
  end
end
