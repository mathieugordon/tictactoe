class MatchesController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to(@match)
    else
      render :new
    end
  end

  def match_params
    params.require(:match).permit(
      :player_x_id,
      :player_o_id
      )
  end

end