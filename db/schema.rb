ActiveRecord::Schema[7.2].define(version: 2026_01_01_000004) do
  create_table "certificates", force: :cascade do |t|
    t.integer "registration_id", null: false
    t.integer "issuer_id", null: false
    t.string "code", null: false
    t.string "student_name", null: false
    t.string "opportunity_title", null: false
    t.decimal "hours", precision: 6, scale: 2, null: false
    t.datetime "issued_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_certificates_on_code", unique: true
    t.index ["issuer_id"], name: "index_certificates_on_issuer_id"
    t.index ["registration_id"], name: "index_certificates_on_registration_id", unique: true
  end

  create_table "opportunities", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.string "category", null: false
    t.string "location", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.integer "capacity", null: false
    t.string "status", default: "open", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_opportunities_on_organization_id"
    t.check_constraint "capacity > 0", name: "positive_capacity"
    t.check_constraint "ends_at > starts_at", name: "valid_interval"
    t.check_constraint "status IN ('open','closed')", name: "valid_opportunity_status"
  end

  create_table "registrations", force: :cascade do |t|
    t.integer "opportunity_id", null: false
    t.integer "student_id", null: false
    t.string "status", default: "registered", null: false
    t.decimal "hours", precision: 6, scale: 2
    t.text "activity_note"
    t.text "review_note"
    t.integer "reviewer_id"
    t.datetime "reviewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opportunity_id", "student_id"], name: "index_registrations_on_opportunity_id_and_student_id", unique: true
    t.index ["opportunity_id"], name: "index_registrations_on_opportunity_id"
    t.index ["reviewer_id"], name: "index_registrations_on_reviewer_id"
    t.index ["student_id"], name: "index_registrations_on_student_id"
    t.check_constraint "hours IS NULL OR hours > 0", name: "positive_hours"
    t.check_constraint "status IN ('registered','submitted','approved','rejected')", name: "valid_registration_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.check_constraint "role IN ('student','organization','deanship')", name: "valid_role"
  end

  add_foreign_key "certificates", "registrations"
  add_foreign_key "certificates", "users", column: "issuer_id"
  add_foreign_key "opportunities", "users", column: "organization_id"
  add_foreign_key "registrations", "opportunities"
  add_foreign_key "registrations", "users", column: "reviewer_id"
  add_foreign_key "registrations", "users", column: "student_id"
end
