class AnimatorsController < ApplicationController
  before_action :set_animator, only: %i(edit update)

  def create
    @animator = Animator.new
    authorize @animator
    @animator.workshop = Workshop.friendly.find(params[:workshop_id])
    @animator.user = User.find(params[:animator][:user_id])
    if @animator.save
      mail = AnimatorMailer.with(animator: @animator).new_animator
      mail.deliver_later
      if params[:animator][:creation].present?
        redirect_to confirmation_workshop_path(@animator.workshop)
      else
        redirect_back fallback_location: root_path
        flash[:notice] = "L'animateur #{@animator.user.profile.company} a bien été ajouté !"
      end
    else
      @users = User.all.select { |user| user.profile.role == 'animateur' }
      render 'new'
    end
  end

  def update
    @user = User.find(params[:animator][:user_id])
    @animator.update(user: @user)
    if @animator.save
      mail = AnimatorMailer.with(animator: @animator).new_animator
      mail.deliver_later
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path
    end
  end

  private

  def set_animator
    @animator = Animator.find(params[:id])
    authorize @animator
  end

end
