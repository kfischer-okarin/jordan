class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :youtube_id, null: false, index: true
      t.references :user, null: false

      t.timestamps
    end
  end
end
