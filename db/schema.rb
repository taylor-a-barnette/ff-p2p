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

ActiveRecord::Schema.define(version: 20151214200506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: true do |t|
    t.integer  "user_id",    null: false
    t.text     "title",      null: false
    t.text     "body",       null: false
    t.text     "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_image_galleries", force: true do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: true do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: true do |t|
    t.integer  "user_id",     null: false
    t.text     "fingerprint", null: false
    t.text     "card_id",     null: false
    t.string   "last4",       null: false
    t.string   "brand",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fundables", force: true do |t|
    t.integer  "user_id",          null: false
    t.string   "state"
    t.text     "title",            null: false
    t.text     "about",            null: false
    t.text     "summary",          null: false
    t.text     "risks_challenges", null: false
    t.integer  "duration",         null: false
    t.integer  "funding_goal",     null: false
    t.text     "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "user_id",            null: false
    t.integer  "pledge_id"
    t.text     "paymentable_type",   null: false
    t.integer  "paymentable_id",     null: false
    t.text     "status"
    t.text     "state"
    t.text     "email",              null: false
    t.integer  "amount",             null: false
    t.text     "stripe_customer_id", null: false
    t.text     "chard_id",           null: false
    t.string   "guid",               null: false
    t.string   "currency",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pledges", force: true do |t|
    t.integer  "user_id",            null: false
    t.text     "pledgable_type",     null: false
    t.integer  "pledgable_id",       null: false
    t.text     "stripe_customer_id", null: false
    t.string   "guid",               null: false
    t.integer  "amount",             null: false
    t.string   "currency",           null: false
    t.text     "card_fingerprint",   null: false
    t.text     "card_id",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stripe_accounts", force: true do |t|
    t.integer  "user_id",                null: false
    t.text     "guid",                   null: false
    t.text     "stripe_id",              null: false
    t.text     "stripe_access_key",      null: false
    t.text     "stripe_publishable_key", null: false
    t.text     "stripe_refresh_token",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stripe_webhooks", force: true do |t|
    t.text     "charge_id"
    t.text     "webhook_event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
