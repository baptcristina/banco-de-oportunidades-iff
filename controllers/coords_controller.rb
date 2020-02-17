class CoordsController < ApplicationController
  before_action :set_coord, only: [:show, :edit, :update, :destroy]

  # GET /coords
  # GET /coords.json
  def index

    asCoord = Coord.where(admin_id: params[:admin_id])
    @coords = asCoord.paginate(page: params[:page], per_page: 5).order("curso_id")
  end

  # GET /coords/1
  # GET /coords/1.json
  def show
  end

  # GET /coords/new
  def new
    @coord = Coord.new
  end

  # GET /coords/1/edit
  def edit

  end

  # POST /coords
  # POST /coords.json
  def create
    @coord = Coord.new(coord_params)
    admin_id = @coord.admin_id
    respond_to do |format|
      if @coord.save
        format.html { redirect_to coords_path(admin_id: admin_id), notice: 'Coord was successfully created.' }
        format.json { render :show, status: :created, location: @coord }
      else
        format.html { render :new }
        format.json { render json: @coord.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coords/1
  # PATCH/PUT /coords/1.json
  def update
    admin_id = @coord.admin_id
    respond_to do |format|
      if @coord.update(coord_params)
        format.html { redirect_to coords_path(admin_id: admin_id), notice: 'Coord was successfully updated.' }
        format.json { render :show, status: :ok, location: @coord }
      else
        format.html { render :edit }
        format.json { render json: @coord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coords/1
  # DELETE /coords/1.json
  def destroy
    admin_id = @coord.admin_id
    @coord.destroy
    respond_to do |format|
      format.html { redirect_to coords_path(admin_id: admin_id), notice: 'Coord was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coord
      @coord = Coord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coord_params
      params.require(:coord).permit(:admin_id, :curso_id)
    end
end
