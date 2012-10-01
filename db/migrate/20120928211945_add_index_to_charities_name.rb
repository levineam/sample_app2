class AddIndexToCharitiesName < ActiveRecord::Migration
  def change
    add_index :charities, :name, unique: true
  end
  # makes sure that if a user clicks submit twice, or two users submit
  #the same name at the same time, 
end
