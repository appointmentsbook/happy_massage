# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150814140000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "massages", force: :cascade do |t|
    t.datetime "timetable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "masseur_id"
  end

  add_index "massages", ["masseur_id"], name: "index_massages_on_masseur_id", using: :btree
  add_index "massages", ["timetable", "masseur_id"], name: "index_massages_on_timetable_and_masseur_id", unique: true, using: :btree
  add_index "massages", ["user_id"], name: "index_massages_on_timetable_date_and_user_id", unique: true, using: :btree
  add_index "massages", ["user_id"], name: "index_massages_on_user_id", using: :btree

  create_table "masseurs", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "status"
  end

  create_table "penalties", force: :cascade do |t|
    t.datetime "punished_at"
    t.datetime "punished_until"
    t.string   "reported_by"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "sector"
    t.string   "massage_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "schedule_status"
  end

  add_foreign_key "massages", "masseurs"
  add_foreign_key "massages", "users"
end
