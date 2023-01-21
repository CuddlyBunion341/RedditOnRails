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

ActiveRecord::Schema[7.0].define(version: 2023_01_20_134935) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comment_saves", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "comment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_saves_on_comment_id"
    t.index ["user_id"], name: "index_comment_saves_on_user_id"
  end

  create_table "comment_votes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "comment_id", null: false
    t.boolean "isUpvote", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_votes_on_comment_id"
    t.index ["user_id"], name: "index_comment_votes_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0
    t.integer "parent_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.string "shortname"
    t.text "description"
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_communities_on_owner_id"
  end

  create_table "community_members", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "community_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_members_on_community_id"
    t.index ["user_id"], name: "index_community_members_on_user_id"
  end

  create_table "follower2s", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "follower_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id"], name: "index_follower2s_on_follower_id"
    t.index ["user_id"], name: "index_follower2s_on_user_id"
  end

  create_table "followers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "follower_id", null: false
    t.index ["follower_id"], name: "index_followers_on_follower_id"
    t.index ["user_id"], name: "index_followers_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.string "description"
    t.string "favicon_src"
    t.string "thumb_src"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_saves", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_saves_on_post_id"
    t.index ["user_id"], name: "index_post_saves_on_user_id"
  end

  create_table "post_votes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.boolean "isUpvote", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_votes_on_post_id"
    t.index ["user_id"], name: "index_post_votes_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id", null: false
    t.string "status", default: "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0
    t.string "url"
    t.string "post_type", default: "text"
    t.integer "link_id"
    t.integer "community_id"
    t.index ["community_id"], name: "index_posts_on_community_id"
    t.index ["link_id"], name: "index_posts_on_link_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type '' for column 'avatar'

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comment_saves", "comments"
  add_foreign_key "comment_saves", "users"
  add_foreign_key "comment_votes", "comments"
  add_foreign_key "comment_votes", "users"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "communities", "users", column: "owner_id"
  add_foreign_key "community_members", "communities"
  add_foreign_key "community_members", "users"
  add_foreign_key "follower2s", "users"
  add_foreign_key "follower2s", "users", column: "follower_id"
  add_foreign_key "followers", "users"
  add_foreign_key "followers", "users", column: "follower_id"
  add_foreign_key "post_saves", "posts"
  add_foreign_key "post_saves", "users"
  add_foreign_key "post_votes", "posts"
  add_foreign_key "post_votes", "users"
  add_foreign_key "posts", "communities"
  add_foreign_key "posts", "links"
  add_foreign_key "posts", "users"
end
