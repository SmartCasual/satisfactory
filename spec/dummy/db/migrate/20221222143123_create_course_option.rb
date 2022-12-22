class CreateCourseOption < ActiveRecord::Migration[7.0]
  def change
    create_table :course_options do |t|
      t.boolean :part_time, default: false, null: false

      t.timestamps
    end
  end
end
