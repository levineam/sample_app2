class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    # we’ve added the argument "default: false" to the original migration
    #to add_column in Listing 9.40, which means that users will not be
    #administrators by default
  end
end
