describe Schedule::MassageScheduler do
  let!(:masseur1) { create(:masseur) }
  let!(:masseur2) { create(:masseur) }
  let!(:masseur3) { create(:masseur) }

  describe '#schedule_massage' do
    let(:timetable) { Time.zone.parse('2015-08-12 9:00') }
    let(:user) { create(:user) }
    let(:args) do
      {
        timetable: timetable,
        user: user
      }
    end

    let(:timetable_error_message) do
      schedule_massage.errors.messages[:timetable].first
    end

    subject(:schedule_massage) { described_class.new(args).schedule_massage }

    context 'when timetable is not supplied' do
      let(:error_message) do
        'O horário para o agendamento é obrigatório e deve conter ' \
        'um valor compatível com as regras estabelecidas. Por favor, ' \
        'tente novamente.'
      end

      before do
        Timecop.freeze('2015-08-11 15:00')
        args.delete(:timetable)

        schedule_massage
      end

      after { Timecop.return }

      it { expect(timetable_error_message).to include(error_message) }
    end

    context 'when there is no availability for given timetable' do
      let(:error_message) { 'O horário escolhido não está disponível' }

      before do
        Timecop.freeze('2015-08-11 15:00')

        create(:massage, timetable: timetable, masseur_id: masseur1.id)
        create(:massage, timetable: timetable, masseur_id: masseur2.id)
        create(:massage, timetable: timetable, masseur_id: masseur3.id)
      end

      after { Timecop.return }

      context 'when user enters massage creation in a concurrency scenario' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:available_masseurs)
            .and_return(Masseur.first(3), Masseur.none)

          schedule_massage
        end

        it { expect(timetable_error_message).to include(error_message) }
      end

      context 'when user enters massage creation with no timetables left' do
        before { schedule_massage }

        it { expect(timetable_error_message).to include(error_message) }
      end
    end

    context 'when user has already scheduled a massage for a given date' do
      let(:error_message) { 'Você já possui um horário agendado.' }

      before do
        Timecop.freeze('2015-08-11 15:00')
        create(:massage, timetable: timetable, masseur_id: masseur1.id, user_id: user.id)

        schedule_massage
      end

      after { Timecop.return }

      it { expect(timetable_error_message).to include(error_message) }
    end

    context 'when massage scheduling is closed' do
      let(:error_message) { 'O agendamento de massagens está fechado.' }

      before do
        Timecop.freeze('2015-08-10 14:00')

        schedule_massage
      end

      after { Timecop.return }

      it { is_expected.to be_invalid }
      it { expect(timetable_error_message).to include(error_message) }
    end

    context 'when massage scheduling is open' do
      context 'but timetable is invalid' do
        let(:timetable) { Time.zone.parse('2015-08-12 9:01') }

        let(:error_message) do
          'O horário para o agendamento é obrigatório e deve ' \
          'conter um valor compatível com as regras estabelecidas.'
        end

        before do
          Timecop.freeze('2015-08-11 15:00')

          schedule_massage
        end

        after { Timecop.return }

        it { is_expected.to be_invalid }
        it { expect(timetable_error_message).to include(error_message) }
      end

      context 'and timetable is valid' do
        let(:timetable) { Time.zone.parse('2015-08-12 9:00') }

        before do
          Timecop.freeze('2015-08-11 15:00')

          schedule_massage
        end

        after { Timecop.return }

        it { is_expected.to be_valid }
        it { expect(schedule_massage.persisted?).to be true }
      end
    end
  end
end
