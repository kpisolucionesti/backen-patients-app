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

ActiveRecord::Schema[7.0].define(version: 2026_07_31_000009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string "name", null: false
    t.string "room_type"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_areas_on_name", unique: true
  end

  create_table "doctors", force: :cascade do |t|
    t.string "name"
    t.string "speciality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.string "email"
    t.string "phone"
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
    t.string "classification"
    t.text "cause_of_death"
    t.text "reason_for_consultation"
    t.text "current_illness"
    t.text "discharge_note"
    t.text "admission_note"
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

  create_table "interconsultations", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.bigint "doctor_requested_id", null: false
    t.bigint "requested_by_id"
    t.text "reason"
    t.text "observations"
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_requested_id"], name: "index_interconsultations_on_doctor_requested_id"
    t.index ["emergency_id"], name: "index_interconsultations_on_emergency_id"
    t.index ["requested_by_id"], name: "index_interconsultations_on_requested_by_id"
    t.index ["status"], name: "index_interconsultations_on_status"
  end

  create_table "lab_parameter_groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lab_parameters", force: :cascade do |t|
    t.bigint "lab_parameter_group_id"
    t.string "name", null: false
    t.string "unit"
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation"
    t.jsonb "reference_ranges", default: {}
    t.index ["lab_parameter_group_id"], name: "index_lab_parameters_on_lab_parameter_group_id"
  end

  create_table "lab_result_values", force: :cascade do |t|
    t.bigint "laboratory_result_id", null: false
    t.string "parameter_name"
    t.string "value"
    t.string "unit"
    t.string "reference_range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["laboratory_result_id"], name: "index_lab_result_values_on_laboratory_result_id"
  end

  create_table "laboratory_results", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.datetime "result_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emergency_id"], name: "index_laboratory_results_on_emergency_id"
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
    t.bigint "emergency_id"
    t.index ["created_by_id"], name: "index_notes_on_created_by_id"
    t.index ["emergency_id"], name: "index_notes_on_emergency_id"
  end

  create_table "paraclinical_studies", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.string "study_type", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emergency_id"], name: "index_paraclinical_studies_on_emergency_id"
  end

  create_table "patient_allergies", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "allergy", null: false
    t.string "severity"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_patient_allergies_on_patient_id"
  end

  create_table "patient_antecedents", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "condition_type", null: false
    t.text "description"
    t.date "diagnosed_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "medication"
    t.string "category"
    t.index ["patient_id"], name: "index_patient_antecedents_on_patient_id"
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
    t.boolean "disabled", default: false
    t.index ["ci"], name: "index_patients_on_ci", unique: true
    t.index ["created_by_id"], name: "index_patients_on_created_by_id"
    t.index ["lastname"], name: "index_patients_on_lastname"
    t.index ["name"], name: "index_patients_on_name"
  end

  create_table "physical_exams", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.text "cabeza"
    t.text "ojo"
    t.text "cuello"
    t.text "orl"
    t.text "torax"
    t.text "cardiovascular"
    t.text "abdomen"
    t.text "genitales"
    t.text "extremidades"
    t.text "neurologico"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emergency_id"], name: "index_physical_exams_on_emergency_id"
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
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "patient_id"
    t.bigint "area_id", null: false
    t.index ["area_id"], name: "index_rooms_on_area_id"
  end

  create_table "tv_screen_events", force: :cascade do |t|
    t.bigint "tv_screen_id", null: false
    t.string "event_type", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tv_screen_id"], name: "index_tv_screen_events_on_tv_screen_id"
  end

  create_table "tv_screen_sessions", force: :cascade do |t|
    t.bigint "tv_screen_id", null: false
    t.string "auth_token", null: false
    t.string "ip_address"
    t.datetime "last_seen_at"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_tv_screen_sessions_on_auth_token", unique: true
    t.index ["tv_screen_id"], name: "index_tv_screen_sessions_on_tv_screen_id"
  end

  create_table "tv_screens", force: :cascade do |t|
    t.string "name", null: false
    t.string "location", null: false
    t.string "pin_digest", null: false
    t.string "public_id", null: false
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "route", null: false
    t.index ["public_id"], name: "index_tv_screens_on_public_id", unique: true
    t.index ["route"], name: "index_tv_screens_on_route", unique: true
  end

  create_table "user_activity_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_activity_logs_on_user_id"
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
    t.datetime "last_activity_at"
    t.boolean "must_change_password", default: true
    t.datetime "last_sign_in_at"
    t.datetime "last_sign_out_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profile_id"], name: "index_users_on_profile_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vital_signs", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.integer "systolic_bp"
    t.integer "diastolic_bp"
    t.integer "heart_rate"
    t.integer "respiratory_rate"
    t.decimal "temperature", precision: 4, scale: 1
    t.integer "oxygen_saturation"
    t.datetime "recorded_at", null: false
    t.bigint "recorded_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emergency_id"], name: "index_vital_signs_on_emergency_id"
    t.index ["recorded_by_id"], name: "index_vital_signs_on_recorded_by_id"
  end

  add_foreign_key "emergencies", "patients"
  add_foreign_key "emergencies", "users", column: "created_by_id"
  add_foreign_key "emergency_doctors", "doctors"
  add_foreign_key "emergency_doctors", "emergencies"
  add_foreign_key "interconsultations", "doctors", column: "doctor_requested_id"
  add_foreign_key "interconsultations", "emergencies"
  add_foreign_key "interconsultations", "users", column: "requested_by_id"
  add_foreign_key "lab_parameters", "lab_parameter_groups"
  add_foreign_key "lab_result_values", "laboratory_results"
  add_foreign_key "laboratory_results", "emergencies"
  add_foreign_key "medical_plans", "doctors"
  add_foreign_key "medical_plans", "emergencies"
  add_foreign_key "medical_plans", "users", column: "created_by_id"
  add_foreign_key "notes", "emergencies"
  add_foreign_key "notes", "users", column: "created_by_id"
  add_foreign_key "paraclinical_studies", "emergencies"
  add_foreign_key "patient_allergies", "patients"
  add_foreign_key "patient_antecedents", "patients"
  add_foreign_key "patients", "users", column: "created_by_id"
  add_foreign_key "physical_exams", "emergencies"
  add_foreign_key "rooms", "areas"
  add_foreign_key "tv_screen_events", "tv_screens"
  add_foreign_key "tv_screen_sessions", "tv_screens"
  add_foreign_key "user_activity_logs", "users"
  add_foreign_key "users", "profiles"
  add_foreign_key "vital_signs", "emergencies"
  add_foreign_key "vital_signs", "users", column: "recorded_by_id"
end
