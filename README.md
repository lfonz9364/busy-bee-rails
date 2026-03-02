# Busy Bee

## User Story

A lot of people nowadays have many ideas but prevented to create it by expertise limitation. Therefore, a website to connect freelance developers with potential clients would be a way to solve this problem and creating new market for web developers as well.

### Technology Used

- Ruby - 3.4.1
- Bundler - 2.6.8
- Rails - 7.2.3
- Postgresql - 17.4
- ActiveRecord - 7.2.3

### Approach

I choose to follow the best practice of doing the documentation and planning at the beginning . First of all, I tried to create a schema and wireframes to aid in development. Second, the database schema then translated into Postgresql tables with relationships notated in ActiveRecord. Third, the coding process was divided into four parts such as developer, requester, jobs and feedbacks. Last but not least, the features for each part also added during development to make it more user friendly.

### What I Learned

- The "rails new xxx" command automatically init a Git repository by default
- TailwindCSS use JS bundler to precompile the CSS
- Puma boot fast enough to make Spring obsolete
- Gems removed from Ruby standard library required an explicit installation by adding in Ruby Gemfile
- Multiple gem version might create conflict during bundling which need a version lock
- Several auto created configs might caused issues
- Tailwind v4 above simplified tailwind import into "tailwindcss"
- Rails DB auto generate id unlike sql file where id need to be specified when created a table
- Set a column as FK automatically indexed it
- Model must refer to db schema to properly create and validate data

### Unsolved Problems

### To-Do-List

### Future Features

- Project reminder
- Payment page

### Deployment

1. Run "Bundle Install"
2. Run Postgresql
3. Run "bin/rails db:create" and "bin/rails db:migrate" to create database
4. Run "bin/dev" to start Rails server with Tailwind and JS bundler
5. Go to <http://localhost:3000> in browser

[visit page](https://github.com/lfonz9364/busy-bee-rails)
![alt tag]()
![alt tag]()
