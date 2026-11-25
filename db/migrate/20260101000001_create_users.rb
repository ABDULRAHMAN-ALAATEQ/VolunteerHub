class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_check_constraint :users, "role IN ('student','organization','deanship')", name: 'valid_role'
  end
end
