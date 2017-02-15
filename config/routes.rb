Erp::Accounting::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/accounting" do
			resources :orders do
				collection do
					post 'list'
				end
			end
		end
	end
end