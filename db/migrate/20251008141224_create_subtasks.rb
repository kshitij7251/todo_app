class CreateSubtasks < ActiveRecord::Migration[8.0]
  def change
    create_table :subtasks do |t|
      t.string :title
      t.text :description
      t.boolean :completed
      t.references :parent_task, null: false, foreign_key: { to_table: :tasks }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
