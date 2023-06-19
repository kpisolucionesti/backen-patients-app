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

ActiveRecord::Schema[7.0].define(version: 2023_06_18_201821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "diagnostics", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "doctor_id"
    t.string "diagnostic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_diagnostics_on_doctor_id"
    t.index ["patient_id"], name: "index_diagnostics_on_patient_id"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "name"
    t.string "speciality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctors_patients", id: false, force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.index ["doctor_id", "patient_id"], name: "index_doctors_patients_on_doctor_id_and_patient_id"
    t.index ["patient_id", "doctor_id"], name: "index_doctors_patients_on_patient_id_and_doctor_id"
  end

  create_table "emergencies", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "doctor_id"
    t.string "ingress_date"
    t.integer "status"
    t.string "medical_exit"
    t.string "diagnostic"
    t.string "treatment"
    t.index ["doctor_id"], name: "index_emergencies_on_doctor_id"
    t.index ["patient_id"], name: "index_emergencies_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "ci"
    t.string "name"
    t.integer "age"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "medical_exit"
    t.string "ingress_date"
    t.integer "status"
    t.string "current_diagnostic"
    t.string "treatment"
    t.string "current_doctor"
    t.string "observations"
    t.string "transfer"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_type"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "patient_id"
  end

  create_table "treatments", force: :cascade do |t|
    t.string "name"
    t.bigint "diagnostic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnostic_id"], name: "index_treatments_on_diagnostic_id"
  end

end
