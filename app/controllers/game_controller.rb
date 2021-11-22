require 'open-uri'
require 'json'

class GameController < ApplicationController
  def new
    @grid = generate_grid(10)
    grid = @grid
  end

  def score
    @answer = params['answer']
    @grid = params['grid'].split
    result = run_game(@answer, @grid)
    @score = result[:score]
    @message = result[:message]
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    arr = []
    grid_size.times { arr.push(('A'..'Z').to_a.sample) }
    return arr
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    # 1) your word is an actual English word
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    check = JSON.parse(URI.open(url).read)
    # calc time taken
    # return message
    return result(check['found'], grid_check(attempt, grid), attempt)
  end

  def grid_check(attempt, grid)
    grid_check = true
    attempt.upcase.chars.each do |char|
      if grid.include?(char)
        grid.delete_at(grid.index(char))
      else
        grid_check = false
        break
      end
    end
    return grid_check
  end

  def result(found_check, grid_check, attempt)
    if !found_check || !grid_check
      score = 0
      message = found_check ? 'not in the grid' : 'not an english word'
    else
      score = attempt.length
      message = "Well Done!" if score.positive?
    end
    { score: score, message: message }
  end

end
