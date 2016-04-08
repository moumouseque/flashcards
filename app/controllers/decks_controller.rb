class DecksController < ApplicationController
  def index
    @deck = current_user.decks
#    @active_deck = current_user.decks.find_by_active(true)
  end

  def new
    @deck = Deck.new
  end

  def edit
    @deck = Deck.find(params[:id])
  end
  
  def create
    @deck = Deck.new(deck_params)
    if @deck.save   
      current_user.decks.make_active(@deck.id) if @deck.active
      redirect_to decks_path
    else
      render 'new'
    end
  end

  def update
    @deck = Deck.find(params[:id])
    if @deck.update(deck_params)
      redirect_to decks_path
    else
      render 'edit'
    end
  end

  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy
    redirect_to decks_path
  end

  def active_deck
    @deck = Deck.find(params[:active_deck][:deck_id])
    @deck.update(active: true)
    current_user.decks.make_active(params[:active_deck][:deck_id])
    redirect_to decks_path
  end

  private
    def deck_params
      params.require(:deck).permit(:name, :active, :user_id)
    end
end