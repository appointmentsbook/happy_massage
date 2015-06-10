describe Massage do
  describe 'validations' do
    it { should validate_presence_of(:timetable) }
    it { should validate_presence_of(:masseur) }
  end
end
