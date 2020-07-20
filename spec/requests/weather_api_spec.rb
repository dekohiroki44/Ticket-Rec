require 'rails_helper'
require 'webmock/rspec'
require 'httpclient'
WebMock.allow_net_connect!

RSpec.describe 'weather_api', type: :request do
  describe 'gets info of future' do
    let(:ticket) { create(:ticket, date: DateTime.current + 1) }
    let(:key) { Rails.application.credentials.open_weather_map[:api_key] }
    let(:url) { "https://api.openweathermap.org/data/2.5/forecast" }
    let(:query) { { "lat": "35.68944", "lon": "139.69167", "units": "metric", "APPID": key } }

    context 'when works normally' do
      it 'returns 200 status and correct info' do
        stub_request(:get, url).
          with(query: query).
          to_return(status: 200, body: ['01d', '16'])
        client = HTTPClient.new
        response = client.get(url, query)
        expect(response.status).to eq 200
        expect(response.body).to eq ['01d', '16']
      end
    end

    context 'when works normally' do
      it 'returns 500 status and []' do
        stub_request(:get, url).
          with(query: query).
          to_return(status: 500, body: [])
        client = HTTPClient.new
        response = client.get(url, query)
        expect(response.status).to eq 500
        expect(response.body).to eq []
      end
    end
  end
end
