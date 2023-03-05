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
    it "total_revenue does not include the bulk discounts" do
      merchant1 = Merchant.create!(name: 'Hair Care')
      merchant2 = Merchant.create!(name: 'Shoes')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      item_9 = Item.create!(name: "Tour", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant2.id)
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 10, status: 1)
      ii_12 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_9.id, quantity: 1, unit_price: 10, status: 1)


      bulk_discount1 = merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 15)

      expect(invoice_1.total_merchant_revenue(merchant1)).to eq(100)
    end

    it "total_revenue including bulk discounts with multiple data points- TEST 1" do 
      merchant1 = Merchant.create!(name: 'Hair Care')
      merchant2 = Merchant.create!(name: 'Hady')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 8, status: 1)
      ii_12 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 17, unit_price: 5, status: 2)
      ii_13 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 25, unit_price: 5, status: 2)
      ii_14 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 2, unit_price: 100, status: 2)


      bulk_discount1 = merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 15)
      bulk_discount2 = merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 20)
      bulk_discount3 = merchant1.bulk_discounts.create!(quantity_threshold: 20, percentage_discount: 25)
      bulk_discount4 = merchant1.bulk_discounts.create!(quantity_threshold: 2, percentage_discount: 12)

      expect(invoice_1.total_discounted_revenue).to eq(422.25)
    end

    it "total_revenue including bulk discounts with multiple data points- TEST 2" do 
      merchant1 = Merchant.create!(name: 'Hair Care')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 15, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 3, unit_price: 10, status: 1)
      ii_15 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 100, status: 1)
      ii_12 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 17, unit_price: 5, status: 2)
      ii_13 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 25, unit_price: 8, status: 2)
  
  
      bulk_discount1 = merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 15)
      bulk_discount2 = merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 20)
      bulk_discount3 = merchant1.bulk_discounts.create!(quantity_threshold: 20, percentage_discount: 25)

      expect(invoice_1.total_discounted_revenue).to eq(411.75)
    end

    it "total_revenue including bulk discounts with multiple data points- items with different merchants" do 
      merchant1 = Merchant.create!(name: 'Hair Care')
      merchant2 = Merchant.create!(name: 'Hady')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      item_9 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant2.id)

      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 15, unit_price: 10, status: 1)
      ii_12 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_9.id, quantity: 15, unit_price: 10, status: 1)

      bulk_discount1 = merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 20)
      bulk_discount2 = merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 30)

      expect(invoice_1.total_discounted_revenue).to eq(351)
    end
  end
end

