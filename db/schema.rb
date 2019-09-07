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

ActiveRecord::Schema.define(version: 20150521204003) do

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "hours", force: :cascade do |t|
    t.integer "sunday",      limit: 4
    t.integer "monday",      limit: 4
    t.integer "tuesday",     limit: 4
    t.integer "wednesday",   limit: 4
    t.integer "thursday",    limit: 4
    t.integer "friday",      limit: 4
    t.integer "saturday",    limit: 4
    t.integer "report_id",   limit: 4
    t.integer "category_id", limit: 4
  end

  add_index "hours", ["category_id"], name: "index_hours_on_category_id", using: :btree
  add_index "hours", ["report_id"], name: "index_hours_on_report_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "week_id",          limit: 4
    t.boolean  "signed",           limit: 1, default: false
    t.boolean  "timesheet_locked", limit: 1, default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 4
  end

  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.boolean  "admin",                  limit: 1,   default: false
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "job_title",              limit: 255
    t.integer  "rate",                   limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id",                limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

end
