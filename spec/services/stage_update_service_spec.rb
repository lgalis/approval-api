RSpec.describe StageUpdateService do
  let(:request) { create(:request) }
  let!(:stage1) { create(:stage, :request => request) }
  let!(:stage2) { create(:stage, :request => request) }
  let(:svc1)    { described_class.new(stage1.id) }
  let(:svc2)    { described_class.new(stage2.id) }
  let!(:event_service) { EventService.new(request) }

  before do
    allow(EventService).to  receive(:new).with(request).and_return(event_service)
    allow(event_service).to receive(:request_started)
    allow(event_service).to receive(:request_finished)
  end

  context 'state becomes notified' do
    it 'sends approver_group_notified event and updates request' do
      expect(event_service).to receive(:approver_group_notified)
      svc1.update(:state => Stage::NOTIFIED_STATE)
      stage1.reload
      request.reload
      expect(stage1.state).to eq(Stage::NOTIFIED_STATE)
      expect(request.state).to eq(Request::NOTIFIED_STATE)
    end
  end

  context 'state becomes finished' do
    it 'sends approver_group_finished event and updates request' do
      expect(event_service).to receive(:approver_group_finished)
      svc2.update(:state => Stage::FINISHED_STATE)
      stage2.reload
      request.reload
      expect(stage2.state).to eq(Stage::FINISHED_STATE)
      expect(request.state).to eq(Stage::FINISHED_STATE)
    end
  end

  context 'state unchanged' do
    it 'sends no events' do
      expect(event_service).not_to receive(:approver_group_notified)
      expect(event_service).not_to receive(:approver_group_finished)
      svc1.update(:reason => 'another reason')
      stage1.reload
      expect(stage1.reason).to eq('another reason')
    end
  end
end
