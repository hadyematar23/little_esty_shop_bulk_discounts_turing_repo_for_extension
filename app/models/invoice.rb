class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_merchant_revenue(merchant)
    self.invoice_items
    .where(invoice_items: {item_id: (self.items.where(items: {merchant_id: merchant.id})).ids})
    .sum("unit_price * quantity")
  end

  def total_discounted_revenue(merchant) #merchant_specific 

    max_items_with_discounts = self.invoice_items
    .select("invoice_items.*, MAX((invoice_items.quantity*invoice_items.unit_price)*(bulk_discounts.percentage_discount/100)) as max_ind_discount")
    .joins(:bulk_discounts)
    .where(bulk_discounts: {merchant_id: merchant.id})
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
    .group(:id)
    .sum(&:max_ind_discount)
 
  total_merchant_revenue(merchant) - max_items_with_discounts

  end

  def total_discounted_revenue_all_merchants #non-merchant specific 

    max_items_with_discounts = self.invoice_items
    .select("invoice_items.*, MAX((invoice_items.quantity*invoice_items.unit_price)*(bulk_discounts.percentage_discount/100)) as max_ind_discount")
    .joins(:bulk_discounts)
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
    .group(:id)
    .sum(&:max_ind_discount)
 
  total_revenue - max_items_with_discounts

  end

end



