require 'sinatra/base'
require 'sinatra'

require './lib/game.rb'
require './lib/player.rb'

class Battle < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    erb(:index)
  end

  post '/names' do
    p_one = Player.new(params[:p1_name])
    p_two = Player.new(params[:p2_name])
    @game = Game.new(p_one, p_two)

    redirect '/play'
  end

  before do
    @game = Game.instance
  end

  get '/play' do
    erb(:play)
  end

  get '/attack' do
    @game.attack
    if @game.game_over?
      redirect '/game_over'
    else
      @game.switch_turn
      erb(:attack)
    end
  end

  get '/game_over' do
    erb(:game_over)
  end

  run! if app_file == $0

end
