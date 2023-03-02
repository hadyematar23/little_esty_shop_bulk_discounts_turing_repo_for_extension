class RemoveForeignKeyFromMerchants < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :merchants, :merchants
  end
end
