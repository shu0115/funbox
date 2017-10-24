class CreateGoods < ActiveRecord::Migration[4.2]
  def change
    create_table :goods do |t|
      t.references :user, index: true
      t.references :playlist, index: true

      t.timestamps
    end
  end
end
