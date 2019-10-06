# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  attrs = { name: Faker::Book.genre }

  subject { described_class.new(attrs) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without attributes' do
      expect(described_class.new).to_not be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should have_many(:hours) }

    it 'hour belongs to the current category' do
      category = create(:category)
      report = create(:report)
      hour = create(:hour, category: category, report: report)
      expect(hour.category).to eq(category)
    end
  end
end
