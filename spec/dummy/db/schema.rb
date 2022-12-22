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

ActiveRecord::Schema[7.0].define(version: 2022_12_22_143123) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_choices", force: :cascade do |t|
    t.boolean "rejected", default: false, null: false
    t.bigint "course_option_id", null: false
    t.bigint "application_form_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_form_id"], name: "index_application_choices_on_application_form_id"
    t.index ["course_option_id"], name: "index_application_choices_on_course_option_id"
  end

  create_table "application_forms", force: :cascade do |t|
    t.string "first_name"
    t.boolean "submitted", default: false, null: false
    t.bigint "candidate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_application_forms_on_candidate_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_options", force: :cascade do |t|
    t.boolean "part_time", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
