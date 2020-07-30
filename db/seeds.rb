Question.destroy_all
Topic.destroy_all

sport = Topic.create({title: 'Sport'})

q1 = Question.create({
    name: 'Michael Jordan or LeBron James?',
    topic_id: sport.id
})

q2 = Question.create({
    name: 'Greatest NBA Team?',
    topic_id: sport.id
})

q3 = Question.create({
    name: 'Is Golf Even a Sport?',
    topic_id: sport.id
})




music = Topic.create({title: 'Music'})

q4 = Question.create({
    name: 'Best Genre?',
    topic_id: music.id
})

q5 = Question.create({
    name: 'Most Underrated Artist?',
    topic_id: music.id
})

q6 = Question.create({
    name: 'Most Overhype Artist?',
    topic_id: music.id
})




anime = Topic.create({title: 'Anime'})

q7 = Question.create({
    name: 'Naruto or DBZ?',
    topic_id: anime.id
})

q8 = Question.create({
    name: 'Saddest Ending?',
    topic_id: anime.id
})

q9 = Question.create({
    name: 'Best Anime?',
    topic_id: anime.id
})
