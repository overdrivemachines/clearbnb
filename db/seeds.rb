# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.find_by(email: "b@b.com")

def create_listings(user)
  10.times do
    # Create listing
    listing =
      user.listings.create(
        title: ("House " + Faker::Science.modifier + " " + Faker::Science.element),
        about: Faker::Quote.jack_handey,
        max_guests: rand(2...10),
        address_line1: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state,
        postal_code: Faker::Address.zip_code(state_abbreviation: "CA"),
        country: "United States",
        status: Listing.statuses.to_a.sample[0],
        latitude: Faker::Address.latitude,
        longitude: Faker::Address.longitude,
        nightly_price: rand(80..500),
        cleaning_fee: rand(20..100),
      )
    # Each listing has 1 to 4 rooms
    rand(1...4).times do
      # Create room
      room = listing.rooms.create(room_type: rand(0...3))

      # Each room has 1 to 3 beds
      rand(1...3).times { room.beds.create(bed_size: rand(0...5)) }
    end
  end
end

if user.nil?
  user = User.new(email: "b@b.com", password: "manager", password_confirmation: "manager")
  user.skip_confirmation!
  user.save!
end

create_listings(user)

5.times do
  p = Faker::Internet.base64
  user = User.new(email: Faker::Internet.email, password: p, encrypted_password: p, full_name: Faker::Name.name, avatar_url: "https://loremflickr.com/320/240")
  user.skip_confirmation!
  user.save!

  create_listings(user)
end

# Update nightly price and cleaning fee for all listings that have nightly price set to nil
Listing.where(nightly_price: nil).update_all(nightly_price: 200, cleaning_fee: 60)

Listing.where(stripe_product_id: nil).each { |listing| listing.create_stripe_product }

User.where(stripe_customer_id: nil).each { |user| user.touch }
