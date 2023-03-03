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
    end
  end
end 