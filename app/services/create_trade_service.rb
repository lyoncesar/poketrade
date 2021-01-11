class CreateTradeService
  def initialize(params)
    @params = params
  end

  def call
    create_trade
  end

  def trade
    @trade
  end

  private

  attr_reader :params
  
  def create_trade
    @trade = Exchange.new(build_trade)

    @trade.save
  end

  def build_trade
    {
      avg_receiving: params.avg_receiving,
      avg_sending: params.avg_sending,
      receiving: filter_list(params.receiving),
      sending: filter_list(params.sending)
    }
  end

  def filter_list(list)
    list.map do |item|
      item unless item.blank?
    end.compact
  end
end
