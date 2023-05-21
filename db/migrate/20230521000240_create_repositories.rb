class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.string :name, null: false
      t.references :owner, null: false, foreign_key: { to_table: :github_users }
      t.integer :stars, null: true
      t.index [:name, :owner_id], unique: true

      t.timestamps
    end
  end
end
