class AddEmailUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :users, :email, :uniqueness => true
  end

  def down
    remove_index :users, :email
  end
end
