Erp::Accounting::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/accounting" do
			get 'accounting_orders' => 'accountings#accounting_orders', as: :accounting_orders
			post 'accounting_orders_listing' => 'accountings#accounting_orders_listing', as: :accounting_orders_listing
		end
	end
end