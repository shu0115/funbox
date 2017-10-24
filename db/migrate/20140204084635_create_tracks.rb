class CreateTracks < ActiveRecord::Migration[4.2]
  def change
    create_table :tracks do |t|
      t.references :user, index: true
      t.references :playlist, index: true
      t.integer :number
      t.text :player_url
      t.string :provider
      t.string :author_name
      t.integer :duration
      t.text :description
      t.string :title
      t.string :unique_id
      t.timestamp :published_at
      t.integer :favorite_count
      t.integer :view_count

      t.timestamps
    end
  end
end
