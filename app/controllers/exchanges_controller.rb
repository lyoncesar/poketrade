class ExchangesController < ApplicationController
  def index
    @exchanges = Exchange.all
  end

  def new
    @exchange = Exchange.new
  end

  def create
    contract = TradeContract.new.call(trade_params.to_h)

    if contract.errors.blank?
      adapter = TradeAdapter.new(contract.to_h)
      @create_trade = CreateTradeService.new(adapter)

      if @create_trade.call
        flash[:success] = "A troca #{@create_trade.trade.id} foi registrada"
        redirect_to exchanges_path(@create_trade.trade)
      else
        flash.now[:error] = "Não foi possível salvar a troca de pokemons."
        render new_trade_path
      end
    else
      flash.now[:error] = "Não foi possível salvar a troca de pokemons."
      render new_trade_path
    end
  end

  private

  def trade_params
    params.require(:exchange).permit(:avg_receiving, :avg_sending, receiving: [], sending: [])
  end
end
