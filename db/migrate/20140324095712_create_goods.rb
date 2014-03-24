class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.references :user, index: true
      t.references :playlist, index: true

      t.timestamps
    end
  end
end
