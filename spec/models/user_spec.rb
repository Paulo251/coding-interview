# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:company) { create(:company) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:display_name) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:tweets).dependent(:destroy) }
  end

  describe 'scopes' do
    let!(:user1) { create(:user, company: company, username: 'john_doe') }
    let!(:user2) { create(:user, company: create(:company), username: 'jane_smith') }

    it 'filters by company' do
      expect(User.by_company(company.id)).to include(user1)
      expect(User.by_company(company.id)).not_to include(user2)
    end

    it 'filters by username with ILIKE' do
      expect(User.by_username('JOHN')).to include(user1)
      expect(User.by_username('jane')).to include(user2)
      expect(User.by_username('nonexistent')).to be_empty
    end
  end

  describe 'callbacks' do
    it 'sends welcome email after creation' do
      user = build(:user, company: company)
      expect(UserMailer).to receive(:welcome_email).with(user).and_return(double(deliver_later: true))
      user.save!
    end
  end
end
