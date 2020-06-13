require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'validation' do
    let(:user) { create(:user) }
    let(:ticket) { create(:ticket) }

    it 'is valid with correct info' do
      expect(ticket).to be_valid
    end
    it 'is invalid without user id' do
      ticket.user_id = nil
      expect(ticket).to be_invalid
    end
    it 'is invalid without date' do
      ticket.date = nil
      expect(ticket).to be_invalid
    end
    it 'is invalid without public' do
      ticket.public = nil
      expect(ticket).to be_invalid
    end
    it 'is invalid without done' do
      ticket.done = nil
      expect(ticket).to be_invalid
    end
  end

  describe 'order' do
    context 'when done tickets' do
      let!(:ticket_a) { create(:ticket, date: Time.current.ago(10.day), done: true) }
      let!(:ticket_b) { create(:ticket, date: Time.current.ago(3.year), done: true) }
      let!(:ticket_c) { create(:ticket, date: Time.current.ago(2.month), done: true) }

      it 'sorts by newest date' do
        expect(Ticket.all.done.to_a).to eq [ticket_a, ticket_c, ticket_b]
      end
    end

    context 'when upcomming tickets' do
      let!(:ticket_a) { create(:ticket, date: Time.current.since(10.day), done: false) }
      let!(:ticket_b) { create(:ticket, date: Time.current.since(3.year), done: false) }
      let!(:ticket_c) { create(:ticket, date: Time.current.since(2.month), done: false) }

      it 'sorts by oldest date' do
        expect(Ticket.all.upcomming.to_a).to eq [ticket_a, ticket_c, ticket_b]
      end
    end

    context 'when unsolved tickets' do
      let!(:ticket_a) { create(:ticket, date: Time.current.ago(10.day), done: false) }
      let!(:ticket_b) { create(:ticket, date: Time.current.ago(3.year), done: false) }
      let!(:ticket_c) { create(:ticket, date: Time.current.ago(2.month), done: false) }

      it 'sorts by newest date' do
        expect(Ticket.all.unsolved.to_a).to eq [ticket_a, ticket_c, ticket_b]
      end
    end
  end
end
