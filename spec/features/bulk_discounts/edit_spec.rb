require 'rails_helper'

RSpec.describe 'bulk discount edit spec' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Malenas Tours')

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 15)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 12)
    @bulk_discount3 = @merchant2.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 25)
  end 
    describe "as a merchant" do
      describe "when visit the bulk discount edit page" do 
        it "i am taken to new page with a form to edit the document and the current discount attributes are pre-populated in the form" do

        visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1)

        expect(page).to have_selector("form")
        expect(find_field("bulk_discount[quantity_threshold]").value).to eq("10")
        expect(find_field("bulk_discount[percentage_discount]").value).to eq("15.0")

      end 

      it "when i change the information in the form and click submit, am redirected to the bulk discount's new show page and see the attributes have been updated" do 
        visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1)

        fill_in "bulk_discount[quantity_threshold]", with: 20
        fill_in "bulk_discount[percentage_discount]", with: 40
        click_button("Edit Bulk Discount")
        save_and_open_page
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount1))
        expect(page).to have_content("In order to acheive this discount of 40.0, you must purchase 20.")
        expect(page).to have_content("New Discount was successfully edited")
        
      end

      describe "sad path test" do 
        it "if you submit something that is not an integer or leave it empty, you will get a flash erro message and be redirected back to the edit page" do 
          visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1)
  
          fill_in "bulk_discount[quantity_threshold]", with: nil
          fill_in "bulk_discount[percentage_discount]", with: 40
          click_button("Edit Bulk Discount")
          
          expect(page).to have_content("Failure to edit- Both the percentage discount and the quantity threshold must be completed and must be integers!")
          expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1))
     
        end
      end
    end 
  end 
end 