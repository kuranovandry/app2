class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, limit: 50
      t.string :last_name
      t.string :email, limit: 50
      t.string :phone
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
