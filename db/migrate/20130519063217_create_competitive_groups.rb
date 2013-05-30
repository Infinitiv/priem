class CreateCompetitiveGroups < ActiveRecord::Migration
  def change
    create_table :competitive_groups do |t|
      t.references :campaign
      t.integer :course
      t.string :name

      t.timestamps
    end
    add_index :competitive_groups, :campaign_id
  end
end
