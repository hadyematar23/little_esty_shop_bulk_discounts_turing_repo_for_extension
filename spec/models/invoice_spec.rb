require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
require 'pry'; binding.pry
      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "total_revenue including bulk discounts" do 
      merchant1 = Merchant.create!(name: 'Hair Care')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 8, status: 1)
      ii_12 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 17, unit_price: 5, status: 2)
      ii_13 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 25, unit_price: 5, status: 2)


      bulk_discount1 = merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 15)
      bulk_discount2 = merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 20)
      bulk_discount3 = merchant1.bulk_discounts.create!(quantity_threshold: 20, percentage_discount: 25)

      expect(invoice_1.total_revenue).to eq(246.25)
    end
  end
end


    # discount = (invoice_items.joins(:bulk_discounts).where("invoice_items.quantity > bulk_discounts.quantity_threshold").order(percentage_discount: :desc).pluck("bulk_discounts.percentage_discount").first)/100.0

    # max = self.invoice_items.select("invoice_items.*, MAX(bulk_discounts.percentage_discount) as max_discount").joins(:bulk_discounts).where("invoice_items.quantity > bulk_discounts.quantity_threshold").group(:id)
    
    # self.invoice_items

    # self.invoice_items
    # .joins(:bulk_discounts)
    # .sum("invoice_items.quantity* (invoice_items.unit_price- (invoice_items.unit_price * 1))")

    # total_revenue = self.invoice_items.sum("quantity*unit_price")

    # items_with_discounts = self.invoice_items.select("invoice_items.*, MAX(bulk_discounts.percentage_discount) as max_discount").left_joins(:bulk_discounts).group(:id).where("invoice_items.quantity >= bulk_discounts.quantity_threshold")

        # select("invoice_items.*, MAX(bulk_discounts.percentage_discount) as max_discount").left_
