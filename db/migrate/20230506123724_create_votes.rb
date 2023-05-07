class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.integer :epoch
      t.references :campaign, null: false, foreign_key: true
      t.references :candidate, foreign_key: true
      t.string :validity

      t.timestamps
    end
  end
end
