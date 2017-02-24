require_dependency "erp/application_controller"

module Erp
  module Accounting
    module Backend
      class OrdersController < Erp::Backend::BackendController
    
        # POST /orders/list
        def list
          @orders = Erp::Orders::Order.search(params).paginate(:page => params[:page], :per_page => 5)
          
          render layout: nil
        end
        
      end
    end
  end
end
