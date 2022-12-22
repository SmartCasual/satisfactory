class CreateCandidate < ActiveRecord::Migration[7.0]
  def change
    create_table :candidates do |t|
      t.string :email_address

      t.timestamps
    end
  end
end
