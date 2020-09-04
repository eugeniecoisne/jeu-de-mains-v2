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

ActiveRecord::Schema.define(version: 2020_09_04_095538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "animators", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "workshop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.index ["user_id"], name: "index_animators_on_user_id"
    t.index ["workshop_id"], name: "index_animators_on_workshop_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "quantity"
    t.string "status"
    t.float "amount", default: 0.0, null: false
    t.bigint "user_id", null: false
    t.bigint "session_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.index ["session_id"], name: "index_bookings_on_session_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.text "description"
    t.string "phone_number"
    t.string "email"
    t.boolean "ephemeral", default: false
    t.string "siret_number"
    t.string "website"
    t.string "instagram"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.boolean "verified", default: false
    t.float "latitude"
    t.float "longitude"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "phone_number"
    t.string "role"
    t.string "company"
    t.string "siret_number"
    t.string "website"
    t.string "instagram"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.integer "rating"
    t.bigint "user_id", null: false
    t.bigint "booking_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.date "date"
    t.string "start_at"
    t.integer "capacity"
    t.bigint "workshop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.index ["workshop_id"], name: "index_sessions_on_workshop_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.boolean "admin", default: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workshops", force: :cascade do |t|
    t.string "title"
    t.text "program"
    t.text "final_product"
    t.string "thematic"
    t.string "level"
    t.integer "duration"
    t.float "price", default: 0.0, null: false
    t.string "status"
    t.integer "capacity"
    t.bigint "place_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.boolean "verified", default: false
    t.integer "recommendable", default: 1
    t.index ["place_id"], name: "index_workshops_on_place_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "animators", "users"
  add_foreign_key "animators", "workshops"
  add_foreign_key "bookings", "sessions"
  add_foreign_key "bookings", "users"
  add_foreign_key "places", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "users"
  add_foreign_key "sessions", "workshops"
  add_foreign_key "workshops", "places"
end
