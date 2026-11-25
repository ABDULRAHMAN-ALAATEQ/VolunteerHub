class CreateOpportunities < ActiveRecord::Migration[7.2]
  def change
    create_table :opportunities do |t|
      t.references :organization, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description, null: false
      t.string :category, null: false
      t.string :location, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :capacity, null: false
      t.string :status, null: false, default: 'open'
      t.timestamps
    end
    add_check_constraint :opportunities, 'capacity > 0', name: 'positive_capacity'
    add_check_constraint :opportunities, 'ends_at > starts_at', name: 'valid_interval'
    add_check_constraint :opportunities, "status IN ('open','closed')", name: 'valid_opportunity_status'
  end
end
