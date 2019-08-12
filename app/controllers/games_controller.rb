require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]
    @english = english?(params[:word])
    @check = grid_check(params[:word], @letters)
    verify
  end

  private

  def verify
    if @english == false
      @result = "Sorry, #{params[:word].upcase} is not an english word"
    elsif @english == true && @check == false
      @result = "Sorry, but #{params[:word].upcase} can't be built from #{@letters.join(',')}"
    elsif @english == true && @check == true
      @result = "Well done mate, your score is #{@word.length**3}"
    elsif @word.strip.empty?
      @result = "Please try to make a word"
    end
  end

  def english?(word)
    # @egg = "cheese"
    if word.strip.empty?
      verify
    else
      word_serialized = open("https://wagon-dictionary.herokuapp.com/#{word}").read
      entry = JSON.parse(word_serialized)
      entry['found']
    end
  end

  def grid_check(guess, grid)
    attempt_arr = guess.upcase.chars
    attempt_arr.each do |let|
      return false if attempt_arr.count(let) > grid.count(let)
    end
    true
  end
end
