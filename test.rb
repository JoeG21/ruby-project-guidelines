require 'pry'

require_relative './config/environment.rb'
ActiveRecord::Base.logger = nil

u1 = User.first

t1 = Topic.first
t2 = Topic.second

q1 = Question.first
q2 = Question.second

a1 = Answer.first
a2 = Answer.second

ut1 = UserTopic.first
ut2 = UserTopic.second

uq1 = UserQuestion.first
uq2 = UserQuestion.second



binding.pry
0