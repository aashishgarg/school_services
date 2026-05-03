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

ActiveRecord::Schema[8.0].define(version: 2026_05_03_140015) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "academic_years", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.string "name", null: false
    t.date "starts_on", null: false
    t.date "ends_on", null: false
    t.boolean "current", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id", "name"], name: "index_academic_years_on_school_id_and_name", unique: true
    t.index ["school_id"], name: "index_academic_years_on_school_id"
  end

  create_table "attendance_records", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "attendance_session_id", null: false
    t.bigint "student_id", null: false
    t.integer "status", default: 0, null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_session_id", "student_id"], name: "index_attendance_records_on_session_student", unique: true
    t.index ["attendance_session_id"], name: "index_attendance_records_on_attendance_session_id"
    t.index ["school_id"], name: "index_attendance_records_on_school_id"
    t.index ["student_id"], name: "index_attendance_records_on_student_id"
  end

  create_table "attendance_sessions", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "section_id", null: false
    t.date "on_date", null: false
    t.integer "half", default: 0, null: false
    t.bigint "taken_by_id"
    t.datetime "taken_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_attendance_sessions_on_school_id"
    t.index ["section_id", "on_date", "half"], name: "index_attendance_sessions_on_section_date_half", unique: true
    t.index ["section_id"], name: "index_attendance_sessions_on_section_id"
    t.index ["taken_by_id"], name: "index_attendance_sessions_on_taken_by_id"
  end

  create_table "audits", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "user_id"
    t.string "action", null: false
    t.string "auditable_type", null: false
    t.bigint "auditable_id", null: false
    t.jsonb "changes_payload", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditable_type", "auditable_id"], name: "index_audits_on_auditable_type_and_auditable_id"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["school_id"], name: "index_audits_on_school_id"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "bus_stop_progresses", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "bus_trip_id", null: false
    t.bigint "bus_stop_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "recorded_at"
    t.bigint "recorded_by_id"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_stop_id"], name: "index_bus_stop_progresses_on_bus_stop_id"
    t.index ["bus_trip_id", "bus_stop_id"], name: "index_bus_stop_progresses_on_trip_stop", unique: true
    t.index ["bus_trip_id"], name: "index_bus_stop_progresses_on_bus_trip_id"
    t.index ["recorded_by_id"], name: "index_bus_stop_progresses_on_recorded_by_id"
    t.index ["school_id"], name: "index_bus_stop_progresses_on_school_id"
  end

  create_table "bus_stops", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "bus_id", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.time "expected_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_id", "position"], name: "index_bus_stops_on_bus_id_and_position", unique: true
    t.index ["bus_id"], name: "index_bus_stops_on_bus_id"
    t.index ["school_id"], name: "index_bus_stops_on_school_id"
  end

  create_table "bus_trips", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "bus_id", null: false
    t.date "on_date", null: false
    t.integer "shift", default: 0, null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_id", "on_date", "shift"], name: "index_bus_trips_on_bus_date_shift", unique: true
    t.index ["bus_id"], name: "index_bus_trips_on_bus_id"
    t.index ["school_id"], name: "index_bus_trips_on_school_id"
  end

  create_table "buses", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.string "name", null: false
    t.string "plate_no", null: false
    t.integer "capacity"
    t.bigint "in_charge_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["in_charge_user_id"], name: "index_buses_on_in_charge_user_id"
    t.index ["school_id", "plate_no"], name: "index_buses_on_school_id_and_plate_no", unique: true
    t.index ["school_id"], name: "index_buses_on_school_id"
  end

  create_table "school_classes", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id", "name"], name: "index_school_classes_on_school_id_and_name", unique: true
    t.index ["school_id"], name: "index_school_classes_on_school_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "time_zone", default: "UTC", null: false
    t.jsonb "settings", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_schools_on_slug", unique: true
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "school_class_id", null: false
    t.bigint "academic_year_id", null: false
    t.string "name", null: false
    t.bigint "class_teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["academic_year_id"], name: "index_sections_on_academic_year_id"
    t.index ["class_teacher_id"], name: "index_sections_on_class_teacher_id"
    t.index ["school_class_id", "academic_year_id", "name"], name: "index_sections_on_class_year_name", unique: true
    t.index ["school_class_id"], name: "index_sections_on_school_class_id"
    t.index ["school_id"], name: "index_sections_on_school_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "section_id", null: false
    t.string "admission_no", null: false
    t.string "full_name", null: false
    t.string "gender"
    t.date "dob"
    t.string "guardian_name"
    t.string "guardian_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bus_id"
    t.bigint "bus_stop_id"
    t.index ["bus_id"], name: "index_students_on_bus_id"
    t.index ["bus_stop_id"], name: "index_students_on_bus_stop_id"
    t.index ["school_id", "admission_no"], name: "index_students_on_school_id_and_admission_no", unique: true
    t.index ["school_id"], name: "index_students_on_school_id"
    t.index ["section_id"], name: "index_students_on_section_id"
  end

  create_table "teacher_assignments", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "user_id", null: false
    t.bigint "section_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_teacher_assignments_on_school_id"
    t.index ["section_id"], name: "index_teacher_assignments_on_section_id"
    t.index ["user_id", "section_id", "role"], name: "index_teacher_assignments_on_user_section_role", unique: true
    t.index ["user_id"], name: "index_teacher_assignments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "full_name", null: false
    t.integer "role", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id", "email_address"], name: "index_users_on_school_id_and_email_address", unique: true
    t.index ["school_id"], name: "index_users_on_school_id"
  end

  add_foreign_key "academic_years", "schools"
  add_foreign_key "attendance_records", "attendance_sessions"
  add_foreign_key "attendance_records", "schools"
  add_foreign_key "attendance_records", "students"
  add_foreign_key "attendance_sessions", "schools"
  add_foreign_key "attendance_sessions", "sections"
  add_foreign_key "attendance_sessions", "users", column: "taken_by_id"
  add_foreign_key "audits", "schools"
  add_foreign_key "audits", "users"
  add_foreign_key "bus_stop_progresses", "bus_stops"
  add_foreign_key "bus_stop_progresses", "bus_trips"
  add_foreign_key "bus_stop_progresses", "schools"
  add_foreign_key "bus_stop_progresses", "users", column: "recorded_by_id"
  add_foreign_key "bus_stops", "buses"
  add_foreign_key "bus_stops", "schools"
  add_foreign_key "bus_trips", "buses"
  add_foreign_key "bus_trips", "schools"
  add_foreign_key "buses", "schools"
  add_foreign_key "buses", "users", column: "in_charge_user_id"
  add_foreign_key "school_classes", "schools"
  add_foreign_key "sections", "academic_years"
  add_foreign_key "sections", "school_classes"
  add_foreign_key "sections", "schools"
  add_foreign_key "sections", "users", column: "class_teacher_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "students", "bus_stops"
  add_foreign_key "students", "buses"
  add_foreign_key "students", "schools"
  add_foreign_key "students", "sections"
  add_foreign_key "teacher_assignments", "schools"
  add_foreign_key "teacher_assignments", "sections"
  add_foreign_key "teacher_assignments", "users"
  add_foreign_key "users", "schools"
end
