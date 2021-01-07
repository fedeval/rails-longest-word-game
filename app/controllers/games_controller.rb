# frozen_string_literal: false
require 'open-uri'
require 'json'

# Controllers for new game user journey
class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
    session[:score] = 0 if session[:score].nil?
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase
    @result = compute_result(@word, @letters)
    update_score if @result.length == 2
    @total_score = session[:score]
  end

  private

  def compute_result(attempt, grid)
    if !check_word(attempt.downcase)
      ["Sorry but #{attempt} does not seem to be a valid English word.."]
    elsif word_is_valid?(attempt.downcase, grid.downcase)
      ["Congratulations! #{attempt} is a valid English word!", attempt.length]
    else
      ["Sorry but #{attempt} can't be built out of #{grid.chars.join(',')}"]
    end
  end

  def update_score
    @word_score = @result[1]
    session[:score] += @word_score
  end

  def check_word(word)
    word_serialised = open("https://wagon-dictionary.herokuapp.com/#{word.downcase}").read
    word_hash = JSON.parse(word_serialised)
    word_hash['found']
  end

  def word_is_valid?(attempt, grid)
    grid.chars.each do |letter|
      attempt.sub!(letter, '') if attempt.include? letter
    end
    attempt.size.zero?
  end
end
