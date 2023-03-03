require 'rails_helper'

RSpec.describe 'bulk discount edit spec' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Malenas Tours')

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 15)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 12)
    @bulk_discount3 = @merchant2.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 25)

    describe "as a merchant" do
      describe "when visit the bulk discount edit page" do 
        it "i am taken to new page with a form to edit the document" do

        visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1)

        expect(page).to have_selector("form")
        expect(page).to have_field("quantity_threshold")
        expect(page).to have_field("percentage_discount")
        expect(page).to have_button("Edit Bulk Discount")

      end 
    end 
  end 
end 