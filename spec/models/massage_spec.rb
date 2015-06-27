describe Massage do
  describe 'validations' do
    it { should validate_presence_of(:timetable) }
    it { should validate_presence_of(:masseur_id) }
    it { should validate_presence_of(:user_id) }
  end
end
