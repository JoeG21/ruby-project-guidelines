class CreateUserquestion < ActiveRecord::Migration[6.0]
  def change
    create_table :user_questions do |t|
      t.integer :user_id
      t.integer :question_id
    end
  end
end
