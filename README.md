<img width="1924" height="1113" alt="Screenshot 2026-03-24 at 4 45 43 pm" src="https://github.com/user-attachments/assets/a8ee1fd4-6103-440b-b108-abe6de1417e4" /># Busy Bee

## User Story

A lot of people nowadays have many ideas but prevented to create it by expertise limitation. Therefore, a website to connect freelance developers with potential clients would be a way to solve this problem and creating new market for web developers as well.

### Technology Used

- Ruby - 3.4.1
- Bundler - 2.6.8
- Rails - 7.2.3
- Postgresql - 17.8
- ActiveRecord - 7.2.3
- Minitest - 5.27.0
- Mail - 2.9.0
- Tailwindcss - 4.2.0

### What I Learned

- TailwindCSS use JS bundler to precompile the CSS
- Several auto created configs might caused issues
- Tailwind > v4 simplified tailwind import into "tailwindcss"
- Rails DB auto generate id unlike sql file where id need to be specified when created a table
- Set a column as FK automatically indexed it
- Model must refer to db schema to properly create and validate data
- Application layer cascade is a better solution than a DB layer cascade for allowing parent record deletion
- SaaS like Rails app should have a validations in Models
- Only delegate necessary information especially related to public profile
- Routing in Ruby evaluated from top to bottom so it's important to put paths in order - from specific to general
- Rails function are hoisted by default so function could be used before declaration
- Session route is always singular
- "!" used to represent function with side effect mutating object or raise exceptions
- Default theme can be added directly to app/assets/tailwind/application.css and run `bin/rails tailwindcss:build`
- If a method in controller just for displaying, before_action could take care any action and leave the definition empty
- Rails auto generated conditional for boolean column/s on a table not an association but we could check association presence to return boolean

### Future Features

- Project reminder
- Payment page
- Passkey implementation

### Deployment

1. Run "Bundle Install"
2. Run Postgresql
3. Run "bin/rails db:create" and "bin/rails db:migrate" to create database
4. Run "bin/dev" to start Rails server with Tailwind and JS bundler
5. Go to <http://localhost:3000> in browser

[visit page](https://busy-bee-icmk.onrender.com/)
<img width="1924" height="1113" alt="Login Page" src="https://github.com/user-attachments/assets/c517936e-833a-491f-8114-f384a54d62a5" />
<img width="1920" height="1113" alt="Admin Landing Page" src="https://github.com/user-attachments/assets/b5aecf23-1247-4395-a1e1-88413622b8f1" />
<img width="1926" height="1116" alt="Developer Landing Page" src="https://github.com/user-attachments/assets/4efd485c-ad01-43b6-bab5-7e6ac0d8bca4" />
<img width="1917" height="1114" alt="Client Landing Page" src="https://github.com/user-attachments/assets/234ebfaa-0a08-40e9-bae7-72e013d237c5" />

