require_relative './config/environment.rb'
ActiveRecord::Base.logger = nil

def prompt
    TTY::Prompt.new(interrupt: :exit, active_color: :cyan)
end

def title
    Artii::Base.new()
end

def random_post
    all = []
    Answer.all.each do |a|
        all.push(a)
    end
    all.sample
end

def app_post

end

def app_questions(user, topic)

    puts title.asciify("#{topic}").colorize(:color => :green, :background => :red)
    puts ""

    select_options = ["Go Back".colorize(:blue), "Go Home".colorize(:blue)]

    Question.all.each do | q |
        if q.topic.title == topic
            select_options.unshift(q.name)
        end
    end

    selection = prompt.select("Choose any exercise to view!", select_options, per_page: 25)

    case selection
    when "Go Back".colorize(:blue)
        system "clear"
        app_topics(user)
    when "Go Home".colorize(:blue)
        system "clear"
        app_home(user)
    else
        system "clear"
        user_answer(user, selection)
    end

end

def app_topics(user)

    puts title.asciify("Topics").colorize(:color => :green, :background => :red)
    puts ""

    select_options = ["Go Back".colorize(:blue)]

    Topic.all.each do |c|
        select_options.unshift(c.title)
    end

    selection = prompt.select("Please select any of the following:", select_options, per_page: 25)

    case selection
    when "Go Back".colorize(:blue)
        system "clear"
        app_home(user)
    else
        system "clear"
        app_questions(user, selection)
    end

end

