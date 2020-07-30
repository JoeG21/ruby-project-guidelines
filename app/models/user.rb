class User < ActiveRecord::Base
    has_many :user_question
    has_many :questions, through: :user_question
    has_many :user_topic
    has_many :topics, through: :user_topic
    has_many :answers
end