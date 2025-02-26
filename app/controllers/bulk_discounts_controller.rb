class BulkDiscountsController < ApplicationController

  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @merchants_discounts = @merchant.bulk_discounts
    @api_holidays = HolidayFacade.pull_holidays
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.update(bulk_discount_params)
    
    if bulk_discount.save 
      redirect_to merchant_bulk_discount_path(merchant, bulk_discount), notice: "New Discount was successfully edited"
    else 
      redirect_to edit_merchant_bulk_discount_path(merchant, bulk_discount), notice: "Failure to edit- Both the percentage discount and the quantity threshold must be completed and must be integers!"
    end 
  end

  def edit 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(merchant), notice: "Discount was successfully deleted"
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if @bulk_discount.save 
      redirect_to merchant_bulk_discounts_path(@merchant), notice: "New Discount was successfully saved"
    else 
      redirect_to new_merchant_bulk_discount_path(@merchant), notice: "Both the percentage discount and the quantity threshold must be completed and must be integers!"
    end 
  end

  private 

  def bulk_discount_params
    params.require(:bulk_discount).permit(:quantity_threshold, :percentage_discount)
  end

end