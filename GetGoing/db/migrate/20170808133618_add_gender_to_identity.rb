class AddGenderToIdentity < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :gender, :string
  end
end
