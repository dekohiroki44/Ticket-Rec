# require 'rails_helper'
# require 'webmock/rspec'
# require 'httpclient'
# WebMock.allow_net_connect!

# RSpec.describe 'weather_api', type: :request do
#   describe 'gets info of future' do
#     let(:key) { Rails.application.credentials.open_weather_map[:api_key] }
#     let(:url) { "https://api.openweathermap.org/data/2.5/forecast" }
#     let(:query) { { "lat": "35.68944", "lon": "139.69167", "units": "metric", "APPID": key } }

#     context 'when works normally' do
#       it 'returns 200 status and correct info' do
#         stub_request(:get, url).
#           with(query: query).
#           to_return(status: 200, body: ['01d', '16'])
#         get url, params: query
#         expect(response.status).to eq 200
#         expect(response.body).to eq ['01d', '16']
#       end
#     end
#   end
# end
