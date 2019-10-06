# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  subject { described_class.new }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      subject.user = create(:user)
      expect(subject).to be_valid
    end

    it 'is not valid without attributes' do
      expect(described_class.new).to_not be_valid
    end

    it 'is not valid without a user' do
      subject.user = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_many(:hours) }

    it 'category belongs to the current report through hour' do
      user = create(:user)
      category = create(:category)
      report = create(:report, user: user)
      create(:hour, report: report, category: category)
      expect(report.categories).to eq([category])
    end

    it 'hour belongs to the current report' do
      user = create(:user)
      category = create(:category)
      report = create(:report, user: user)
      hour = create(:hour, report: report, category: category)
      expect(hour.report).to eq(report)
    end
  end
end
