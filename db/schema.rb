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

ActiveRecord::Schema[7.0].define(version: 2023_05_27_182155) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "github_pull_requests", force: :cascade do |t|
    t.integer "number", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.string "author", null: false
    t.string "author_id", null: false
    t.string "author_url", null: false
    t.string "repository", null: false
    t.string "repository_id", null: false
    t.string "repository_url", null: false
    t.string "state", null: false
    t.integer "lines_added", default: 0, null: false
    t.integer "lines_removed", default: 0, null: false
    t.integer "commits_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "review_comments_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "merged_at"
    t.datetime "closed_at"
  end

end
