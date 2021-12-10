require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
  end

  def score
    attempt = params[:word]
    letters = params[:token]
    @answer = run_game(attempt, letters)
  end

  def run_game(attempt, letters)
    errors = 0
    attempt.chars.each { |x| letters.include?(x) ? letters.delete_at(letters.index(x)) : errors += 1 }
    if errors.positive?
      { score: 0, message: "Sorry, #{attempt} is not in the grid!" }
    elsif answer_checker(attempt)
      score = attempt.size
      { score: score, message: "Well done, you scored #{score} point" }
    else
      { score: 0, message: "Sorry, #{attempt} is not an english word!" }
    end
  end

  def answer_checker(attempt)
    JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)["found"]
  end

  def generate_grid
    # TODO: generate random grid of letters for game
    alphabet_array = 'abcdefghijklmnopqrstuvwxyz'.chars
    grid = []
    10.times { grid << alphabet_array.sample(1) }
    grid.join
  end
end
