Spree::Product.class_eval do
  after_create :set_supplier

  has_many :suppliers, through: :master
  belongs_to :supplier

  def add_supplier!(supplier_or_id)
    splr = supplier_or_id.is_a?(Spree::Supplier) ? supplier_or_id : Spree::Supplier.find(supplier_or_id)
    populate_for_supplier! splr if splr
  end

  def add_suppliers!(supplier_ids)
    Spree::Supplier.where(id: supplier_ids).each do |splr|
      populate_for_supplier! splr
    end
  end

  # Returns true if the product has a drop shipping supplier.
  def supplier?
    suppliers.present?
  end

  private

  def populate_for_supplier!(supplier)
    variants_including_master.each do |variant|
      unless variant.suppliers.pluck(:id).include?(supplier.id)
        variant.suppliers << supplier
        supplier.stock_locations.each { |location| location.propagate_variant(variant) }
      end
    end
  end

  def set_supplier
    add_supplier! self.supplier
  end

end
