class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.references :user, index: true, foreign_key: true
      t.string   :provider
      t.string   :accesstoken
      t.string   :refreshtoken
      t.string   :uid
      t.string   :email
      t.string   :first_name
      t.string   :last_name
      t.string   :image
      t.string   :urls
      t.date     :birthday
      t.integer  :age_min
      t.integer  :age_max
      t.string   :hometown
      t.string   :location

      t.timestamps null: false
    end
  end
end
