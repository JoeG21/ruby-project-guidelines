class CreateQuestion < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :name
      t.integer :topic_id
    end
  end
end