def user_profile_edit(user, info)

    update_column = info.split.shift

    case update_column
    when "Name:"
        name = prompt.ask("Enter your new name:") do |q|
            q.required true
            q.validate /^[a-zA-Z\-\`]++(?: [a-zA-Z\-\`]++)?$/
            q.messages[:valid?] = 'Please enter a valid name'
            q.modify :capitalize
        end
        user.name = name
        user.save
        system "clear"
        user_page_profile(user)
    when "Email:"
        email = create_account_email
        user.email = email
        user.save
        system "clear"
        user_page_profile(user)
    when "Age:"
        age = prompt.ask("Please enter your age:", required: true)
        user.age = age
        user.save
        system "clear"
        user_page_profile(user)
    when "Gender:"
        gender = prompt.ask("Please enter your gender:", required: true)
        user.gender = gender
        user.save
        system "clear"
        user_page_profile(user)
    when "Password:"
        password = create_account_password
        bcrypt_password = BCrypt::Password.create(password)
        user.password = bcrypt_password
        user.save
        system "clear"
        user_page_profile(user)
    end

end

def user_page_profile(user)

    selection = prompt.select(
        "Edit Profile:",
        [
            "Name: #{user.name}",
            "Email: #{user.email}",
            "Age: #{user.age}",
            "Gender: #{user.gender}",
            "Password: **********",
            "Go Back".colorize(:blue)
        ],
        per_page: 10
    )

    if selection == "Go Back".colorize(:blue)
        system "clear"
        user_page(user)
    else
        user_profile_edit(user, selection)
    end

end

def user_page(user)

    puts title.asciify("#{user.name}").colorize(:color => :green, :background => :red)
    puts ""

    selection = prompt.select("Welcome to your page!", ["My Profile", "My Posts", "Go Back".colorize(:blue)])

    case selection
    when "My Profile"
        system "clear"
        user_page_profile(user)
    when "My Posts"
        system "clear"
        app_topics(user)
    when "Go Back".colorize(:blue)
        system "clear"
        app_home(user)
    end

end

def app_home(user)

    puts title.asciify("Op").colorize(:color => :green, :background => :red, :mode => :blink)
    puts ""

    puts 'Some Posts!'
    random_post
    puts ''

    puts "Signed In: #{user.name}".colorize(:color => :cyan).underline
    selection = prompt.select("Please select an option:", [
        "View Post",
        "Write Post",
        "My Page",
        "Exit".colorize(:red),
        "Logout".colorize(:light_red)
    ])

    case selection
    when "View Post"
        system "clear"
        app_post
    when "Write Post"
        system 'clear'
        app_topics(user)
    when "My Page"
        system "clear"
        user_page(user)
    when "Exit".colorize(:red)
        system "clear"
        exit
    when "Logout".colorize(:light_red)
        system "clear"
        puts "Goodbye!"
        user.is_logged_in = false
        user.save
        run
    end

end

def sign_in

    puts "Sing In Process".colorize(:green)
    email = prompt.ask("Please enter your email address:", required: true)

    existing_user = User.find_by(email: email)

    if existing_user
        check_password = BCrypt::Password.new(existing_user.password)
        password = prompt.ask("Please enter your password:", echo: false) do |q|
            q.required true
            q.validate { |input| check_password == input }
            q.messages[:valid?] = "Please type in the correct password"
        end

        if existing_user.account_setup_complete
            existing_user.is_logged_in = true
            existing_user.save
            system "clear"
            app_home(existing_user)
        else
            message = "Continue setting up!"
            account_setup(existing_user, message)
        end
    else
        message = "Couldn't find your Account. Would you like to create one?"
        selection = prompt.select(message, ["Yes", "Retry", "Go Home"])
        case selection
        when "Yes"
            create_account
        when "Retry"
            system "clear"
            sign_in
        when "Go Home"
            system "clear"
            run
        end
    end

end

def account_setup(user, message)

    puts "#{message} Please proceed setting up your account:"

    age = prompt.ask("What is your age?", required: true)
    user.age = age

    gender = prompt.ask("What is your gender?", required: true)
    user.gender = gender

    user.account_setup_complete = true
    user.save

    system "clear"
    app_home(user)

end

def create_account_password
    password = prompt.ask("Please enter a password:", echo: false) do |q|
        q.required true
        q.validate { |input| input.length > 4 }
        q.messages[:valid?] = "Please enter a password that has more than 4 characters!"
    end
    confirm_password = prompt.ask("Please confirm your password:", echo: false) do |q|
        q.required true
        q.validate { |input| input == password }
        q.messages[:valid?] = "Passwords do not match!"
    end
    password
end

def create_account_email
    email = prompt.ask("Please enter a email address:") do |q|
        q.required true
        q.validate(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
        q.messages[:valid?] = 'Invalid email address'
    end
    existing_user = User.find_by(email: email)
    if existing_user
        system "clear"
        message =  "A user with this email address already exists!"
        selection = prompt.select(message, ["Try Again"])
        if selection == "Try Again"
            system "clear"
            create_account_email
        end
    else
        return email
    end
end

def create_account

    puts "Sing Up Process"
    name = prompt.ask("Please enter your full name:") do |q|
        q.required true
        q.validate /^[a-zA-Z\-\`]++(?: [a-zA-Z\-\`]++)?$/
        q.messages[:valid?] = 'Please enter a valid name'
        q.modify :capitalize
    end

    email = create_account_email()

    password = create_account_password()
    bcrypt_password = BCrypt::Password.create(password)

    user = User.create({
        name: name,
        email: email,
        password: bcrypt_password,
        is_logged_in: true
    })

    system "clear"
    message = "Account created!"
    account_setup(user, message)

end

def run
    # Checks if a user is logged in, sends to "Home Page" (app_home)
    user_logged_in = User.find_by(is_logged_in: true)
    if user_logged_in
        if user_logged_in.account_setup_complete
            system "clear"
            return app_home(user_logged_in)
        else
            system "clear"
            message = "Continue setting up!"
            return account_setup(user_logged_in, message)
        end
    end

    # Initial startup of the app (Sign In / Sign Up)
    puts title.asciify("Op").colorize(:color => :red, :background => :green)
    puts ""

    message = "Welcome! Select one of the following!"
    selection = prompt.select(message, ["Sign Up", "Sign In", "Exit".colorize(:red)])

    case selection
    when "Sign Up"
        system "clear"
        create_account
    when "Sign In"
        system "clear"
        sign_in
    when "Exit".colorize(:red)
        system "clear"
        exit
    end

end

system "clear"
run