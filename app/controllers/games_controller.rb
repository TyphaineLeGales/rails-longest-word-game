require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = 10.times.map { alphabet.sample }
  end

  def score
    @letters = params[:letters].downcase.split
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = open(url).read
    puts user = JSON.parse(user_serialized)
    @result = {}
    if user['found'] == false
      @result[:score] = 0
      @result[:message] = "#{@word} is not an english word"
    elsif @word.chars.all? { |letter| @letters.include?(letter) } == false
      @result[:score] = -1
      @result[:message] = "#{@word} is not in the grid"
    elsif @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) } == false
      @result[:score] = 0
      @result[:message] = "#{@word} is not in the grid"
    else
      @result[:score] = user['length'].to_i + 1
      @result[:message] = 'Well done !'
    end
    @result
  end
end
