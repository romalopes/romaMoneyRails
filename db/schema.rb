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

ActiveRecord::Schema.define(version: 20131119010200) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.decimal  "balance"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["user_id", "created_at"], name: "index_accounts_on_user_id_and_created_at"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "description"
    t.integer  "group_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["group_category_id", "created_at"], name: "index_categories_on_group_category_id_and_created_at"

  create_table "group_categories", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "group_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "account_id"
    t.decimal  "value"
    t.string   "description"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["account_id"], name: "index_transactions_on_account_id"
  add_index "transactions", ["category_id"], name: "index_transactions_on_category_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "current_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
