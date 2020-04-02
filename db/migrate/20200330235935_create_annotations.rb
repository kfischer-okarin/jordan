class CreateAnnotations < ActiveRecord::Migration[6.0]
  def change
    create_table :annotations do |t|
      t.references :video, null: false, foreign_key: true, index: true
      t.integer :position
      t.integer :video_timestamp
      t.text :payload

      t.timestamps
    end
  end
end
