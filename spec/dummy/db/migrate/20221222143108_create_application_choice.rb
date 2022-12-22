class CreateApplicationChoice < ActiveRecord::Migration[7.0]
  def change
    create_table :application_choices do |t|
      t.boolean :rejected, default: false, null: false

      t.references :course_option, null: false
      t.references :application_form, null: false

      t.timestamps
    end
  end
end
