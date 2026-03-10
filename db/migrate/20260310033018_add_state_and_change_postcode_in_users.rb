class AddStateAndChangePostcodeInUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :state, :string
    change_column :users, :postcode, :string

    # Update existing records to have a state value based on the postcode
    User.reset_column_information

    User.find_each do |user|
      user.updateColumns(
        state: infer_state_from_postcode(user.postcode),
        postcode: user.postcode.to_s
      )
    end
  end

  def down
    remove_column :users, :state
    change_column :users, :postcode, :integer
  end

  private

  def infer_state_from_postcode(postcode)
    code = postcode.to_s

    case code
    when /\A3\d{3}\z/, /\A8\d{3}\z/ then "VIC" # Postcodes starting with 3 or 8 are typically in Victoria
    when /\A1\d{3}\z/, /\A2\d{3}\z/ then "NSW" # Postcodes starting with 1 or 2 are typically in New South Wales
    when /\A4\d{3}\z/, /\A9\d{3}\z/ then "QLD" # Postcodes starting with 4 or 9 are typically in Queensland
    when /\A5\d{3}\z/ then "SA" # Postcodes starting with 5 are typically in South Australia
    when /\A6\d{3}\z/ then "WA" # Postcodes starting with 6 are typically in Western Australia
    when /\A7\d{3}\z/ then "TAS" # Postcodes starting with 7 are typically in Tasmania
    when /\A0\d{3}\z/ then "NT" # Postcodes starting with 0 are typically in Northern Territory
    else
      'VIC' # Default to VIC if postcode is invalid or missing
    end
  end
end
