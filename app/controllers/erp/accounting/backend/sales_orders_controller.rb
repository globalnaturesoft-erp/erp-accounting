module Erp
  module Accounting
    module Backend
      class SalesOrdersController < Erp::Backend::BackendController
        before_action :set_order, only: [:ajax_update_order, :ajax_commission_order]

        # POST /sales orders/list
        def sales_orders_list
          @orders = Erp::Orders::Order.search(params)
            .accounting_sales_orders
            .paginate(:page => params[:page], :per_page => 10)
          render layout: nil
        end

        def sales_order_details
          @order = Erp::Orders::Order.find(params[:id])
          render layout: nil
        end

        def ajax_update_order
          authorize! :update, @order

          if @order.update(order_params)
            @order.update_default_cost_price
            render 'erp/accounting/backend/sales_orders/ajax_cost_tab'
          end
        end

        def ajax_commission_order
          authorize! :update, @order

          if @order.update(order_params)
            @order.update_default_cost_price
            render 'erp/accounting/backend/sales_orders/ajax_commission_tab'
          end
        end

        private
          def set_order
            @order = Erp::Orders::Order.find(params[:id])
          end

          def order_params
            params.fetch(:order, {}).permit(:order_details_attributes => [
              :id, :product_id, :cost_price, :price, :customer_commission, :commission, :discount
            ])
          end

      end
    end
  end
end
