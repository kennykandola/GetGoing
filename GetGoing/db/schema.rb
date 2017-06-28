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

ActiveRecord::Schema.define(version: 20170628200419) do

  create_table "booking_links", force: :cascade do |t|
    t.string "url"
    t.integer "url_type"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "response_id"
    t.index ["post_id"], name: "index_booking_links_on_post_id"
    t.index ["response_id"], name: "index_booking_links_on_response_id"
  end

  create_table "identities", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "accesstoken"
    t.string "refreshtoken"
    t.string "uid"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "image"
    t.string "urls"
    t.date "birthday"
    t.integer "age_min"
    t.integer "age_max"
    t.string "hometown"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "offering"
    t.string "who_is_traveling"
    t.text "body"
    t.string "whos_traveling"
    t.string "budget"
    t.string "travel_dates"
    t.string "destination"
    t.integer "user_id"
    t.integer "top_responses_count"
    t.integer "claim", default: 0
    t.string "claimed_users", default: "--- []\n"
    t.string "structured"
    t.string "already_booked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "Open"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "post_id"
    t.integer "user_id"
    t.text "body"
    t.boolean "top", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_responses_on_post_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "tippa"
    t.integer "score"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "profile_picture_url"
    t.integer "age"
    t.string "hometown"
    t.string "location"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "booking_link_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_link_id"], name: "index_votes_on_booking_link_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

end
