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

ActiveRecord::Schema.define(version: 20150618075202) do

  create_table "alert_groups", force: :cascade do |t|
    t.integer  "alert_id",   limit: 4
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "alert_groups", ["alert_id"], name: "index_alert_groups_on_alert_id", using: :btree
  add_index "alert_groups", ["group_id"], name: "index_alert_groups_on_group_id", using: :btree

  create_table "alert_keywords", force: :cascade do |t|
    t.integer  "alert_id",   limit: 4
    t.integer  "keyword_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "alert_keywords", ["alert_id"], name: "index_alert_keywords_on_alert_id", using: :btree
  add_index "alert_keywords", ["keyword_id"], name: "index_alert_keywords_on_keyword_id", using: :btree

  create_table "alert_places", force: :cascade do |t|
    t.integer  "alert_id",   limit: 4
    t.integer  "place_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "alert_places", ["alert_id"], name: "index_alert_places_on_alert_id", using: :btree
  add_index "alert_places", ["place_id"], name: "index_alert_places_on_place_id", using: :btree

  create_table "alerts", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "url",                  limit: 255
    t.float    "interval",             limit: 24
    t.string   "interval_unit",        limit: 255
    t.text     "email_template",       limit: 65535
    t.text     "sms_template",         limit: 65535
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "alert_places_count",   limit: 4,     default: 0
    t.integer  "alert_groups_count",   limit: 4,     default: 0
    t.integer  "alert_keywords_count", limit: 4,     default: 0
    t.string   "from_time",            limit: 255
    t.string   "to_time",              limit: 255
    t.integer  "project_id",           limit: 4
  end

  add_index "alerts", ["project_id"], name: "index_alerts_on_project_id", using: :btree

  create_table "channel_permissions", force: :cascade do |t|
    t.integer  "channel_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "role",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "channel_permissions", ["channel_id"], name: "index_channel_permissions_on_channel_id", using: :btree
  add_index "channel_permissions", ["user_id"], name: "index_channel_permissions_on_user_id", using: :btree

  create_table "channels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.string   "password",   limit: 255
    t.string   "setup_flow", limit: 255
    t.boolean  "is_enable",  limit: 1,   default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "channels", ["user_id"], name: "index_channels_on_user_id", using: :btree

  create_table "feed_entries", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.string   "url",          limit: 255
    t.datetime "published_at"
    t.text     "summary",      limit: 65535
    t.text     "content",      limit: 4294967295
    t.boolean  "alerted",      limit: 1,          default: false
    t.string   "fingerprint",  limit: 255
    t.integer  "alert_id",     limit: 4
    t.integer  "feed_id",      limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.text     "keywords",     limit: 65535
    t.boolean  "matched",      limit: 1,          default: false
  end

  add_index "feed_entries", ["alert_id"], name: "index_feed_entries_on_alert_id", using: :btree
  add_index "feed_entries", ["feed_id"], name: "index_feed_entries_on_feed_id", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.string   "url",                limit: 255
    t.string   "title",              limit: 255
    t.text     "description",        limit: 65535
    t.integer  "alert_id",           limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "feed_entries_count", limit: 4,     default: 0
  end

  add_index "feeds", ["alert_id"], name: "index_feeds_on_alert_id", using: :btree

  create_table "group_permissions", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "group_id",     limit: 4
    t.integer  "alert_id",     limit: 4
    t.integer  "project_id",   limit: 4
    t.string   "role",         limit: 255
    t.integer  "order_number", limit: 4,   default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "group_permissions", ["alert_id"], name: "index_group_permissions_on_alert_id", using: :btree
  add_index "group_permissions", ["group_id"], name: "index_group_permissions_on_group_id", using: :btree
  add_index "group_permissions", ["project_id"], name: "index_group_permissions_on_project_id", using: :btree
  add_index "group_permissions", ["user_id"], name: "index_group_permissions_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",     limit: 4
  end

  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "keywords", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "full_name",   limit: 255
    t.string   "email",       limit: 255
    t.string   "phone",       limit: 255
    t.boolean  "email_alert", limit: 1
    t.boolean  "sms_alert",   limit: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
  end

  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "member_id",  limit: 4
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["member_id", "group_id"], name: "index_memberships_on_member_id_and_group_id", unique: true, using: :btree
  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "project_permissions", force: :cascade do |t|
    t.string   "role",       limit: 255
    t.integer  "project_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "project_permissions", ["project_id"], name: "index_project_permissions_on_project_id", using: :btree
  add_index "project_permissions", ["user_id"], name: "index_project_permissions_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "user_projects", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.boolean  "owner",      limit: 1, default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "user_projects", ["project_id"], name: "index_user_projects_on_project_id", using: :btree
  add_index "user_projects", ["user_id"], name: "index_user_projects_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255
    t.string   "phone",                limit: 255
    t.string   "password_digest",      limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "role",                 limit: 255
    t.boolean  "email_alert",          limit: 1,   default: false
    t.boolean  "sms_alert",            limit: 1,   default: false
    t.string   "full_name",            limit: 255
    t.string   "auth_token",           limit: 255
    t.string   "confirmed_token",      limit: 255
    t.datetime "confirmed_at"
    t.string   "reset_password_token", limit: 255
    t.datetime "reset_password_at"
    t.integer  "channels_count",       limit: 4,   default: 0
  end

  add_foreign_key "alert_groups", "alerts"
  add_foreign_key "alert_groups", "groups"
  add_foreign_key "alert_keywords", "alerts"
  add_foreign_key "alert_keywords", "keywords"
  add_foreign_key "alert_places", "alerts"
  add_foreign_key "alert_places", "places"
  add_foreign_key "alerts", "projects"
  add_foreign_key "channel_permissions", "channels"
  add_foreign_key "channel_permissions", "users"
  add_foreign_key "channels", "users"
  add_foreign_key "feed_entries", "alerts"
  add_foreign_key "feed_entries", "feeds"
  add_foreign_key "feeds", "alerts"
  add_foreign_key "group_permissions", "alerts"
  add_foreign_key "group_permissions", "groups"
  add_foreign_key "group_permissions", "projects"
  add_foreign_key "group_permissions", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "members", "users"
  add_foreign_key "project_permissions", "projects"
  add_foreign_key "project_permissions", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "user_projects", "projects"
  add_foreign_key "user_projects", "users"
end
