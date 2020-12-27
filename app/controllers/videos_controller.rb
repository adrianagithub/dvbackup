class VideosController < InheritedResources::Base
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  layout 'video_layout'
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  
  def video_params
    params.require(:video).permit(:title, :description, :clip)#, :thumbnail)
  end
  # GET /videos
  # GET /videos.json
  def index
    #byebug
    @videos = Video.all
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    #@clip = Video.find(params[:clip])
    #@clip = Video.find.params[:clip]
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
    #byebug
    #@clip = Video.find(params[:clip])
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)
    if @video.save
      if params[:video][:clip].present? 
        @video.clip.attach(params[:video][:clip])
        #@video.picture.attach(@picture)
      end
      flash.notice = "The video record was created successfully."
      redirect_to @video
    else
      flash.now.alert = @video.errors.full_messages.to_sentence
      render :new  
    end
    # @customer = Customer.new(customer_params)
    # respond_to do |format|
    #   if @customer.save
    #     format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
    #     format.json { render :show, status: :created, location: @customer }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @customer.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    if @video.update(video_params)
      # byebug
      if params[:video][:clip].present?
        # byebug 
        @video.clip.attach(params[:video][:clip])
        #@video.picture.attach(@picture)
      end
      flash.notice = "The video record was updated successfully."
      redirect_to @video
    else
      # byebug
      flash.now.alert = @video.errors.full_messages.to_sentence
      render :edit
    end
    #params[:video][:pictures].each do |picture| more than one
    # respond_to do |format|
    #   if @customer.update(customer_params)
    #     format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @customer }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @customer.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
      #@picture = Video.find(params[:picture])        
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.require(:video).permit(:title, :description, :clip)
    end
    def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to videos_path
    end
    

end
