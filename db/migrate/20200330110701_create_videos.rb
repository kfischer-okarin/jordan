class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :youtube_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
