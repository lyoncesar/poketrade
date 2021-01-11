class TradeContract < Dry::Validation::Contract
  params do
    required(:receiving).filled(:array)
    required(:sending).filled(:array)
    optional(:avg_receiving).value(:string)
    optional(:avg_sending).value(:string)
  end

  rule(:sending) do
    key.failure(
      'The trade is limited of 6 Pokemons over each side'
    ) if value.count > 6

    key.failure("Can't be empty") if array_blank?(value)
  end

  rule(:receiving) do
    key.failure(
      'The trade is limited of 6 Pokemons over each side'
    ) if value.count > 6

    key.failure("Can't be empty") if array_blank?(value)
  end

  private

  def array_blank?(array)
    test = array.map do |item|
      item unless item.blank?
    end.blank?
  end
end
