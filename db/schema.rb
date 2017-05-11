# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140511064717) do

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.string "location"
    t.string "gender"
    t.string "token"
    t.string "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "goods", force: :cascade do |t|
    t.integer "user_id"
    t.integer "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["playlist_id"], name: "index_goods_on_playlist_id"
    t.index ["user_id"], name: "index_goods_on_user_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.integer "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "track_count", default: 0
    t.integer "view_count", default: 0
    t.index ["playlist_id"], name: "index_playlists_on_playlist_id"
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "playlist_id"
    t.integer "number"
    t.text "player_url"
    t.string "provider"
    t.string "author_name"
    t.integer "duration"
    t.text "description"
    t.string "title"
    t.string "unique_id"
    t.datetime "published_at"
    t.integer "favorite_count"
    t.integer "view_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "hide_top_flag", default: false
    t.index ["playlist_id"], name: "index_tracks_on_playlist_id"
    t.index ["user_id"], name: "index_tracks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "email"
    t.boolean "admin_flag", default: false
    t.string "last_login_provider"
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "view_counts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "playlist_id"
    t.date "footprint_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["playlist_id"], name: "index_view_counts_on_playlist_id"
    t.index ["user_id"], name: "index_view_counts_on_user_id"
  end

end
