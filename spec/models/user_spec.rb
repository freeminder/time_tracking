require "rails_helper"

RSpec.describe User, :type => :model do
  attrs = {
    email: Faker::Internet.email,
    password: Faker::Internet.password(8, 128),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  }

  subject {
    attrs[:email] = "another_#{attrs[:email]}" # avoid dup
    described_class.new(attrs)
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without attributes" do
      expect(described_class.new).to_not be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a first name" do
      subject.first_name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a last name" do
      subject.last_name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a first name less than 2 characters" do
      subject.first_name = Faker::Name.first_name[0]
      expect(subject).to_not be_valid
    end

    it "is not valid with a last name less than 2 characters" do
      subject.first_name = Faker::Name.last_name[0]
      expect(subject).to_not be_valid
    end

    it "is not valid with invalid email format" do
      subject.email = "test@test"
      expect(subject).to_not be_valid
    end

    it "is not valid with a password shorter than 8 characters" do
      subject.password = Faker::Internet.password(1, 7)
      expect(subject).to_not be_valid
    end

    it "is not valid with a password longer than 128 characters" do
      subject.password = Faker::Internet.password(128, 200)
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it { should belong_to(:team) }
    it { should have_many(:reports) }
    it { should have_many(:hours) }

    it "Report belongs to the current user" do
      user = create(:user)
      report = create(:report, user: user)
      category = create(:category)
      hour = create(:hour, report: report, category: category)
      expect(report.user).to eq(user)
    end

    it "Hour belongs to the current user" do
      user = create(:user)
      report = create(:report, user: user)
      category = create(:category)
      hour = create(:hour, report: report, category: category)
      expect(hour.user).to eq(user)
    end
  end

  describe "Object Methods" do
    it "#full_name" do
      expect(subject.full_name).to eq("#{subject.first_name} #{subject.last_name}")
    end
  end
end
