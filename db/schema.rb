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

ActiveRecord::Schema.define(version: 2021_04_10_150434) do

  create_table "Users", id: { limit: 8 }, force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.integer "karma"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_token"
    t.string "google_refresh_token"
    t.text "about"
  end

  create_table "comments", force: :cascade do |t|
    t.text "text"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "comment_id"
    t.integer "new_id"
    t.index ["comment_id"], name: "index_comments_on_comment_id"
    t.index ["new_id"], name: "index_comments_on_new_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likecomments", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "comment_id", null: false
    t.index ["comment_id"], name: "index_likecomments_on_comment_id"
    t.index ["user_id"], name: "index_likecomments_on_user_id"
  end

  create_table "likenews", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "new_id", null: false
    t.index ["new_id"], name: "index_likenews_on_new_id"
    t.index ["user_id"], name: "index_likenews_on_user_id"
  end

  create_table "news", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.text "text"
    t.integer "isurl"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_news_on_user_id"
  end

  add_foreign_key "comments", "comments"
  add_foreign_key "comments", "news", column: "new_id"
  add_foreign_key "comments", "users"
  add_foreign_key "likecomments", "comments"
  add_foreign_key "likecomments", "users"
  add_foreign_key "likenews", "news", column: "new_id"
  add_foreign_key "likenews", "users"
  add_foreign_key "news", "users"
end
