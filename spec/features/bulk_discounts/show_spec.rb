require 'rails_helper'

RSpec.describe 'bulk discount show page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Malenas Tours')

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 15)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 12)
    @bulk_discount3 = @merchant2.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 25)

  end 
  describe "as a merchant" do
    describe "when visit the bulk discount show page" do 
      it "i see the bulk discount's quantity threshold and percentage discount " do 

        visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)

        expect(page).to have_content("In order to acheive this discount of #{@bulk_discount1.percentage_discount}, you must purchase #{@bulk_discount1.quantity_threshold}.")

      end 

      it "I see a link to edit the bulk discount" do 
        visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)

        expect(page).to have_link("Edit Discount", href: edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1) )
      end

      it "when I click this link to edit the discount, I am takne to a new page with a form to edit the document" do 
        visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)

        click_link("Edit Discount")
        
        expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1))
        
      end

    end
  end
end 