class CreateApplicationForm < ActiveRecord::Migration[7.0]
  def change
    create_table :application_forms do |t|
      t.string :first_name
      t.boolean :submitted, default: false, null: false

      t.references :candidate, null: false

      t.timestamps
    end
  end
end
