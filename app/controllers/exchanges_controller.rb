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
        binding.pry
        TradeMailer.with(trade: @create_trade.trade).new_email.deliver_later

        flash[:success] = I18n.t('flash.persist_success')
        redirect_to exchanges_path(@create_trade.trade)
      else
        flash.now[:error] = I18n.t(
          'errors.messages.model_invalid',
          errors: @create_trade.errors.messages
        )

        render new_trade_path
      end
    else
      flash.now[:error] = I18n.t(
        'errors.messages.model_invalid',
        errors: @create_trade.errors.messages
      )

      render new_trade_path
    end
  end

  private

  def trade_params
    params.require(:exchange).permit(:avg_receiving, :avg_sending, receiving: [], sending: [])
  end
end
