class AnimatorsController < ApplicationController
  before_action :set_animator, only: %i(edit update)

  def new
    @animator = Animator.new
    authorize @animator
    @workshop = Workshop.find(params[:workshop_id])
    @users = User.all.select { |user| user.profile.role == 'animateur' }
  end

  def create
    @animator = Animator.new
    authorize @animator
    @animator.workshop = Workshop.find(params[:workshop_id])
    @animator.user = User.find(params[:animator][:user_id])
    if @animator.save
      flash[:notice] = "L'animateur #{@animator.user.profile.company} a bien été ajouté !"
      redirect_back fallback_location: root_path
    else
      @users = User.all.select { |user| user.profile.role == 'animateur' }
      render 'new'
    end
  end

  def edit
    @users = User.all.select { |user| user.profile.role == 'animateur' }
  end

  def update
    @user = User.find(params[:animator][:user_id])
    @animator.update(user: @user)
    if @animator.save
      redirect_to workshop_path(@animator.workshop)
    else
      @users = User.all.select { |user| user.profile.role == 'animateur' }
      render 'edit'
    end
  end

  private

  def set_animator
    @animator = Animator.find(params[:id])
    authorize @animator
  end
end
