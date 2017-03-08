Spree::BaseController.class_eval do

	prepend_before_filter :redirect_supplier

	def redirect_unauthorized_access
		if try_spree_current_user
			# flash[:error] = Spree.t(:authorization_failure)
			redirect_to spree.forbidden_path
		else
			store_location
			if respond_to?(:spree_login_path)
			  redirect_to spree_login_path
			else
			  redirect_to spree.respond_to?(:root_path) ? spree.root_path : main_app.root_path
			end
		end
	end

	private

	def redirect_supplier
		if ['/admin', '/admin/authorization_failure'].include?(request.path) && try_spree_current_user.try(:supplier)
		  redirect_to '/admin/shipments' and return false
		end
	end

end
