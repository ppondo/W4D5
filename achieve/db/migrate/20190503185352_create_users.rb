class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :session_token
      t.string :password_digest

      t.timestamps
    end

    add_index :users, :name
    add_index :users, :password_digest
  end
end
