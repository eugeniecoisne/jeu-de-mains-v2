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
    @animator.db_status = 'actif'
    if @animator.save
      redirect_to workshop_path(@animator.workshop)
    else
      @users = User.all.where(role: 'animateur')
      render 'new'
    end
  end

  def edit
    @users = User.all.select { |user| user.profile.role == 'animateur' }
  end

  def update
    @workshop = @animator.workshop
    @animator.update!(db_status: 'inactif')
    @new_animator = Animator.new
    @new_animator.workshop = @workshop
    @new_animator.user = User.find(params[:animator][:user_id])
    @new_animator.db_status = 'actif'
    if @new_animator.save
      redirect_to workshop_path(@new_animator.workshop)
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
