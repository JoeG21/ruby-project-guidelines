class CreateUser < ActiveRecord::Migration[6.0]
  
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string  :gender
      t.integer :age
      t.boolean :account_setup_complete, default: false
      t.boolean :is_logged_in, default: false
    end
  end

end