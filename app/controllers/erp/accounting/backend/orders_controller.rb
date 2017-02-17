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
        
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_order
            @order = Erp::Orders::Order.find(params[:id])
          end
    
          # Only allow a trusted parameter "white list" through.
          def order_params
            params.fetch(:order, {})
          end
      end
    end
  end
end
