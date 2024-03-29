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

ActiveRecord::Schema.define(version: 2021_04_27_075016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

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
    t.string "checkout_session_id"
    t.string "payment_intent_id"
    t.string "charge_id"
    t.string "refund_id"
    t.boolean "cgv_agreement", default: false
    t.string "giftcard_id"
    t.float "giftcard_amount_spent"
    t.string "stripe_giftcard_transfer"
    t.datetime "cancelled_at"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "phone_number"
    t.string "address_complement"
    t.string "kit_expedition_status"
    t.string "kit_expedition_link"
    t.float "refund_rate", default: 1.0
    t.float "fee", default: 0.2
    t.float "workshop_unit_price"
    t.boolean "tva_applicable"
    t.index ["session_id"], name: "index_bookings_on_session_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "room_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user1"
    t.integer "user2"
  end

  create_table "fee_invoices", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_fee_invoices_on_profile_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "giftcards", force: :cascade do |t|
    t.float "amount"
    t.string "code"
    t.integer "buyer"
    t.integer "receiver"
    t.string "status"
    t.boolean "db_status", default: true
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "receiver_name"
    t.string "buyer_name"
    t.string "message"
    t.string "payment_intent_id"
    t.string "charge_id"
    t.string "refund_id"
    t.string "checkout_session_id"
    t.float "initial_amount"
    t.text "stripe_transfers", default: ""
    t.date "deadline_date"
    t.boolean "cgv_agreement", default: false
    t.date "refunded_at"
    t.index ["user_id"], name: "index_giftcards_on_user_id"
  end

  create_table "infomessages", force: :cascade do |t|
    t.string "subject"
    t.text "content"
    t.bigint "session_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_infomessages_on_session_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "chatroom_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "phone_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.float "latitude"
    t.float "longitude"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
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
    t.string "slug"
    t.boolean "ready", default: false
    t.string "accountant_company"
    t.string "accountant_address"
    t.string "accountant_zip_code"
    t.string "accountant_city"
    t.string "accountant_phone_number"
    t.float "fee", default: 0.2
    t.text "legal_mention"
    t.boolean "tva_applicable", default: false
    t.string "tva_intra"
    t.string "rcs_or_rm"
    t.string "company_type"
    t.string "company_capital"
    t.index ["slug"], name: "index_profiles_on_slug", unique: true
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
    t.date "start_date"
    t.string "start_time"
    t.integer "capacity"
    t.bigint "workshop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "db_status", default: true
    t.string "reason"
    t.string "stripe_product_id"
    t.string "stripe_price_id"
    t.string "end_time"
    t.date "end_date"
    t.boolean "one_day", default: false
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "provider"
    t.string "uid"
    t.string "access_code"
    t.string "publishable_key"
    t.string "stripe_provider"
    t.string "stripe_uid"
    t.string "stripe_id"
    t.string "stripe_order_id"
    t.boolean "created_by_admin", default: false
    t.boolean "newsletter_agreement", default: false
    t.boolean "cgu_agreement", default: false
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
    t.string "slug"
    t.boolean "ephemeral", default: false
    t.boolean "kit", default: false
    t.text "kit_description"
    t.boolean "visio", default: false
    t.float "kit_shipping_price"
    t.boolean "privatization", default: false
    t.index ["place_id"], name: "index_workshops_on_place_id"
    t.index ["slug"], name: "index_workshops_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "animators", "users"
  add_foreign_key "animators", "workshops"
  add_foreign_key "bookings", "sessions"
  add_foreign_key "bookings", "users"
  add_foreign_key "fee_invoices", "profiles"
  add_foreign_key "giftcards", "users"
  add_foreign_key "infomessages", "sessions"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "places", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "users"
  add_foreign_key "sessions", "workshops"
  add_foreign_key "workshops", "places"
end
