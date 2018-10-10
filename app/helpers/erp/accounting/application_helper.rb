module Erp
  module Accounting
    module ApplicationHelper

      # Order dropdown actions
      def accounting_order_dropdown_actions(order)
        actions = []
        
        actions << {
          text: '<i class="fa fa-print"></i> Xem & In HĐ',
          url: erp_orders.backend_order_path(order),
          class: "modal-link"
        } if can? :print, order
        
        actions << {
          text: '<i class="fa fa-edit"></i> Chỉnh sửa',
          url: erp_orders.edit_backend_order_path(order),
          target: '_blank',
          #class: "modal-link"
        } if can? :update, order
        
        if (can? :receive_sales_order, order) or (can? :pay_sales_order, order) or (can? :receive_purchase_order, order) or (can? :pay_purchase_order, order)
          actions << { divider: true }
        end
        
        actions << {
          text: '<i class="fa fa-level-down"></i> ' + t('.receive_kh'),
          url: erp_payments.new_backend_payment_record_path(
            order_id: order.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_RECEIVE,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_SALES_ORDER)),
          #target: '_blank',
          class: "modal-link has-form"
        } if can? :receive_sales_order, order
        
        actions << {
          text: '<i class="fa fa-level-up"></i> ' + t('.pay_kh'),
          url: erp_payments.new_backend_payment_record_path(
            order_id: order.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_SALES_ORDER)),
          #target: '_blank',
          class: "modal-link has-form"
        } if can? :pay_sales_order, order
        
        actions << {
          text: '<i class="fa fa-level-down"></i> ' + t('.receive_ncc'),
          url: erp_payments.new_backend_payment_record_path(
            order_id: order.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_RECEIVE,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PURCHASE_ORDER)),
          #target: '_blank',
          class: "modal-link has-form"
        } if can? :receive_purchase_order, order
        
        actions << {
          text: '<i class="fa fa-level-up"></i> ' + t('.pay_ncc'),
          url: erp_payments.new_backend_payment_record_path(
            order_id: order.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PURCHASE_ORDER)),
          #target: '_blank',
          class: "modal-link has-form"
        } if can? :pay_purchase_order, order
        
        if can? :delete, order
          if (can? :receive_sales_order, order) or (can? :pay_sales_order, order) or
             (can? :receive_purchase_order, order) or (can? :pay_purchase_order, order) or
             (can? :update, order) or (can? :print, order)
            actions << { divider: true }
          end
        end
        
        actions << {
          text: '<i class="fa fa-trash"></i> '+t('.delete'),
          url: erp_orders.set_deleted_backend_orders_path(id: order),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('.delete_confirm')
        } if can? :delete, order

        erp_datalist_row_actions(
          actions
        )
      end
      
      # Product return - Qdeliveries
      def accounting_delivery_dropdown_actions(delivery)
        actions = []
        
        actions << {
          text: '<i class="fa fa-print"></i> Xem & In phiếu',
          url: erp_qdeliveries.backend_delivery_path(delivery),
          class: "modal-link"
        } if can? :print, delivery
        
        actions << {
          text: '<i class="fa fa-edit"></i> Chỉnh sửa',
          url: erp_qdeliveries.edit_backend_delivery_path(delivery),
          target: '_blank',
          #class: "modal-link"
        } if can? :update, delivery
        
        if (can? :pay_sales_import, delivery)
          actions << { divider: true }
        end
        
        actions << {
          text: '<i class="fa fa-angle-double-right"></i> ' + t('.pay_product_return'),
          url: erp_payments.new_backend_payment_record_path(
            delivery_id: delivery.id,
            pay_receive: Erp::Payments::PaymentRecord::TYPE_PAY,
            payment_type_id: Erp::Payments::PaymentType.find_by_code(Erp::Payments::PaymentType::CODE_PRODUCT_RETURN)),
            #target: '_blank',
            class: "modal-link has-form"
        } if can? :pay_sales_import, delivery
        
        if can? :set_deleted, delivery
          if (can? :pay_sales_import, delivery) or (can? :update, delivery) or (can? :print, delivery)
            actions << { divider: true }
          end
        end
        
        actions << {
          text: '<i class="fa fa-trash"></i> '+t('.delete'),
          url: erp_qdeliveries.set_deleted_backend_deliveries_path(id: delivery),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('.delete_confirm')
        } if can? :set_deleted, delivery

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
        } if can? :print, payment_record
        
        actions << {
            text: '<i class="fa fa-edit"></i> '+t('edit'),
            url: erp_payments.edit_backend_payment_record_path(payment_record),
            target: '_blank',
            class: "modal-link has-form"
        } if can? :update, payment_record
        
        if (can? :set_deleted, payment_record)
          actions << { divider: true }
        end
        
        actions << {
          text: '<i class="fa fa-close"></i> Hủy phiếu',
          url: erp_payments.set_deleted_backend_payment_records_path(id: payment_record),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t("confirm_cancellation_the_#{payment_record.pay_receive}")
        } if can? :set_deleted, payment_record
        
        erp_datalist_row_actions(
          actions
        )
      end
    end
  end
end
