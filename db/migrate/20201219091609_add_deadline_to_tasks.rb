class AddDeadlineToTasks < ActiveRecord::Migration[5.2]
  def up
    add_column :tasks, :deadline, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end

  def down
    remove_column :tasks, :deadline
  end
end
