class AddTopToResponce < ActiveRecord::Migration
  def change
    add_column :responses, :top, :boolean, default: false
  end
end
