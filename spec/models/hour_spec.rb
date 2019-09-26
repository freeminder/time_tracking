require "rails_helper"

RSpec.describe Hour, :type => :model do
  attrs = {}
  Date::DAYNAMES.map { |dayname| attrs.merge!(dayname.downcase.to_sym => Faker::Number.number(1)) }

  subject {
    described_class.new(attrs)
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      subject.report = create(:report)
      subject.category = create(:category)
      expect(subject).to be_valid
    end

    it "is not valid without attributes" do
      expect(described_class.new).to_not be_valid
    end

    it "is not valid without a category" do
      subject.report = create(:report)
      expect(subject).to_not be_valid
    end

    it "should replace zero values with nil" do
      dayname = Date::DAYNAMES.sample.downcase
      subject[dayname] = 0
      subject.validate
      expect(subject.send(dayname)).to eq nil
    end
  end

  describe "Associations" do
    it { should belong_to(:report) }
    it { should belong_to(:category) }
  end

  describe "Object Methods" do
    it "#week_attrs" do
      expect(subject.week_attrs).to eq(subject.attributes.except("id", "created_at", "report_id", "category_id"))
    end
  end
end
