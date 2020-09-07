require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def included_grid?(array_letters, array_grid)
    array_letters.all? do |letter|
      array_grid.include?(letter)
    end
  end

  def english?(user_word)
    url = "https://wagon-dictionary.herokuapp.com/#{user_word}"
    user_serialized = open(url).read
    word = JSON.parse(user_serialized)

    word["found"] == true
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]

    array_letters = @word.split("")
    array_grid = @letters.split(" ")

    if !included_grid?(array_letters, array_grid)
      @message = "Sorry, but #{@word} can't be build out of #{@letters}"
    elsif !english?(@word)
      @message = "Sorry, but #{@word} does not seem to be a valid English word..."
    elsif included_grid?(array_letters, array_grid) && english?(@word)
      @message = "Congratulations! #{@word} is a valid English word!"
    end
    @message
  end
end
