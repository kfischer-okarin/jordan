class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :provider, null: false
      t.string :user_id, null: false
      t.string :name
      t.string :email
      t.timestamps
    end

    add_index :users, %i[provider user_id], unique: true
  end
end
