class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.string :title
      t.integer :number
      t.string :description
      t.integer :duration
      t.string :url

      t.references :podcast, foreign_key: true

      t.timestamps
    end
  end
end
