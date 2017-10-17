module Erp
  module Accounting
    module Backend
      class SalesOrdersController < Erp::Backend::BackendController
        
        # POST /sales orders/list
        def sales_orders_list
          @orders = Erp::Orders::Order.search(params)
                                      .accounting_sales_orders
                                      .where(payment_for: Erp::Orders::Order::PAYMENT_FOR_ORDER) # @todo move 'where' to model
                                      .paginate(:page => params[:page], :per_page => 10)
          render layout: nil
        end
        
        def sales_order_details
          @order = Erp::Orders::Order.find(params[:id])
          render layout: nil
        end
          
      end
    end
  end
end