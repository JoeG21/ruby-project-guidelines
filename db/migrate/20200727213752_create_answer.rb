class CreateAnswer < ActiveRecord::Migration[6.0]

  def change
    create_table :answers do |t|
      t.string :respone
      t.integer :user_id
      t.integer :question_id
    end
  end

end
