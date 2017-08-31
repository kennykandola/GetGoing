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

ActiveRecord::Schema.define(version: 20170831133213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "actor_id"
    t.integer "acted_id"
    t.integer "action"
    t.integer "actionable_id"
    t.string "actionable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actionable_type", "actionable_id"], name: "index_activities_on_actionable_type_and_actionable_id"
    t.index ["actor_id"], name: "index_activities_on_actor_id"
  end

  create_table "booking_link_types", force: :cascade do |t|
    t.string "name"
    t.string "url_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_accommodation", default: false
  end

  create_table "booking_link_types_posts", force: :cascade do |t|
    t.bigint "booking_link_type_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_link_type_id", "post_id"], name: "index_booking_link_types_posts", unique: true
    t.index ["booking_link_type_id"], name: "index_booking_link_types_posts_on_booking_link_type_id"
    t.index ["post_id"], name: "index_booking_link_types_posts_on_post_id"
  end

  create_table "booking_links", force: :cascade do |t|
    t.string "url"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.bigint "response_id"
    t.bigint "booking_link_type_id"
    t.string "title"
    t.integer "affiliate_revenue_cents", default: 0, null: false
    t.string "affiliate_revenue_currency", default: "USD", null: false
    t.boolean "clicked_by_author", default: false
    t.datetime "clicked_by_author_at"
    t.index ["booking_link_type_id"], name: "index_booking_links_on_booking_link_type_id"
    t.index ["post_id"], name: "index_booking_links_on_post_id"
    t.index ["response_id"], name: "index_booking_links_on_response_id"
  end

  create_table "claims", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_claims_on_post_id"
    t.index ["user_id", "post_id"], name: "index_claims_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_claims_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "response_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["response_id"], name: "index_comments_on_response_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id"
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
    t.string "gender"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "read_at"
    t.integer "action", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "place_post_relations", force: :cascade do |t|
    t.bigint "place_id"
    t.bigint "post_id"
    t.index ["place_id", "post_id"], name: "index_place_post_relations_on_place_id_and_post_id", unique: true
    t.index ["place_id"], name: "index_place_post_relations_on_place_id"
    t.index ["post_id"], name: "index_place_post_relations_on_post_id"
  end

  create_table "place_user_relations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "place_id"
    t.integer "relation", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_place_user_relations_on_place_id"
    t.index ["relation"], name: "index_place_user_relations_on_relation"
    t.index ["user_id", "place_id", "relation"], name: "place_user_relations_index", unique: true
    t.index ["user_id"], name: "index_place_user_relations_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "google_place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "state"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.integer "place_type", default: 0
    t.index ["google_place_id"], name: "index_places_on_google_place_id", unique: true
  end

  create_table "post_users", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "user_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "user_id"], name: "post_user_index", unique: true
    t.index ["post_id"], name: "index_post_users_on_post_id"
    t.index ["role"], name: "index_post_users_on_role"
    t.index ["user_id"], name: "index_post_users_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "offering"
    t.string "who_is_traveling"
    t.text "body"
    t.string "budget"
    t.integer "top_responses_count"
    t.string "structured"
    t.string "already_booked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "expired_at"
    t.boolean "status", default: true, null: false
    t.boolean "claims_available", default: true
    t.string "invitation_token"
    t.date "travel_start"
    t.date "travel_end"
    t.text "amenities", default: [], array: true
    t.string "location_from"
    t.float "location_distance"
    t.string "neighborhoods"
    t.integer "traveler_rating"
    t.text "accomodation_style", default: [], array: true
    t.integer "min_accomodation_price"
    t.integer "max_accomodation_price"
    t.string "travel_style"
    t.integer "people_total", default: 1
    t.string "destination"
    t.index ["invitation_token"], name: "index_posts_on_invitation_token", unique: true
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "user_id"
    t.text "body"
    t.boolean "top", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discussion_privacy", default: 0, null: false
    t.index ["post_id"], name: "index_responses_on_post_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "spot_user_relations", force: :cascade do |t|
    t.bigint "spot_id"
    t.bigint "user_id"
    t.index ["spot_id", "user_id"], name: "index_spot_user_relations_on_spot_id_and_user_id", unique: true
    t.index ["spot_id"], name: "index_spot_user_relations_on_spot_id"
    t.index ["user_id"], name: "index_spot_user_relations_on_user_id"
  end

  create_table "spots", force: :cascade do |t|
    t.string "name"
    t.string "fb_id"
    t.bigint "place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fb_id"], name: "index_spots_on_fb_id", unique: true
    t.index ["place_id"], name: "index_spots_on_place_id"
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
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "sex"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "booking_link_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_link_id"], name: "index_votes_on_booking_link_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "booking_link_types_posts", "booking_link_types"
  add_foreign_key "booking_link_types_posts", "posts"
  add_foreign_key "booking_links", "booking_link_types"
  add_foreign_key "booking_links", "posts"
  add_foreign_key "booking_links", "responses"
  add_foreign_key "claims", "posts"
  add_foreign_key "claims", "users"
  add_foreign_key "comments", "responses"
  add_foreign_key "comments", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "place_post_relations", "places"
  add_foreign_key "place_post_relations", "posts"
  add_foreign_key "post_users", "posts"
  add_foreign_key "post_users", "users"
  add_foreign_key "responses", "posts"
  add_foreign_key "responses", "users"
  add_foreign_key "spot_user_relations", "spots"
  add_foreign_key "spot_user_relations", "users"
  add_foreign_key "spots", "places"
  add_foreign_key "votes", "booking_links"
  add_foreign_key "votes", "users"
end
