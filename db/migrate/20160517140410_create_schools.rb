class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.integer :num
      t.float :lat
      t.float :lng

      t.timestamps null: false
    end
  end
end
