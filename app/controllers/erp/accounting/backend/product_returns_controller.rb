module Erp
  module Accounting
    module Backend
      class ProductReturnsController < Erp::Backend::BackendController
        # POST /sales orders/list
        def product_returns_list
          @product_returns = Erp::Qdeliveries::Delivery.search(params)
            .accounting_deliveries
            .paginate(:page => params[:page], :per_page => 10)
          render layout: nil
        end

        def product_return_details
          @product_return = Erp::Qdeliveries::Delivery.find(params[:id])
          render layout: nil
        end
      end
    end
  end
end
