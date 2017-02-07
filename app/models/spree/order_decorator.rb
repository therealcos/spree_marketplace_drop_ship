Spree::Order.class_eval do

  has_many :stock_locations, through: :shipments
  has_many :suppliers, through: :stock_locations

end
