require 'open-uri'
require 'json'

class GameController < ApplicationController
  def new
    @grid = generate_grid(10)
    session[:grid] = @grid
  end

  def score
    @score = session[:tempScore]
    @message = session[:tempMessage]
    if session[:score]
      session[:score] += @score
    else
      session[:score] = 1
    end

    if session[:count]
      session[:count] += 1
    else
      session[:count] = 1
    end

    @total_score = session[:score]
    @num_games = session[:count]
  end

  def calc
    @answer = params['answer']
    @grid = session[:grid]
    result = run_game(@answer, @grid)
    session[:tempScore] = result[:score]
    session[:tempMessage] = result[:message]
    redirect_to :action => "score"

  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    arr = []
    grid_size.times { arr.push(('A'..'Z').to_a.sample) }
    arr
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
