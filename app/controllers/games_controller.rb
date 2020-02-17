require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
    @start_time = Time.now
  end

  def score
    time_taken = params[:end_time].to_datetime - params[:start_time].to_datetime
    attempt = params[:answer]
    result = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    att_arr = attempt.upcase.chars
    @display = if !att_arr.all? { |letter| att_arr.count(letter) <= params[:letters].split('').count(letter) }
                 "time: #{time_taken}, score: 0, #{attempt} is not in the grid."
               elsif !result['found']
                 "time: #{time_taken}, score: 0, #{attempt} is not an english word."
               else
                 "time: #{time_taken}, score: #{(100 * result['length'])} - Well done!"
               end
  end
end
