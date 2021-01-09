require 'poke-api-v2'

module Api
  module V1
    class TradesController < Api::V1::BaseController
      def trade_validate
        contract = TradeContract.new.call(trade_params.to_h)

        if contract.errors.blank?
          adapter = TradeAdapter.new(contract.to_h)
          @pokemons_list = FetchPokemonsService.new(adapter)
        
          begin
            @trade_report = TradePolicy.new(@pokemons_list).call
          rescue
            head 400
          end

          render json: { data: @trade_report }, status: :ok unless @trade_report.blank?
        else
          render json: { data: contract.errors.to_h }, status: :unprocessable_entity
        end
      end

      private

      def trade_params
        params.require(:data).permit(sending: [], receiving: [])
      end
    end
  end
end
