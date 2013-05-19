class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :query
      t.text :input
      t.text :output

      t.timestamps
    end
    add_index :requests, :query_id
  end
end
