#created using
#$ rails generate model Micropost content:string user_id:integer
#this produces a migration to create a mp table in the db

class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
  # added the indexes because we expect to retrieve all the mps associated
  #w/a given user id in reverse order of creation
  # By including both the user_id and created_at columns as an array, we
  #arrange for Rails to create a multiple key index, which means that
  #Active Record uses both keys at the same time.
  # the t.timestamps line adds the magic created_at and updated_at columns
end
