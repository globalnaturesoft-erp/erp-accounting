Erp::Accounting::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/accounting" do
			get 'accounting_orders' => 'accountings#accounting_orders', as: :accounting_orders
			post 'accounting_orders_listing' => 'accountings#accounting_orders_listing', as: :accounting_orders_listing
			
			resources :sales_orders do
				collection do
					post 'sales_orders_list'
          get 'sales_order_details'
				end
			end
			
			resources :purchase_orders do
				collection do
					post 'purchase_orders_list'
          get 'purchase_order_details'
				end
			end
			
		end
	end
end