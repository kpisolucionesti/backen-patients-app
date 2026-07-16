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

ActiveRecord::Schema[7.0].define(version: 2023_07_11_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doctors", force: :cascade do |t|
    t.string "name"
    t.string "speciality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "email_settings", force: :cascade do |t|
    t.string "smtp_address"
    t.integer "smtp_port", default: 587
    t.string "smtp_username"
    t.string "smtp_password"
    t.string "sender_email"
    t.string "authentication", default: "login"
    t.boolean "enable_starttls_auto", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emergencies", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.date "ingress_date"
    t.integer "status", default: 1
    t.string "medical_exit"
    t.string "diagnostic"
    t.string "treatment"
    t.string "observations"
    t.string "transfer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.datetime "egress_at"
    t.index ["created_by_id"], name: "index_emergencies_on_created_by_id"
    t.index ["ingress_date"], name: "index_emergencies_on_ingress_date"
    t.index ["patient_id", "status"], name: "index_emergencies_on_patient_id_and_status"
    t.index ["patient_id"], name: "index_emergencies_on_patient_id"
    t.index ["status"], name: "index_emergencies_on_status"
  end

  create_table "emergency_doctors", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.bigint "doctor_id", null: false
    t.boolean "primary", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_emergency_doctors_on_doctor_id"
    t.index ["emergency_id"], name: "index_emergency_doctors_on_emergency_id"
  end

  create_table "medical_plans", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.bigint "doctor_id"
    t.text "description", null: false
    t.string "indication_type", null: false
    t.string "status", default: "active"
    t.datetime "completed_at"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_medical_plans_on_created_by_id"
    t.index ["doctor_id"], name: "index_medical_plans_on_doctor_id"
    t.index ["emergency_id"], name: "index_medical_plans_on_emergency_id"
    t.index ["indication_type"], name: "index_medical_plans_on_indication_type"
    t.index ["status"], name: "index_medical_plans_on_status"
  end

  create_table "notes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.integer "patient_id"
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_notes_on_created_by_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "ci"
    t.string "name"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birthday"
    t.string "lastname"
    t.string "representante"
    t.string "representante_ci"
    t.bigint "created_by_id"
    t.index ["ci"], name: "index_patients_on_ci", unique: true
    t.index ["created_by_id"], name: "index_patients_on_created_by_id"
    t.index ["lastname"], name: "index_patients_on_lastname"
    t.index ["name"], name: "index_patients_on_name"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.jsonb "permissions", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_profiles_on_name", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_type"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "patient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "authentication_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.bigint "profile_id"
    t.jsonb "permissions", default: []
    t.string "username", null: false
    t.string "lastname"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profile_id"], name: "index_users_on_profile_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "emergencies", "patients"
  add_foreign_key "emergencies", "users", column: "created_by_id"
  add_foreign_key "emergency_doctors", "doctors"
  add_foreign_key "emergency_doctors", "emergencies"
  add_foreign_key "medical_plans", "doctors"
  add_foreign_key "medical_plans", "emergencies"
  add_foreign_key "medical_plans", "users", column: "created_by_id"
  add_foreign_key "notes", "users", column: "created_by_id"
  add_foreign_key "patients", "users", column: "created_by_id"
  add_foreign_key "users", "profiles"
end
