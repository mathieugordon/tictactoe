class MatchesController < ApplicationController

  load_and_authorize_resource

  def index
    @matches_in_progress = Match.where('status = ? AND (player_x_id = ? OR player_o_id = ?)', "in progress", current_user.id, current_user.id)
    @completed_matches = Match.where('(status = ? OR status = ?) AND (player_x_id = ? OR player_o_id = ?)', "won", "drawn", current_user.id, current_user.id)
  end

  def show
  end

  def new
    @opponents = User.where.not(id: current_user.id)
  end

  def create
    if params[:icon] == "X"
      @match = Match.create(player_x_id: current_user.id, player_o_id: match_params[:player_o_id], status: "in progress")
    else
      @match = Match.create(player_x_id: match_params[:player_o_id], player_o_id: current_user.id, status: "in progress")
    end
    if @match.save
      @match.check_and_update!
      redirect_to(@match)
    else
      render :new
    end
  end

  def move
    @match = Match.find(params[:id])
    @move = Move.create(match_id: @match.id, player_id: current_user.id, cell: params[:cell], marker: @match.marker(current_user))
    if @move.save
      @match.check_and_update!
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