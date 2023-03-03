class BulkDiscountsController < ApplicationController

  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @merchants_discounts = @merchant.bulk_discounts
  end

  def show
    
  end

end