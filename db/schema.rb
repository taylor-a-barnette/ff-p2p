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

ActiveRecord::Schema.define(version: 20151211192045) do

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

end
