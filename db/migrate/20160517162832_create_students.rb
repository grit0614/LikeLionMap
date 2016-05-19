class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :univ
      t.string :image
      t.string :assignment
      t.string :lecture

      t.timestamps null: false
    end
  end
end
