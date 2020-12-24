class TradeContract < Dry::Validation::Contract
  params do
    required(:sending).filled(:array)
    required(:receiving).filled(:array)
  end

  rule(:sending) do
    key.failure(
      'The trade is limited of 6 Pokemons over each side'
    ) if value.count > 6
  end

  rule(:receiving) do
    key.failure(
      'The trade is limited of 6 pokemons over each side'
    ) if value.count > 6
  end

end
