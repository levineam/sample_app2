class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name
      t.string :summary
      t.string :description
      t.integer :user_id

      t.timestamps
    end
    add_index :charities, [:user_id, :created_at]
  end
end
