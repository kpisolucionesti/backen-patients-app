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

ActiveRecord::Schema[7.0].define(version: 2026_10_01_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_policies", force: :cascade do |t|
    t.boolean "require_2fa", default: false
    t.boolean "ip_restriction_enabled", default: false
    t.text "allowed_ips"
    t.text "blocked_ips"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "allergen_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allergens", force: :cascade do |t|
    t.string "name", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "anesthesia_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "appointment_displays", force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.bigint "specialty_id"
    t.boolean "is_active", default: true, null: false
    t.string "public_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_id"], name: "index_appointment_displays_on_public_id", unique: true
    t.index ["specialty_id"], name: "index_appointment_displays_on_specialty_id"
  end

  create_table "appointment_records", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.text "reason_for_consultation"
    t.text "current_illness"
    t.text "diagnostic"
    t.text "treatment"
    t.text "observations"
    t.jsonb "vital_signs"
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_appointment_records_on_appointment_id", unique: true
    t.index ["created_by_id"], name: "index_appointment_records_on_created_by_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "doctor_id", null: false
    t.bigint "specialty_id", null: false
    t.date "appointment_date", null: false
    t.time "start_time"
    t.time "end_time"
    t.string "status", default: "scheduled", null: false
    t.integer "turn_number"
    t.text "notes"
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_date", "status"], name: "index_appointments_on_appointment_date_and_status"
    t.index ["created_by_id"], name: "index_appointments_on_created_by_id"
    t.index ["doctor_id", "appointment_date"], name: "index_appointments_on_doctor_id_and_appointment_date"
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["specialty_id"], name: "index_appointments_on_specialty_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name", null: false
    t.string "room_type"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_areas_on_name", unique: true
  end

  create_table "backup_configurations", force: :cascade do |t|
    t.string "provider", default: "local"
    t.string "destination_path"
    t.string "access_key_id"
    t.string "secret_access_key"
    t.string "region"
    t.string "cron_schedule", default: "0 2 * * *"
    t.integer "retention_days", default: 30
    t.boolean "include_uploads", default: true
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "birth_records", force: :cascade do |t|
    t.bigint "mother_patient_id", null: false
    t.bigint "baby_patient_id", null: false
    t.bigint "mother_emergency_id", null: false
    t.bigint "baby_emergency_id", null: false
    t.datetime "birth_date", null: false
    t.string "birth_type", null: false
    t.integer "gestational_age_weeks"
    t.decimal "birth_weight_grams", precision: 10, scale: 2
    t.integer "apgar_1min"
    t.integer "apgar_5min"
    t.integer "birth_order", default: 1
    t.text "complications"
    t.text "observations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "doctor_id"
    t.index ["baby_emergency_id"], name: "index_birth_records_on_baby_emergency_id"
    t.index ["baby_patient_id"], name: "index_birth_records_on_baby_patient_id"
    t.index ["birth_order"], name: "index_birth_records_on_birth_order"
    t.index ["doctor_id"], name: "index_birth_records_on_doctor_id"
    t.index ["mother_emergency_id"], name: "index_birth_records_on_mother_emergency_id"
    t.index ["mother_patient_id"], name: "index_birth_records_on_mother_patient_id"
  end

  create_table "clinical_study_classifications", force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.string "color"
    t.integer "sort_order", default: 0
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_clinical_study_classifications_on_key", unique: true
  end

  create_table "company_settings", force: :cascade do |t|
    t.string "company_name", default: "Emerboard", null: false
    t.string "rif"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "country", default: "VE"
    t.string "phone"
    t.string "email"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diagnoses", force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discharge_types", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "requires_cause_of_death", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctor_schedules", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.integer "day_of_week", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.integer "appointment_duration", default: 30, null: false
    t.string "appointment_mode", default: "scheduled", null: false
    t.integer "max_patients", default: 0
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id", "day_of_week"], name: "idx_doctor_schedules_on_doctor_and_day"
    t.index ["doctor_id"], name: "index_doctor_schedules_on_doctor_id"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.string "email"
    t.string "phone"
    t.bigint "specialty_id"
    t.string "ci"
    t.string "doctor_code"
    t.string "sanidad_number"
    t.index ["specialty_id"], name: "index_doctors_on_specialty_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "attachable_type", null: false
    t.bigint "attachable_id", null: false
    t.string "description"
    t.string "file_type"
    t.bigint "uploaded_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "report_type"
    t.jsonb "metadata", default: {}
    t.string "order_number"
    t.bigint "study_classification_id"
    t.string "study_type"
    t.text "observations"
    t.string "status", default: "requested"
    t.index ["attachable_type", "attachable_id"], name: "idx_documents_on_attachable"
    t.index ["order_number"], name: "index_documents_on_order_number", unique: true
    t.index ["status"], name: "index_documents_on_status"
    t.index ["study_classification_id"], name: "index_documents_on_study_classification_id"
    t.index ["uploaded_by_id"], name: "index_documents_on_uploaded_by_id"
  end

  create_table "dynamic_settings", force: :cascade do |t|
    t.bigint "company_id"
    t.string "category", default: "general", null: false
    t.jsonb "settings_data", default: {}, null: false
    t.jsonb "schema_definition", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_dynamic_settings_on_category"
    t.index ["company_id", "category"], name: "idx_dynamic_settings_company_category", unique: true
    t.index ["company_id"], name: "index_dynamic_settings_on_company_id"
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
    t.string "final_diagnostic", limit: 2000
    t.text "reason_for_consultation"
    t.text "current_illness"
    t.text "discharge_note"
    t.text "admission_note"
    t.index ["created_at"], name: "index_emergencies_on_created_at"
    t.index ["created_by_id"], name: "index_emergencies_on_created_by_id"
    t.index ["egress_at"], name: "index_emergencies_on_egress_at"
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

  create_table "emergency_modes", force: :cascade do |t|
    t.boolean "system_blocked", default: false
    t.text "block_message", default: "Sistema en mantenimiento. Intente más tarde."
    t.datetime "blocked_at"
    t.bigint "blocked_by_id"
    t.datetime "scheduled_unblock_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evaluations", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.bigint "doctor_id", null: false
    t.text "diagnostic_impression"
    t.text "plan"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "suggestions"
    t.text "current_illness"
    t.index ["created_by_id"], name: "index_evaluations_on_created_by_id"
    t.index ["doctor_id"], name: "index_evaluations_on_doctor_id"
    t.index ["emergency_id", "doctor_id"], name: "index_evaluations_on_emergency_id_and_doctor_id"
    t.index ["emergency_id"], name: "index_evaluations_on_emergency_id"
  end

  create_table "fluid_balances", force: :cascade do |t|
    t.bigint "hospitalization_id", null: false
    t.bigint "recorded_by_id"
    t.string "balance_type", null: false
    t.string "fluid_type", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.string "unit", default: "ml"
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hospitalization_id"], name: "index_fluid_balances_on_hospitalization_id"
    t.index ["recorded_at"], name: "index_fluid_balances_on_recorded_at"
    t.index ["recorded_by_id"], name: "index_fluid_balances_on_recorded_by_id"
  end

  create_table "general_settings", force: :cascade do |t|
    t.string "timezone", default: "America/Caracas"
    t.string "date_format", default: "dd/MM/yyyy"
    t.string "time_format", default: "HH:mm"
    t.string "locale", default: "es"
    t.boolean "notifications_enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hospitalization_notes", force: :cascade do |t|
    t.bigint "hospitalization_id", null: false
    t.bigint "created_by_id"
    t.string "note_type", default: "progress", null: false
    t.string "shift"
    t.text "subjective"
    t.text "objective"
    t.text "assessment"
    t.text "plan"
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_hospitalization_notes_on_created_by_id"
    t.index ["hospitalization_id"], name: "index_hospitalization_notes_on_hospitalization_id"
    t.index ["note_type"], name: "index_hospitalization_notes_on_note_type"
    t.index ["recorded_at"], name: "index_hospitalization_notes_on_recorded_at"
  end

  create_table "hospitalizations", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.bigint "room_id"
    t.bigint "admitting_doctor_id"
    t.bigint "attending_doctor_id"
    t.text "admission_diagnosis"
    t.text "discharge_diagnosis"
    t.text "discharge_summary"
    t.datetime "admission_date", null: false
    t.datetime "discharge_date"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "current_diagnosis"
    t.text "final_diagnosis"
    t.index ["admitting_doctor_id"], name: "index_hospitalizations_on_admitting_doctor_id"
    t.index ["attending_doctor_id"], name: "index_hospitalizations_on_attending_doctor_id"
    t.index ["emergency_id", "status"], name: "index_hospitalizations_on_emergency_id_and_status", unique: true, where: "((status)::text = 'active'::text)"
    t.index ["emergency_id"], name: "index_hospitalizations_on_emergency_id"
    t.index ["room_id"], name: "index_hospitalizations_on_room_id"
    t.index ["status"], name: "index_hospitalizations_on_status"
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
    t.boolean "is_active", default: true, null: false
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
    t.bigint "clinical_study_classification_id"
    t.boolean "is_active", default: true, null: false
    t.index ["clinical_study_classification_id"], name: "index_lab_parameters_on_clinical_study_classification_id"
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

  create_table "medication_administrations", force: :cascade do |t|
    t.bigint "hospitalization_id"
    t.bigint "medical_plan_id"
    t.bigint "administered_by_id"
    t.string "medication_name", null: false
    t.string "dosage"
    t.string "route"
    t.string "frequency"
    t.datetime "scheduled_at"
    t.datetime "administered_at"
    t.string "status", default: "scheduled"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "emergency_id"
    t.index ["administered_by_id"], name: "index_medication_administrations_on_administered_by_id"
    t.index ["emergency_id"], name: "index_medication_administrations_on_emergency_id"
    t.index ["hospitalization_id"], name: "index_medication_administrations_on_hospitalization_id"
    t.index ["medical_plan_id"], name: "index_medication_administrations_on_medical_plan_id"
    t.index ["scheduled_at"], name: "index_medication_administrations_on_scheduled_at"
    t.index ["status"], name: "index_medication_administrations_on_status"
  end

  create_table "medication_concentrations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_presentations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_routes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medications", force: :cascade do |t|
    t.string "name", null: false
    t.string "generic_name"
    t.string "presentation"
    t.string "concentration"
    t.string "medication_route"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.integer "patient_id"
    t.bigint "created_by_id"
    t.bigint "emergency_id"
    t.string "note_type", default: "general"
    t.index ["created_by_id"], name: "index_notes_on_created_by_id"
    t.index ["emergency_id"], name: "index_notes_on_emergency_id"
    t.index ["note_type"], name: "index_notes_on_note_type"
    t.index ["patient_id"], name: "index_notes_on_patient_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "notification_type", null: false
    t.string "title", null: false
    t.text "message"
    t.string "link"
    t.bigint "emergency_id"
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_notifications_on_created_at"
    t.index ["read"], name: "index_notifications_on_read"
  end

  create_table "paraclinical_studies", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.string "study_type", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emergency_id"], name: "index_paraclinical_studies_on_emergency_id"
  end

  create_table "password_policies", force: :cascade do |t|
    t.integer "min_length", default: 8
    t.boolean "require_uppercase", default: true
    t.boolean "require_lowercase", default: true
    t.boolean "require_number", default: true
    t.boolean "require_special_char", default: true
    t.integer "expiry_days", default: 0
    t.integer "max_failed_attempts", default: 5
    t.integer "lockout_duration_minutes", default: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "patient_family_antecedents", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "patologia", null: false
    t.string "parentesco"
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_patient_family_antecedents_on_patient_id"
  end

  create_table "patient_gynecological_histories", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "evento", null: false
    t.date "fecha_ultimo_evento"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_patient_gynecological_histories_on_patient_id"
  end

  create_table "patient_lifestyle_habits", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "habito", null: false
    t.string "concurrencia"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_patient_lifestyle_habits_on_patient_id"
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
    t.string "medical_history_number", null: false
    t.bigint "mother_id"
    t.string "patient_category", default: "adulto", null: false
    t.index ["ci"], name: "index_patients_on_ci", unique: true
    t.index ["created_by_id"], name: "index_patients_on_created_by_id"
    t.index ["lastname"], name: "index_patients_on_lastname"
    t.index ["medical_history_number"], name: "index_patients_on_medical_history_number", unique: true
    t.index ["mother_id"], name: "index_patients_on_mother_id"
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
    t.bigint "doctor_id"
    t.index ["doctor_id"], name: "index_physical_exams_on_doctor_id"
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

  create_table "recipes", force: :cascade do |t|
    t.bigint "emergency_id", null: false
    t.bigint "doctor_id", null: false
    t.string "medication", null: false
    t.string "dosage"
    t.string "frequency"
    t.string "duration"
    t.string "route"
    t.text "indications"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_recipes_on_doctor_id"
    t.index ["emergency_id"], name: "index_recipes_on_emergency_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "patient_id"
    t.bigint "area_id", null: false
    t.index ["area_id"], name: "index_rooms_on_area_id"
  end

  create_table "session_settings", force: :cascade do |t|
    t.integer "idle_timeout_minutes", default: 15
    t.boolean "allow_concurrent_sessions", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specialties", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_specialties_on_name", unique: true
  end

  create_table "storage_configurations", force: :cascade do |t|
    t.string "provider", default: "local"
    t.string "endpoint"
    t.string "region"
    t.string "bucket"
    t.string "access_key_id"
    t.string "secret_access_key"
    t.string "local_path", default: "./storage"
    t.integer "max_file_size_mb", default: 10
    t.boolean "use_ssl", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surgeries", force: :cascade do |t|
    t.bigint "hospitalization_id"
    t.string "surgery_type"
    t.text "description"
    t.string "surgeon_name"
    t.datetime "surgery_date"
    t.string "status", default: "scheduled"
    t.text "preop_notes"
    t.text "postop_notes"
    t.text "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "preanesthetic_evaluation"
    t.bigint "area_id"
    t.bigint "patient_id"
    t.datetime "scheduled_start_time"
    t.datetime "scheduled_end_time"
    t.string "anesthesiologist"
    t.string "anesthesia_type"
    t.datetime "actual_start_time"
    t.datetime "actual_end_time"
    t.boolean "ambulatory", default: false
    t.text "cancellation_reason"
    t.index ["area_id"], name: "index_surgeries_on_area_id"
    t.index ["hospitalization_id"], name: "index_surgeries_on_hospitalization_id"
    t.index ["patient_id"], name: "index_surgeries_on_patient_id"
  end

  create_table "surgery_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surgery_procedures", force: :cascade do |t|
    t.string "code"
    t.string "name", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surgery_team_members", force: :cascade do |t|
    t.bigint "surgery_id", null: false
    t.bigint "doctor_id", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_surgery_team_members_on_doctor_id"
    t.index ["surgery_id", "doctor_id", "role"], name: "idx_surgery_team_members_unique", unique: true
    t.index ["surgery_id"], name: "index_surgery_team_members_on_surgery_id"
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
    t.string "ip_address"
    t.string "user_agent"
    t.jsonb "metadata", default: {}
    t.index ["created_at"], name: "index_user_activity_logs_on_created_at"
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
    t.bigint "doctor_id"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.integer "lock_count", default: 0, null: false
    t.datetime "blocked_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["doctor_id"], name: "index_users_on_doctor_id"
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
    t.decimal "glucose", precision: 6, scale: 2
    t.decimal "height", precision: 5, scale: 1
    t.decimal "weight", precision: 5, scale: 1
    t.decimal "bmi", precision: 4, scale: 1
    t.index ["emergency_id"], name: "index_vital_signs_on_emergency_id"
    t.index ["recorded_by_id"], name: "index_vital_signs_on_recorded_by_id"
  end

  create_table "vital_signs_ranges", force: :cascade do |t|
    t.string "parameter", null: false
    t.string "sex"
    t.integer "age_min"
    t.integer "age_max"
    t.decimal "min_normal", precision: 10, scale: 2
    t.decimal "max_normal", precision: 10, scale: 2
    t.decimal "min_alert", precision: 10, scale: 2
    t.decimal "max_alert", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointment_displays", "specialties"
  add_foreign_key "appointment_records", "appointments"
  add_foreign_key "appointment_records", "users", column: "created_by_id"
  add_foreign_key "appointments", "doctors"
  add_foreign_key "appointments", "patients"
  add_foreign_key "appointments", "specialties"
  add_foreign_key "appointments", "users", column: "created_by_id"
  add_foreign_key "birth_records", "doctors"
  add_foreign_key "birth_records", "emergencies", column: "baby_emergency_id"
  add_foreign_key "birth_records", "emergencies", column: "mother_emergency_id"
  add_foreign_key "birth_records", "patients", column: "baby_patient_id"
  add_foreign_key "birth_records", "patients", column: "mother_patient_id"
  add_foreign_key "doctor_schedules", "doctors"
  add_foreign_key "doctors", "specialties"
  add_foreign_key "documents", "clinical_study_classifications", column: "study_classification_id"
  add_foreign_key "documents", "users", column: "uploaded_by_id"
  add_foreign_key "emergencies", "patients"
  add_foreign_key "emergencies", "users", column: "created_by_id"
  add_foreign_key "emergency_doctors", "doctors"
  add_foreign_key "emergency_doctors", "emergencies"
  add_foreign_key "evaluations", "doctors"
  add_foreign_key "evaluations", "emergencies"
  add_foreign_key "evaluations", "users", column: "created_by_id"
  add_foreign_key "fluid_balances", "hospitalizations"
  add_foreign_key "fluid_balances", "users", column: "recorded_by_id"
  add_foreign_key "hospitalization_notes", "hospitalizations"
  add_foreign_key "hospitalization_notes", "users", column: "created_by_id"
  add_foreign_key "hospitalizations", "doctors", column: "admitting_doctor_id"
  add_foreign_key "hospitalizations", "doctors", column: "attending_doctor_id"
  add_foreign_key "hospitalizations", "emergencies"
  add_foreign_key "hospitalizations", "rooms"
  add_foreign_key "interconsultations", "doctors", column: "doctor_requested_id"
  add_foreign_key "interconsultations", "emergencies"
  add_foreign_key "interconsultations", "users", column: "requested_by_id"
  add_foreign_key "lab_parameters", "clinical_study_classifications"
  add_foreign_key "lab_parameters", "lab_parameter_groups"
  add_foreign_key "lab_result_values", "laboratory_results"
  add_foreign_key "laboratory_results", "emergencies"
  add_foreign_key "medical_plans", "doctors"
  add_foreign_key "medical_plans", "emergencies"
  add_foreign_key "medical_plans", "users", column: "created_by_id"
  add_foreign_key "medication_administrations", "emergencies"
  add_foreign_key "medication_administrations", "hospitalizations"
  add_foreign_key "medication_administrations", "medical_plans"
  add_foreign_key "medication_administrations", "users", column: "administered_by_id"
  add_foreign_key "notes", "emergencies"
  add_foreign_key "notes", "users", column: "created_by_id"
  add_foreign_key "paraclinical_studies", "emergencies"
  add_foreign_key "patient_allergies", "patients"
  add_foreign_key "patient_antecedents", "patients"
  add_foreign_key "patient_family_antecedents", "patients"
  add_foreign_key "patient_gynecological_histories", "patients"
  add_foreign_key "patient_lifestyle_habits", "patients"
  add_foreign_key "patients", "patients", column: "mother_id"
  add_foreign_key "patients", "users", column: "created_by_id"
  add_foreign_key "physical_exams", "doctors"
  add_foreign_key "physical_exams", "emergencies"
  add_foreign_key "recipes", "doctors"
  add_foreign_key "recipes", "emergencies"
  add_foreign_key "rooms", "areas"
  add_foreign_key "surgeries", "hospitalizations"
  add_foreign_key "surgery_team_members", "doctors"
  add_foreign_key "surgery_team_members", "surgeries"
  add_foreign_key "tv_screen_events", "tv_screens"
  add_foreign_key "tv_screen_sessions", "tv_screens"
  add_foreign_key "user_activity_logs", "users"
  add_foreign_key "users", "doctors"
  add_foreign_key "users", "profiles"
  add_foreign_key "vital_signs", "emergencies"
  add_foreign_key "vital_signs", "users", column: "recorded_by_id"
end
