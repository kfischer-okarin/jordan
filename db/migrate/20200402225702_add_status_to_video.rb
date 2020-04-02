class AddStatusToVideo < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :status, :integer, default: 0, null: false, index: true

    add_index :videos, %i[user_id status]
  end
end
