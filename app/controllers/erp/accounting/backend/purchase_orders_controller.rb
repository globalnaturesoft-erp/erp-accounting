module Erp
  module Accounting
    module Backend
      class PurchaseOrdersController < Erp::Backend::BackendController
        
        # POST /sales orders/list
        def purchase_orders_list
          @orders = Erp::Orders::Order.search(params)
                                      .accounting_purchase_orders
                                      .where(payment_for: Erp::Orders::Order::PAYMENT_FOR_ORDER) # @todo move 'where' to model
                                      .paginate(:page => params[:page], :per_page => 10)
          render layout: nil
        end
        
        def purchase_order_details
          @order = Erp::Orders::Order.find(params[:id])
          render layout: nil
        end
          
      end
    end
  end
end