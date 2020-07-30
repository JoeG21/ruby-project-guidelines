class Question < ActiveRecord::Base
    belongs_to :topic
    has_many :answers
    has_many :users
end