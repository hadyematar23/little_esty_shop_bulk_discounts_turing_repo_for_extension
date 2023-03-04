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
    
    max_items_with_discounts = self.invoice_items.select("invoice_items.*, MAX(bulk_discounts.percentage_discount/100) as max_ind_discount").joins(:bulk_discounts).where("invoice_items.quantity >= bulk_discounts.quantity_threshold").group(:id)

   (self.invoice_items.where.not(id: max_items_with_discounts.ids).sum("quantity*unit_price"))+(self.invoice_items.joins(:bulk_discounts).joins("INNER JOIN (#{max_items_with_discounts.to_sql}) as max_discounts ON max_discounts.id = invoice_items.id").distinct.sum("invoice_items.quantity* (invoice_items.unit_price- (invoice_items.unit_price * max_discounts.max_ind_discount ))"))


  end
end


    # items_with_discounts = self.invoice_items.select("invoice_items.*, MAX(bulk_discounts.percentage_discount) as max_discount").left_joins(:bulk_discounts).group(:id).where("invoice_items.quantity >= bulk_discounts.quantity_threshold")

    # y = self.invoice_items.joins(:bulk_discounts).joins("INNER JOIN (#{max_items_with_discounts.to_sql}) as max_discounts ON max_discounts.id = invoice_items.id").distinct.sum("invoice_items.quantity* (invoice_items.unit_price- (invoice_items.unit_price * max_discounts.max_ind_discount ))")

