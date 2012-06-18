class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
    #this adds a remember_token and string column to the users table and
    #and a remember_token index to the user index??
  end
end
