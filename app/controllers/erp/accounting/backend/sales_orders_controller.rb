module Erp
  module Accounting
    module Backend
      class SalesOrdersController < Erp::Backend::BackendController
        before_action :set_order, only: [:ajax_update_order, :ajax_commission_order]
        
        def index
          authorize! :accounting_chase_chase_sales, nil
        end
        
        # POST /sales orders/list
        def sales_orders_list
          @orders = Erp::Orders::Order.search(params)
            .accounting_sales_orders
            .paginate(:page => params[:page], :per_page => 10)
          render layout: nil
        end

        def sales_order_details
          @order = Erp::Orders::Order.find(params[:id])
          render layout: nil
        end

        def ajax_update_order
          authorize! :update, @order

          if @order.update(order_params)
            @order.update_default_cost_price
            render 'erp/accounting/backend/sales_orders/ajax_cost_tab'
          end
        end

        def ajax_commission_order
          authorize! :update, @order

          if @order.update(order_params)
            @order.update_default_cost_price
            render 'erp/accounting/backend/sales_orders/ajax_commission_tab'
          end
        end
        
        def update_discount
          @filters = params.to_unsafe_hash[:global_filter].present? ? params.to_unsafe_hash[:global_filter] : {}
          @customer = params[:customer_id].present? ? Erp::Contacts::Contact.find(params[:customer_id]) : nil
          
          session[:update_discount_url] = request.original_url
        end
        
        def update_discount_table
          @orders = Erp::Orders::Order.search(params)
            .accounting_sales_orders            
            
          @full_orders = @orders
          
          # filter
          filters = params.to_unsafe_hash[:global_filter]
          
          # if has period
          if filters[:period].present?
            @period = Erp::Periods::Period.find(filters[:period])
            filters[:from_date] = @period.from_date
            filters[:to_date] = @period.to_date
          end

          @from_date = filters[:from_date].to_date
          @to_date = filters[:to_date].to_date
          
          # params
          @customer = filters[:customer].present? ? Erp::Contacts::Contact.find(filters[:customer]) : nil
          @discount_percent = filters[:discount_percent].present? ? filters[:discount_percent].to_f : nil
          # get categories
          category_ids = filters[:categories].present? ? filters[:categories] : nil
          @categories = Erp::Products::Category.where(id: category_ids)
          # get diameters
          diameter_ids = filters[:diameters].present? ? filters[:diameters] : nil
          diameter_ids = !diameter_ids.kind_of?(Array) ? [diameter_ids] : diameter_ids if !diameter_ids.nil?
          # get diameters
          letter_ids = filters[:letters].present? ? filters[:letters] : nil
          letter_ids = !letter_ids.kind_of?(Array) ? [letter_ids] : letter_ids if !letter_ids.nil?
          # get numbers
          number_ids = filters[:numbers].present? ? filters[:numbers] : nil
          number_ids = !number_ids.kind_of?(Array) ? [number_ids] : number_ids if !number_ids.nil?
          # get states
          state_ids = filters[:price_patient_states].present? ? filters[:price_patient_states] : nil
          state_ids = !state_ids.kind_of?(Array) ? [state_ids] : state_ids if !state_ids.nil?
          
          @orders = @orders.paginate(:page => params[:page], :per_page => 100)
          
          if @customer.present? and (@form_date.present? or @to_date.present?)
            # patient sate table
            @pstates = {rows: {}, count: 0, amount: 0, after_amount: 0}
            
            # category table
            @categories_table = {rows: {}, count: 0, amount: 0, after_amount: 0}
            
            
            cids = @categories.map(&:id)
            @orders.each do |o|
              o.patient_state_id = -1 if !o.patient_state_id.present?
              
              # patient sate
              if @pstates[:rows][o.patient_state_id].present?
                @pstates[:rows][o.patient_state_id][:count] += 1
                @pstates[:rows][o.patient_state_id][:total_without_tax] += o.subtotal
              else
                @pstates[:rows][o.patient_state_id] = {state: Erp::OrthoK::PatientState.where(id: o.patient_state_id).first}
                @pstates[:rows][o.patient_state_id][:count] = 1
                @pstates[:rows][o.patient_state_id][:total_without_tax] = o.subtotal
                
                @pstates[:rows][o.patient_state_id][:after_total_without_tax] = 0
              end
              
              @pstates[:count] += 1
              @pstates[:amount] += o.subtotal
              
              o.order_details.each do |od|
                # categories table before discount
                if @categories_table[:rows][od.product.category_id].present?
                  @categories_table[:rows][od.product.category_id][:count] += od.quantity
                  @categories_table[:rows][od.product.category_id][:total_without_tax] += od.subtotal
                else
                  @categories_table[:rows][od.product.category_id] = {category: od.product.category}
                  @categories_table[:rows][od.product.category_id][:count] = od.quantity
                  @categories_table[:rows][od.product.category_id][:total_without_tax] = od.subtotal
                  
                  @categories_table[:rows][od.product.category_id][:after_total_without_tax] = 0
                end
                
                @categories_table[:count] += od.quantity
                @categories_table[:amount] += od.subtotal
                
                if @discount_percent.present?
                  if !state_ids.present? or state_ids.include?(o.patient_state_id.to_s)
                    if (
                        !@categories.present? or
                        cids.include?(od.product.category_id) or
                        (od.product.category.present? and od.product.category.parent_id.present? and cids.include?(od.product.category.parent_id))
                      ) and 
                      (!diameter_ids.present? or (od.product.get_diameter_properties_value.present? and diameter_ids.include?(od.product.get_diameter_properties_value))) and
                      (!number_ids.present? or (od.product.get_diameter_properties_value.present? and number_ids.include?(od.product.get_number_properties_value))) and
                      (!letter_ids.present? or (od.product.get_diameter_properties_value.present? and letter_ids.include?(od.product.get_letter_properties_value)))
                        od.discount = (@discount_percent/100.00)*(od.subtotal)
                    end
                  end
                end
                
                # categories table before discount
                @categories_table[:rows][od.product.category_id][:after_total_without_tax] += od.total_without_tax
                
                @categories_table[:after_amount] += od.total_without_tax
              end
              
              
              @pstates[:rows][o.patient_state_id][:after_total_without_tax] += o.total_without_tax              
              @pstates[:after_amount] += o.total_without_tax
            end
          end
          
          render layout: nil
        end
        
        def update_discount_run
          params.to_unsafe_hash[:order_details].each do |row|
            od = Erp::Orders::OrderDetail.find(row[0])
            od.update_attribute(:discount, row[1]["discount"])
          end
        end

        private
          def set_order
            @order = Erp::Orders::Order.find(params[:id])
          end

          def order_params
            params.fetch(:order, {}).permit(:order_details_attributes => [
              :id, :product_id, :cost_price, :price, :customer_commission, :commission, :discount
            ])
          end

      end
    end
  end
end
