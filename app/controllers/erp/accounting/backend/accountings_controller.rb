module Erp
  module Accounting
    module Backend
      class AccountingsController < Erp::Backend::BackendController
    
        # POST /orders/list
        def accounting_orders_listing
          @orders = Erp::Orders::Order.search(params).status_active_for_orders.paginate(:page => params[:page], :per_page => 5)
          
          render layout: nil
        end
        
      end
    end
  end
end
