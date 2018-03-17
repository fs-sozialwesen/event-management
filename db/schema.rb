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

ActiveRecord::Schema.define(version: 20180317180357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alchemy_attachments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "file_name"
    t.string "file_mime_type"
    t.integer "file_size"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "cached_tag_list"
    t.string "file_uid"
    t.index ["file_uid"], name: "index_alchemy_attachments_on_file_uid"
  end

  create_table "alchemy_cells", id: :serial, force: :cascade do |t|
    t.integer "page_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_alchemy_cells_on_page_id"
  end

  create_table "alchemy_contents", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "essence_type", null: false
    t.integer "essence_id", null: false
    t.integer "element_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.index ["element_id", "position"], name: "index_contents_on_element_id_and_position"
    t.index ["essence_id", "essence_type"], name: "index_alchemy_contents_on_essence_id_and_essence_type", unique: true
  end

  create_table "alchemy_elements", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.integer "page_id", null: false
    t.boolean "public", default: true
    t.boolean "folded", default: false
    t.boolean "unique", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.integer "cell_id"
    t.text "cached_tag_list"
    t.integer "parent_element_id"
    t.index ["cell_id"], name: "index_alchemy_elements_on_cell_id"
    t.index ["page_id", "parent_element_id"], name: "index_alchemy_elements_on_page_id_and_parent_element_id"
    t.index ["page_id", "position"], name: "index_elements_on_page_id_and_position"
  end

  create_table "alchemy_elements_alchemy_pages", id: false, force: :cascade do |t|
    t.integer "element_id"
    t.integer "page_id"
  end

  create_table "alchemy_essence_booleans", id: :serial, force: :cascade do |t|
    t.boolean "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.index ["value"], name: "index_alchemy_essence_booleans_on_value"
  end

  create_table "alchemy_essence_dates", id: :serial, force: :cascade do |t|
    t.datetime "date"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_essence_files", id: :serial, force: :cascade do |t|
    t.integer "attachment_id"
    t.string "title"
    t.string "css_class"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link_text"
    t.index ["attachment_id"], name: "index_alchemy_essence_files_on_attachment_id"
  end

  create_table "alchemy_essence_htmls", id: :serial, force: :cascade do |t|
    t.text "source"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_essence_links", id: :serial, force: :cascade do |t|
    t.string "link"
    t.string "link_title"
    t.string "link_target"
    t.string "link_class_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
  end

  create_table "alchemy_essence_pictures", id: :serial, force: :cascade do |t|
    t.integer "picture_id"
    t.string "caption"
    t.string "title"
    t.string "alt_tag"
    t.string "link"
    t.string "link_class_name"
    t.string "link_title"
    t.string "css_class"
    t.string "link_target"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crop_from"
    t.string "crop_size"
    t.string "render_size"
    t.index ["picture_id"], name: "index_alchemy_essence_pictures_on_picture_id"
  end

  create_table "alchemy_essence_richtexts", id: :serial, force: :cascade do |t|
    t.text "body"
    t.text "stripped_body"
    t.boolean "public"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_essence_selects", id: :serial, force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.index ["value"], name: "index_alchemy_essence_selects_on_value"
  end

  create_table "alchemy_essence_texts", id: :serial, force: :cascade do |t|
    t.text "body"
    t.string "link"
    t.string "link_title"
    t.string "link_class_name"
    t.boolean "public", default: false
    t.string "link_target"
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_folded_pages", id: :serial, force: :cascade do |t|
    t.integer "page_id", null: false
    t.integer "user_id", null: false
    t.boolean "folded", default: false
    t.index ["page_id", "user_id"], name: "index_alchemy_folded_pages_on_page_id_and_user_id", unique: true
  end

  create_table "alchemy_languages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "language_code"
    t.string "frontpage_name"
    t.string "page_layout", default: "intro"
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.boolean "default", default: false
    t.string "country_code", default: "", null: false
    t.integer "site_id", null: false
    t.string "locale"
    t.index ["language_code", "country_code"], name: "index_alchemy_languages_on_language_code_and_country_code"
    t.index ["language_code"], name: "index_alchemy_languages_on_language_code"
    t.index ["site_id"], name: "index_alchemy_languages_on_site_id"
  end

  create_table "alchemy_legacy_page_urls", id: :serial, force: :cascade do |t|
    t.string "urlname", null: false
    t.integer "page_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_alchemy_legacy_page_urls_on_page_id"
    t.index ["urlname"], name: "index_alchemy_legacy_page_urls_on_urlname"
  end

  create_table "alchemy_pages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "urlname"
    t.string "title"
    t.string "language_code"
    t.boolean "language_root"
    t.string "page_layout"
    t.text "meta_keywords"
    t.text "meta_description"
    t.integer "lft"
    t.integer "rgt"
    t.integer "parent_id"
    t.integer "depth"
    t.boolean "visible", default: false
    t.integer "locked_by"
    t.boolean "restricted", default: false
    t.boolean "robot_index", default: true
    t.boolean "robot_follow", default: true
    t.boolean "sitemap", default: true
    t.boolean "layoutpage", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.integer "language_id"
    t.text "cached_tag_list"
    t.datetime "published_at"
    t.datetime "public_on"
    t.datetime "public_until"
    t.datetime "locked_at"
    t.index ["language_id"], name: "index_pages_on_language_id"
    t.index ["locked_at", "locked_by"], name: "index_alchemy_pages_on_locked_at_and_locked_by"
    t.index ["parent_id", "lft"], name: "index_pages_on_parent_id_and_lft"
    t.index ["public_on", "public_until"], name: "index_alchemy_pages_on_public_on_and_public_until"
    t.index ["rgt"], name: "index_alchemy_pages_on_rgt"
    t.index ["urlname"], name: "index_pages_on_urlname"
  end

  create_table "alchemy_pictures", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "image_file_name"
    t.integer "image_file_width"
    t.integer "image_file_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.string "upload_hash"
    t.text "cached_tag_list"
    t.string "image_file_uid"
    t.integer "image_file_size"
    t.string "image_file_format"
  end

  create_table "alchemy_sites", id: :serial, force: :cascade do |t|
    t.string "host"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false
    t.text "aliases"
    t.boolean "redirect_to_primary_host"
    t.index ["host", "public"], name: "alchemy_sites_public_hosts_idx"
    t.index ["host"], name: "index_alchemy_sites_on_host"
  end

  create_table "attendees", id: :serial, force: :cascade do |t|
    t.integer "seminar_id"
    t.integer "booking_id"
    t.string "first_name"
    t.string "last_name"
    t.jsonb "address", default: "{}"
    t.jsonb "contact", default: "{}"
    t.string "profession"
    t.string "gender"
    t.integer "age"
    t.jsonb "other", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "invoice_id"
    t.integer "status", default: 0
    t.boolean "member"
    t.boolean "member_institution"
    t.boolean "graduate"
    t.string "school"
    t.string "year"
    t.jsonb "company_address", default: "{}"
    t.jsonb "invoice_address", default: "{}"
    t.text "comments"
    t.text "cancellation_reason"
    t.integer "canceled_by_id"
    t.index ["booking_id"], name: "index_attendees_on_booking_id"
    t.index ["company_id"], name: "index_attendees_on_company_id"
    t.index ["invoice_id"], name: "index_attendees_on_invoice_id"
    t.index ["seminar_id"], name: "index_attendees_on_seminar_id"
  end

  create_table "bookings", id: :serial, force: :cascade do |t|
    t.integer "seminar_id"
    t.jsonb "contact", default: "{}"
    t.integer "places", default: 1
    t.jsonb "other", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoice_id"
    t.jsonb "address", default: "{}"
    t.boolean "member", default: false
    t.boolean "member_institution", default: false
    t.boolean "graduate", default: false
    t.string "school"
    t.string "year"
    t.string "ip_address"
    t.jsonb "company_address", default: "{}"
    t.jsonb "invoice_address", default: "{}"
    t.integer "status", default: 0
    t.integer "company_id"
    t.text "comments"
    t.index ["company_id"], name: "index_bookings_on_company_id"
    t.index ["seminar_id"], name: "index_bookings_on_seminar_id"
  end

  create_table "catalogs", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.string "print_version_file_name"
    t.string "print_version_content_type"
    t.integer "print_version_file_size"
    t.datetime "print_version_updated_at"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "category_id"
    t.string "number"
    t.integer "year"
    t.integer "parent_id"
    t.integer "position", default: 0, null: false
    t.index ["category_id"], name: "index_categories_on_category_id"
    t.index ["name"], name: "index_categories_on_name"
    t.index ["number"], name: "index_categories_on_number"
  end

  create_table "categories_seminars", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "seminar_id", null: false
    t.index ["category_id"], name: "index_categories_seminars_on_category_id"
    t.index ["seminar_id"], name: "index_categories_seminars_on_seminar_id"
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "name2"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.string "city_part"
    t.string "phone"
    t.string "mobile"
    t.string "fax"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.integer "seminar_id"
    t.date "date"
    t.string "start_time"
    t.string "end_time"
    t.integer "location_id"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_events_on_location_id"
    t.index ["seminar_id"], name: "index_events_on_seminar_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "subject"
    t.text "message"
    t.string "path"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.string "number", null: false
    t.date "date", null: false
    t.text "address"
    t.text "pre_message"
    t.text "post_message"
    t.jsonb "items", default: "[]"
    t.integer "status", default: 0
    t.jsonb "others"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seminar_id"
    t.integer "company_id"
    t.index ["company_id"], name: "index_invoices_on_company_id"
    t.index ["seminar_id"], name: "index_invoices_on_seminar_id"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.jsonb "address", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.integer "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "seminars", id: :serial, force: :cascade do |t|
    t.string "number", null: false
    t.string "title", null: false
    t.string "subtitle"
    t.integer "year", null: false
    t.text "benefit"
    t.text "content"
    t.text "notes"
    t.text "due_date"
    t.text "price_text"
    t.text "date_text"
    t.text "location_text"
    t.string "time"
    t.integer "max_attendees"
    t.jsonb "others", default: "{}"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
    t.float "price_reduced"
    t.integer "parent_id"
    t.jsonb "price_info", default: "{}"
    t.boolean "archived", default: false
    t.boolean "published", default: false
    t.date "date"
    t.jsonb "statistic", default: "{}"
    t.boolean "canceled", default: false
    t.text "key_words"
    t.integer "copy_from_id"
    t.datetime "layout_finished_at"
    t.datetime "editing_finished_at"
    t.integer "editor_id"
    t.string "external_booking_address"
    t.index ["location_id"], name: "index_seminars_on_location_id"
    t.index ["parent_id"], name: "index_seminars_on_parent_id"
  end

  create_table "seminars_teachers", id: false, force: :cascade do |t|
    t.integer "seminar_id", null: false
    t.integer "teacher_id", null: false
    t.index ["seminar_id"], name: "index_seminars_teachers_on_seminar_id"
    t.index ["teacher_id"], name: "index_seminars_teachers_on_teacher_id"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "teachers", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.string "profession"
    t.jsonb "address", default: "{}"
    t.jsonb "contact", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "skill_sets"
    t.text "remarks"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "upload_file_file_name"
    t.string "upload_file_content_type"
    t.integer "upload_file_file_size"
    t.datetime "upload_file_updated_at"
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role"
    t.string "username"
<<<<<<< HEAD
    t.integer "creator_id"
    t.integer "updater_id"
    t.index ["creator_id"], name: "index_users_on_creator_id"
=======
    t.string "roles", default: [], array: true
>>>>>>> master
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["updater_id"], name: "index_users_on_updater_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "version_associations", id: :serial, force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "alchemy_cells", "alchemy_pages", column: "page_id", name: "alchemy_cells_page_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_contents", "alchemy_elements", column: "element_id", name: "alchemy_contents_element_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_elements", "alchemy_cells", column: "cell_id", name: "alchemy_elements_cell_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_elements", "alchemy_pages", column: "page_id", name: "alchemy_elements_page_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "attendees", "bookings", on_delete: :cascade
  add_foreign_key "attendees", "companies"
  add_foreign_key "attendees", "invoices"
  add_foreign_key "attendees", "seminars"
  add_foreign_key "bookings", "companies"
  add_foreign_key "bookings", "seminars", on_delete: :cascade
  add_foreign_key "categories", "categories", on_delete: :cascade
  add_foreign_key "categories_seminars", "categories", on_delete: :cascade
  add_foreign_key "categories_seminars", "seminars", on_delete: :cascade
  add_foreign_key "events", "locations"
  add_foreign_key "events", "seminars", on_delete: :cascade
  add_foreign_key "feedbacks", "users"
  add_foreign_key "invoices", "seminars"
  add_foreign_key "seminars", "locations"
  add_foreign_key "seminars", "seminars", column: "parent_id"
  add_foreign_key "seminars_teachers", "seminars", on_delete: :cascade
  add_foreign_key "seminars_teachers", "teachers", on_delete: :cascade
end
