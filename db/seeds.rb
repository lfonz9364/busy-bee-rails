# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Clear existing data to avoid duplication when seeding multiple times

# db/seeds.rb

puts "Cleaning database..."

Feedback.delete_all
Job.delete_all
Developer.delete_all
Client.delete_all
User.delete_all

puts "Seeding users..."

users = User.create!([
  {
    name: 'Agatha Christie',
    email: 'agatha.christie@yahoo.com',
    address: '19 Rubina Ct',
    suburb: 'Launceston',
    state: 'TAS',
    postcode: '7250',
    country: 'Australia',
    contact_person: 'Agatha',
    abn: '12345432123',
    role: 'developer',
    password: 'password123',
    password_confirmation: 'password123'
  },
  {
    name: 'Barry Tabios',
    email: 'barry.tabios@gmail.com',
    address: '19 Clayton Rd',
    suburb: 'Clayton',
    state: 'VIC',
    postcode: 3168,
    country: 'Australia',
    contact_person: 'Barry',
    abn: '87665434521',
    role: 'developer',
    password: 'password123',
    password_confirmation: 'password123'
  },
  {
    name: 'Martina Hingis',
    email: 'martina.rocks@yahoo.com',
    address: '25 Murrumbeena Rd',
    suburb: 'Murrumbeena',
    state: 'VIC',
    postcode: 3163,
    country: 'Australia',
    contact_person: 'Martina',
    abn: '87645632123',
    role: 'developer',
    password: 'password123',
    password_confirmation: 'password123'
  },
  {
    name: 'Arthur Redford',
    email: 'arthur.thebest@yahoo.com',
    address: '50 Kooyong Rd',
    suburb: 'Caulfield North',
    state: 'VIC',
    postcode: 3161,
    country: 'Australia',
    contact_person: 'Arthur',
    abn: '56478678612',
    role: 'developer',
    password: 'password123',
    password_confirmation: 'password123'
  },
  {
    name: 'GlassDoor Corp',
    email: 'info@glasdoor.com.au',
    address: '1656 Dandenong Rd',
    suburb: 'Auburn',
    state: 'NSW',
    postcode: 2144,
    country: 'Australia',
    contact_person: 'Danie',
    abn: '15562790878',
    role: 'client',
    password: 'password123',
    password_confirmation: 'password123'
  },
  {
    name: 'Happy Always',
    email: 'contact@happyalways.com.au',
    address: '2000 Dandenong Rd',
    suburb: 'Penrith',
    state: 'NSW',
    postcode: 2750,
    country: 'Australia',
    contact_person: 'Andrew',
    abn: '18759654078',
    role: 'client',
    password: 'password123',
    password_confirmation: 'password123'
  },
  {
    name: 'John Smith',
    email: 'john.smith@yahoo.com',
    address: '20 Rubina Ct',
    suburb: 'Ashmore',
    state: 'QLD',
    postcode: 4214,
    country: 'Australia',
    contact_person: 'John',
    abn: '12345678901',
    role: 'developer',
    password: 'password123',
    password_confirmation: 'password123'
  },
  {
    name: 'Jane Doe',
    email: 'jane.doe@yahoo.com',
    address: '50 Kangaroo Rd',
    suburb: 'Annerley',
    state: 'QLD',
    postcode: 4103,
    country: 'Australia',
    contact_person: 'Jane',
    abn: '89677346512',
    role: 'client',
    password: 'password123',
    password_confirmation: 'password123'
  },
  {
    name: 'Alfons Caroles',
    email: 'cllin7787@gmail.com',
    address: '81 Douglas St',
    suburb: 'Noble Park',
    state: 'VIC',
    postcode: 3174,
    country: 'Australia',
    contact_person: 'Alfons',
    abn: '35466876723',
    role: 'client',
    password: 'password123',
    password_confirmation: 'password123',
    admin: true
  },
  {
    name: 'Michael Constantine',
    email: 'me@michaelconstantine.com',
    address: '25/1650 Dandenong Rd',
    suburb: 'Katherine',
    state: 'NT',
    postcode: '0850',
    country: 'Australia',
    contact_person: 'Michael',
    abn: '35656654732',
    role: 'client',
    password: 'password123',
    password_confirmation: 'password123'
  }
])

puts "Created #{users.count} users."

agatha, barry, martina, arthur,
glassdoor_user, happy_user, john,
jane, alfons, michael = users

puts "Seeding developers..."

agatha_dev = Developer.create!(user: agatha, skillset: "Ruby, Rails, PostgreSQL")
barry_dev  = Developer.create!(user: barry, skillset: "React, TypeScript")
martina_dev = Developer.create!(user: martina, skillset: "Rails API, Redis")
john_dev   = Developer.create!(user: john, skillset: "Full-stack Rails")

puts "Seeding clients..."

glassdoor_client = Client.create!(user: glassdoor_user)
happy_client     = Client.create!(user: happy_user)
alfons_client    = Client.create!(user: alfons)
michael_client   = Client.create!(user: michael)

puts "Seeding jobs..."

job1 = Job.create!(
  client: happy_client,
  developer: agatha_dev,
  title: "Marketing Website",
  description: "Build responsive marketing website.",
  reward: 8000,
  status: "open",
  deadline: 3.weeks.from_now
)

job2 = Job.create!(
  client: glassdoor_client,
  developer: barry_dev,
  title: "Internal Dashboard",
  description: "Create KPI dashboard with export features.",
  reward: 12000,
  status: "in_progress",
  deadline: 1.month.from_now
)

job3 = Job.create!(
  client: alfons_client,
  developer: martina_dev,
  title: "API Refactor",
  description: "Improve performance and code quality.",
  reward: 10000,
  status: "open",
  deadline: 4.weeks.from_now
)

puts "Seeding feedback..."

Feedback.create!(
  job: job1,
  user: happy_user,
  rating: 5,
  comment: "Excellent delivery and communication.",
  role: "client"
)

Feedback.create!(
  job: job2,
  user: glassdoor_user,
  rating: 4,
  comment: "Very responsive and clean implementation.",
  role: "client"
)

Feedback.create!(
  job: job3,
  user: alfons,
  rating: 5,
  comment: "Great refactor, system feels much faster.",
  role: "client"
)

puts "Seeding complete ✅"