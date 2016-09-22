module World
  module Directory::Person
    module Domain
      # @section helpers
      #
      def fetch_person
        Renalware::Directory::Person.first_or_initialize
      end

      def valid_person_attributes
        {
          given_name: Faker::Name.first_name,
          family_name: Faker::Name.last_name,
          title: Faker::Name.prefix,
          address_attributes: {
            name: Faker::Name.name,
            street_1: Faker::Address.street_address,
            city: Faker::Address.city
          }
        }
      end

      # @section seeding
      #
      def seed_person(user: Renalware::User.first, attributes: {})
        Renalware::Directory::Person.create!(
          valid_person_attributes
            .merge(by: user)
            .merge(attributes)
        )
      end

      def seed_people(table)
        table.hashes.each do |row|
          attributes = {
            given_name: row[:given_name],
            family_name: row[:family_name]
          }
          seed_person(attributes: attributes)
        end
      end

      def view_people(q: nil, **_)
        @query = Renalware::Directory::PersonQuery.new(q: q)
      end


      # @section commands
      #
      def create_person(user:, attributes: {})
        Renalware::Directory::Person.create(
          valid_person_attributes
            .merge(by: user)
            .merge(attributes)
        )
      end

      def update_person(user:)
        travel_to 1.hour.from_now

        person = fetch_person
        person.update_attributes!(
          title: "Monsieur",
          updated_at: Time.zone.now,
          by: user
        )
      end

      # @section expectations
      #
      def expect_person_to_exist
        person = Renalware::Directory::Person.first
        expect(person).to be_present
        expect(person.address).to be_present
      end

      def expect_person_to_be_refused
        expect(Renalware::Directory::Person.count).to eq(0)
      end

      def expect_people_to_be(table)
        people = @query.call
        expect(people.size).to eq(table.hashes.size)

        entries = people.map do |r|
          hash = {
            given_name: r.given_name,
            family_name: r.family_name
          }
          hash.with_indifferent_access
        end
        table.hashes.each do |row|
          expect(entries).to include(row)
        end
      end
    end


    module Web
      include Domain

      def create_person(user:, attributes: {})
        login_as user
        visit new_directory_person_path

        attr = valid_person_attributes.merge(attributes)

        fill_in "Given Name", with: attr[:given_name]
        fill_in "Family Name", with: attr[:family_name]
        fill_in "Title", with: attr[:title]

        fill_in "Name", with: attr[:address_attributes][:name]
        fill_in "Line 1", with: attr[:address_attributes][:street_1]
        fill_in "City", with: attr[:address_attributes][:city]

        click_on "Create"
      end

      def update_person(user:)
        login_as user
        visit directory_people_path
        click_on "Edit"

        fill_in "Title", with: "Monsieur"

        click_on "Save"
      end

      def view_people(q: nil, user:)
        login_as user
        visit directory_people_path(q: q)
      end

      def expect_people_to_be(table)
        table.hashes.each do |row|
          expect(page.body).to have_content(row[:given_name])
          expect(page.body).to have_content(row[:family_name])
        end
      end
    end
  end
end
