# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_04_164002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_rules", force: :cascade do |t|
    t.date "start_date"
    t.integer "recurrence"
    t.bigint "slot_rule_id", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["slot_rule_id"], name: "index_event_rules_on_slot_rule_id"
    t.index ["status"], name: "index_event_rules_on_status"
    t.index ["user_id"], name: "index_event_rules_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "status", default: 0
    t.date "date"
    t.bigint "user_id", null: false
    t.bigint "slot_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "comment"
    t.string "service_type"
    t.json "settings", default: {}
    t.index ["slot_rule_id"], name: "index_events_on_slot_rule_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "status", default: 0
    t.date "date"
    t.decimal "amount"
    t.string "reference"
    t.text "comments"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "currency"
    t.index ["currency"], name: "index_payments_on_currency"
    t.index ["event_id"], name: "index_payments_on_event_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "time_zone", default: "UTC", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "accepts_event_rules", default: false
    t.boolean "accepts_payments", default: false
    t.string "locale", default: "es"
    t.boolean "accepts_comments", default: false
    t.json "settings", default: {}
    t.boolean "accepts_slot_notes", default: false
    t.index ["slug"], name: "index_services_on_slug"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "slot_rules", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "time"
    t.integer "wday"
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "short_note"
    t.string "long_note"
    t.index ["service_id"], name: "index_slot_rules_on_service_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "time_zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "web_leads", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "event_rules", "slot_rules"
  add_foreign_key "event_rules", "users"
  add_foreign_key "events", "slot_rules"
  add_foreign_key "events", "users"
  add_foreign_key "payments", "events"
  add_foreign_key "services", "users"
  add_foreign_key "slot_rules", "services"
end
