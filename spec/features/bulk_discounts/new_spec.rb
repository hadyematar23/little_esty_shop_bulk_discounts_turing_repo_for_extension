require 'rails_helper'

RSpec.describe 'bulk discount' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Malenas Tours')

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 15)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 12)
    @bulk_discount3 = @merchant2.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 25)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

  end

  describe "as a merchant" do
    describe "when visit the merchant's new item page" do 
      it "i see a form to fill in with valid data " do #US2
        visit new_merchant_bulk_discount_path(@merchant1)
        
        expect(page).to have_selector("form")
        expect(page).to have_field("bulk_discount[quantity_threshold]")
        expect(page).to have_field("bulk_discount[percentage_discount]")
        expect(page).to have_button("Create Bulk Discount")

      end 

      it "I fill in the form with valid data and I am then redirected back to the bulk discount index and see the new bulk discount listed" do 

        visit new_merchant_bulk_discount_path(@merchant1)

        expect(page).to_not have_content("Quantity Threshold: 12, Percent Discount: 20")

        fill_in "bulk_discount[quantity_threshold]", with: 12
        fill_in "bulk_discount[percentage_discount]", with: 20
        click_button("Create Bulk Discount")
        

        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
        expect(page).to have_content("Quantity Threshold: 12, Percent Discount: 20")
        expect(page).to have_content("New Discount was successfully saved")
      end 

      describe "sad path testing" do 
        it "if you fail to put the proper information, the bulk discount item will not be created and you will be redirected back to the new page again to create the item again" do 

        visit new_merchant_bulk_discount_path(@merchant1)

        fill_in "bulk_discount[quantity_threshold]", with: "A random string"
        fill_in "bulk_discount[percentage_discount]", with: 20
        expect(@merchant1.bulk_discounts.count).to eq(2)
        click_button("Create Bulk Discount")
        

        expect(@merchant1.bulk_discounts.count).to eq(2)
        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
        expect(page).to have_content("Both the percentage discount and the quantity threshold must be completed and must be integers!")
        end 
      end 



      end 
    end 
  end 
