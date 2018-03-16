module Erp
  module Accounting
    module Backend
      class SalesProductReturnsController < Erp::Backend::BackendController
        def product_returns_list
          @product_returns = Erp::Qdeliveries::Delivery.search(params)
            .accounting_sales_deliveries.get_deliveries_with_payment_for_order
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
