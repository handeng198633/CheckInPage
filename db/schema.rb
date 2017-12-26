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

ActiveRecord::Schema.define(version: 20171226065408) do

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.string "statux"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "login_id"
    t.string "realname"
    t.string "product_line", default: "RH"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "window_requests", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "version"
    t.text "comment"
    t.string "status"
    t.datetime "window_start"
    t.datetime "window_end"
    t.integer "lasting_hour"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_range"
    t.string "bugid", default: "NULL"
    t.text "filetext", default: "NULL"
    t.string "textdone", default: "NULL"
    t.string "Group_qa_coverage", default: "NULL"
    t.text "justification_back_porting", default: "NULL"
    t.text "change_summary", default: "NULL"
    t.text "impact_to_db", default: "NULL"
    t.text "history", default: "NULL"
    t.string "ae_contact", default: "NULL"
    t.string "product_category", default: "NULL"
    t.string "mail_cc_list"
    t.string "send_copy_ornot", default: "no"
    t.string "reason", default: "NULL"
    t.text "reason_not_rd"
    t.text "rd_impact_to_db"
  end

end
