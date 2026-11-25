class CreateCertificates < ActiveRecord::Migration[7.2]
  def change
    create_table :certificates do |t|
      t.references :registration, null: false, foreign_key: true, index: { unique: true }
      t.references :issuer, null: false, foreign_key: { to_table: :users }
      t.string :code, null: false
      t.string :student_name, null: false
      t.string :opportunity_title, null: false
      t.decimal :hours, precision: 6, scale: 2, null: false
      t.datetime :issued_at, null: false
      t.timestamps
    end
    add_index :certificates, :code, unique: true
  end
end
