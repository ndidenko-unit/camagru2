class ChangeTypeOfTextComment < ActiveRecord::Migration
  def up
    change_column :comments, :comment_text, :text
  end

  def down
    change_column :comments, :comment_text, :string
  end
end
