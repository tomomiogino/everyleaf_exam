class AddIndexTitleToTasks < ActiveRecord::Migration[5.2]
  def up
    add_index :tasks, :title
  end

  def down
    remove_index :tasks, :title
  end
end
