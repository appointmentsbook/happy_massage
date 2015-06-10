describe Penalty do
  describe 'validations' do
    it { should validate_presence_of :punished_at }
    it { should validate_presence_of :punished_until }
    it { should validate_presence_of :reported_by }
  end
end
