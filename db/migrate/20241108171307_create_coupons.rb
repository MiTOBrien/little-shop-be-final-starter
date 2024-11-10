class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :dollars_off
      t.float :percent_off
      t.boolean :active

      t.timestamps
    end
  end
end
