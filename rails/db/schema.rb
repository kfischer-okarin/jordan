# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_30_235935) do

  create_table "annotations", force: :cascade do |t|
    t.integer "video_id", null: false
    t.integer "position"
    t.integer "video_timestamp"
    t.text "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["video_id"], name: "index_annotations_on_video_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", null: false
    t.string "user_id", null: false
    t.string "name"
    t.string "email"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "user_id"], name: "index_users_on_provider_and_user_id", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "youtube_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_videos_on_user_id"
    t.index ["youtube_id"], name: "index_videos_on_youtube_id"
  end

  add_foreign_key "annotations", "videos"
  add_foreign_key "videos", "users"
end
