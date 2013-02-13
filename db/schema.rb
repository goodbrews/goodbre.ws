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

ActiveRecord::Schema.define(version: 20130210205639) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "breweries", id: false, force: true do |t|
    t.string   "id",          limit: 10, null: false
    t.string   "name"
    t.text     "description"
    t.string   "website"
    t.boolean  "organic"
    t.string   "permalink"
    t.string   "image_id",    limit: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "breweries", ["permalink"], name: "index_breweries_on_permalink", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  null: false
    t.string   "username",               null: false
    t.string   "password_digest",        null: false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "region"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
