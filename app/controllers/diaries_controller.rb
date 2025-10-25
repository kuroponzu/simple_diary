class DiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_diary, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_diary, only: [ :show, :edit, :update, :destroy ]

  def index
    @diaries = current_user.diaries.order(created_at: :desc)
  end

  def show
  end

  def new
    @diary = current_user.diaries.build
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      redirect_to @diary, notice: "Diary was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @diary.update(diary_params)
      redirect_to @diary, notice: "Diary was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @diary.destroy
    redirect_to diaries_path, notice: "Diary was successfully destroyed."
  end

  private

  def set_diary
    @diary = Diary.find(params[:id])
  end

  def authorize_diary
    unless @diary.user == current_user
      redirect_to diaries_path, alert: "You are not authorized to access this diary."
    end
  end

  def diary_params
    params.require(:diary).permit(:title, :content)
  end
end
