ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "active_job/test_helper"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_user(overrides = {})
    defaults = {
      name: "Test User",
      email: "user#{SecureRandom.hex(4)}@example.com",
      address: "123 Test St",
      suburb: "Testville",
      state: "VIC",
      postcode: "3000",
      country: "Australia",
      contact_person: "Tester",
      abn: "12345678901",
      password: "password123",
      password_confirmation: "password123",
      role: "client",
      admin: false
    }

    User.create!(defaults.merge(overrides))
  end

  def create_client(overrides = {})
    user_overrides = {
      name: "Test Client",
      email: "client#{SecureRandom.hex(4)}@example.com",
      contact_person: "Client Contact",
    }
    user = overrides.delete(:user) || create_user(user_overrides)
    Client.create!({ user: user }.merge(overrides))
  end

  def create_developer(overrides = {})
    user_overrides = {
      name: "Test Developer",
      email: "developer#{SecureRandom.hex(4)}@example.com",
      contact_person: "Developer Contact",
      role: "developer"
    }
    user = overrides.delete(:user) || create_user(user_overrides)
    Developer.create!({ user: user, skillset: "Rails" }.merge(overrides))
  end

  def create_admin(overrides = {})
    create_user({admin: true}.merge(overrides))
  end

  def create_job(overrides = {})
    defaults = {
      client: create_client,
      developer: create_developer,
      title: "Test Job",
      description: "Test description",
      reward: 1000,
      status: "open",
      deadline: 1.week.from_now
    }

    Job.create!(defaults.merge(overrides))
  end

  def override_job(overrides = {})
    defaults = {
      client: create_client,
      developer: create_developer,
      title: "Test Job",
      description: "Test description",
      reward: 1000,
      status: "open",
      deadline: 1.week.from_now
    }

    Job.new(defaults.merge(overrides))
  end

  def create_feedback(overrides = {})
    client = create_client

    defaults = {
      job: create_job,
      user: client.user,
      rating: 5,
      comment: "Great work!",
      role: "client"
    }

    Feedback.create!(defaults.merge(overrides))
  end
end

class ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  
  def sign_in_as(user, password: "password123")
    post login_url, params: {
      email: user.email,
      password: password
    }
  end
end
