class LabelsController < ApplicationController
  before_action :set_label, only: [:edit, :update, :destroy]
  before_action :authenticate_user

  def index
    @labels = current_user.labels
    @labels = @labels.page(params[:page]).per(8)
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.build(label_params)
    if @label.save
      redirect_to labels_path, flash: {success: t('notice.label.create', label: @label.name)}
    else
      flash.now[:danger] = t('alert.label.create')
      render :new
    end
  end

  def edit; end

  def update
    if @label.update(label_params)
      redirect_to labels_path, flash: {success: t('notice.label.update', label: @label.name)}
    else
      flash.now[:danger] = t('alert.label.update')
      render :edit
    end
  end

  def destroy
    @label.destroy
    redirect_to labels_path flash: {success: t('notice.label.destroy', label: @label.name)}
  end

  private
  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
