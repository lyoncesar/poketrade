class ExchangesController < ApplicationController
  def new
    @exchange = Exchange.new
  end

  def create
    binding.pry
  end
end
