# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  attrs = { name: Faker::Commerce.department }

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
    it { should have_many(:users) }

    it 'user belongs to the current team' do
      team = create(:team)
      user = create(:user, team: team)
      expect(user.team).to eq(team)
    end
  end
end
