require 'rails_helper'

RSpec.describe 'Api::V1::Trades', type: :request do
  describe'POST #trade_validate' do
    let(:params) do
      {
        data: {
           sending: [
              "Farfetch'd",
              "Pikachu",
              "Charmander",
              "Wooloo",
              "Nidoking",
              "Venomoth"
          ],
          receiving: [
              "Pikachu",
              "Charmander",
              "Sandaconda",
              "Zubat",
              "Alakazam",
              "Drowzee"
          ]
        }  
      }
    end

    it 'return a json with trade data' do
      VCR.use_cassette('api_v1_trade_controller' ) do
        post trade_validate_path(params)
      end

      expect(response.body).to eq(
        {
          data: {
            trade: {
              sending: [
                  {
                      pokemon: "farfetchd",
                      base_experience: 132
                  },
                  {
                      pokemon: "pikachu",
                      base_experience: 112
                  },
                  {
                      pokemon: "charmander",
                      base_experience: 62
                  },
                  {
                      pokemon: "wooloo",
                      base_experience: 122
                  },
                  {
                      pokemon: "nidoking",
                      base_experience: 227
                  },
                  {
                      pokemon: "venomoth",
                      base_experience: 158
                  }
              ],
              receiving: [
                  {
                      pokemon: "pikachu",
                      base_experience: 112
                  },
                  {
                      pokemon: "charmander",
                      base_experience: 62
                  },
                  {
                      pokemon: "sandaconda",
                      base_experience: 179
                  },
                  {
                      pokemon: "zubat",
                      base_experience: 49
                  },
                  {
                      pokemon: "alakazam",
                      base_experience: 225
                  },
                  {
                      pokemon: "drowzee",
                      base_experience: 66
                  }
              ]
            },
            fair_trade: false,
            average_xp_send: 135,
            average_xp_receive: 115,
            unknown_pokemons: []
          }
        }.to_json
      )
    end

    it 'return a json talking if is a fair trade' do
      params.dig(:data, :sending).pop(4)
      params.dig(:data, :receiving).pop(4)

      VCR.use_cassette('false_fair_trade') do
        post trade_validate_path(params)
      end
      
      fair_trade = JSON.parse(response.body).dig('data', 'fair_trade')

      expect(fair_trade).to be_falsey
    end

  end
end
