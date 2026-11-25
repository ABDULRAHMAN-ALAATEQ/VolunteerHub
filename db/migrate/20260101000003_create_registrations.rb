class CreateRegistrations < ActiveRecord::Migration[7.2]
  def change
    create_table :registrations do |t|
      t.references :opportunity, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false, default: 'registered'
      t.decimal :hours, precision: 6, scale: 2
      t.text :activity_note
      t.text :review_note
      t.references :reviewer, foreign_key: { to_table: :users }
      t.datetime :reviewed_at
      t.timestamps
    end
    add_index :registrations, [:opportunity_id, :student_id], unique: true
    add_check_constraint :registrations, "status IN ('registered','submitted','approved','rejected')", name: 'valid_registration_status'
    add_check_constraint :registrations, 'hours IS NULL OR hours > 0', name: 'positive_hours'
  end
end
