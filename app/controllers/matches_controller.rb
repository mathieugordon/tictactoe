class MatchesController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @opponents = User.where.not(id: current_user.id)
  end

  def create
    if params[:icon] == "X"
      @match = Match.new(player_x_id: current_user.id, player_o_id: match_params[:player_o_id])
    else
      @match = Match.new(player_x_id: match_params[:player_o_id], player_o_id: current_user.id)
    end
    if @match.save
      redirect_to(@match)
    else
      render :new
    end
  end

  def move
    @match = Match.find(params[:id])
    @move = Move.new(match_id: @match.id, player_id: current_user.id, cell: params[:cell], marker: @match.marker(current_user))
    if @move.save
      @match.analyze!
      redirect_to(@match)
    else
      render :show
    end
  end

  def match_params
    params.require(:match).permit(
      :player_o_id
      )
  end

end