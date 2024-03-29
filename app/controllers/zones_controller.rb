class ZonesController < ApplicationController
  load_and_authorize_resource

  def import
    file = params[:file]
    return redirect_to zones_path, notice: 'Sólo se admite formato de separación de comas (.CSV)' unless file.content_type == 'text/csv'

    CsvImportZonesService.new.call(file)

    redirect_to zones_path, notice: 'ZONAS IMPORTADAS EXITOSAMENTE'
  end

  # GET /zones or /zones.json
  def index
    @zones = Zone.all
    if params[:query_text].present?
      @zones = @zones.search_full_text(params[:query_text])
    end
  end

  # GET /zones/1 or /zones/1.json
  def show
  end

  # GET /zones/new
  def new
    @zone = Zone.new
  end

  # GET /zones/1/edit
  def edit
    @zone=Zone.find(params[:id])
  end

  # POST /zones or /zones.json
  def create
    @zone = Zone.new(zone_params)

    respond_to do |format|
      if @zone.save
        format.html { redirect_to zones_path, notice: 'Tu zona se ha creado correctamente', status: :see_other }
        format.json { render :show, status: :created, location: @zone }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /zones/1 or /zones/1.json
  def update
    respond_to do |format|
      if @zone.update(zone_params)
        format.html { redirect_to zones_path, notice: 'Tu zona se ha actualizado correctamente', status: :see_other }
        format.json { render :show, status: :ok, location: @zone }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zones/1 or /zones/1.json
  def destroy
    zone = Zone.find(params[:id])
    zone.destroy
    redirect_to zones_path, notice: 'Tu zona se ha eliminado correctamente', status: :see_other
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zone
      @zone = Zone.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def zone_params
      params.require(:zone).permit(:id, :description)
    end
end
