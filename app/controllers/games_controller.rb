require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase
    # raise
    if !check_word(@word.downcase)
      @result = "Sorry but #{@word} does not seem to be a valid English word.."
    elsif word_is_valid?(@word.downcase, @letters.downcase)
      @result = "Congratulations! #{@word} is a valid English word!"
    else
      @result = "Sorry but #{@word} can't be built out of #{@letters.chars.join(',')}"
    end
  end

  private

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
