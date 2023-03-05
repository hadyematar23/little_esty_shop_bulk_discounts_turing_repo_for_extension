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
    describe "when taken to merchant's bulk discounts index page" do 
      it "i see all of the bulk discounts listed there " do #US1
        visit merchant_bulk_discounts_path(@merchant1)

        within("div#list_bulk_discounts") do 
          expect(page).to have_content("Bulk Discounts")

          expect(page).to have_content("Quantity Threshold: #{@bulk_discount1.quantity_threshold}, Percent Discount: #{@bulk_discount1.percentage_discount}")

          expect(page).to have_content("Quantity Threshold: #{@bulk_discount2.quantity_threshold}, Percent Discount: #{@bulk_discount2.percentage_discount}")

          expect(page).to_not have_content("Quantity Threshold: #{@bulk_discount3.quantity_threshold}, Percent Discount: #{@bulk_discount3.percentage_discount}")

        end
      end 

      it "each bulk discount has a link to its show page" do #US1
        visit merchant_bulk_discounts_path(@merchant1)

        within("div#bulk_discount_number#{@bulk_discount1.id}") do   
          expect(page).to have_link("Link", href: merchant_bulk_discount_path(@merchant1, @bulk_discount1) )
        end 
      end 


      it "See a link to create a new discount" do #US2
        visit merchant_bulk_discounts_path(@merchant1)

        expect(page).to have_link("Create New Bulk Discount", href: new_merchant_bulk_discount_path(@merchant1))

      end 

      it "See a link to create a new discount" do #US2
        visit merchant_bulk_discounts_path(@merchant1)

        click_link("Create New Bulk Discount")

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))

      end 

      it "Next to each bulk discount item I see a link to delete this item" do 
        visit merchant_bulk_discounts_path(@merchant1)

        within("div#bulk_discount_number#{@bulk_discount1.id}") do  

          expect(page).to have_selector("a[href='#{merchant_bulk_discount_path(@merchant1, @bulk_discount1)}'][data-method='delete']", text: "Delete Discount")
        end 
      end 

      it "I click on that delete discount link and am redirected back to the index and will not see the delete discount anymore on the index" do 
        visit merchant_bulk_discounts_path(@merchant1)

        within("div#bulk_discount_number#{@bulk_discount1.id}") do  

          expect(page).to have_content("Quantity Threshold: #{@bulk_discount1.quantity_threshold}, Percent Discount: #{@bulk_discount1.percentage_discount}")

          expect(@merchant1.bulk_discounts.count).to eq(2)

          click_link("Delete Discount")
        end 
          expect(@merchant1.bulk_discounts.count).to eq(1)
          

          expect(page).to_not have_content("Quantity Threshold: #{@bulk_discount1.quantity_threshold}, Percent Discount: #{@bulk_discount1.percentage_discount}")

          expect(page).to have_content("Discount was successfully deleted")
      end 

      it "I see a section with the header of 'Upcoming Holidays' listing the next 3 holidays" do 
        visit merchant_bulk_discounts_path(@merchant1)

        within("div#holidays") do 
          expect(page).to have_content("Upcoming Holidays")
          expect(page).to have_content("March 20, 2023: Natalicio de Benito Juárez")
          expect(page).to have_content("May 1, 2023: Día del Trabajo")
          expect(page).to have_content("September 15, 2023: Día de la Independencia")
        end



      end
        
    end
  end
end 