class CreateViewCounts < ActiveRecord::Migration
  def change
    create_table :view_counts do |t|
      t.references :user, index: true
      t.references :playlist, index: true
      t.date :footprint_date

      t.timestamps
    end
  end
end
