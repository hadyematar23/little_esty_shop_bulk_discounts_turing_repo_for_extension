class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :quantity_threshold
      t.float :percentage_discount
    end
  end
end
