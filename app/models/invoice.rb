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
    discount = invoice_items
      .joins(:bulk_discounts)
      .where("invoice_items.quantity > bulk_discounts.quantity_threshold")
      .pluck("bulk_discounts.percentage_discount")
      .first

    self.invoice_items
      .joins(:bulk_discounts)
      .where("invoice_items.quantity > bulk_discounts.quantity_threshold")
      .sum("invoice_items.quantity* (invoice_items.unit_price- (invoice_items.unit_price * #{discount}/100))")
  end
end
